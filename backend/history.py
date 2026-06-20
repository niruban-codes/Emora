"""
history.py
----------
Blueprint: history_bp
Prefix:    /history

Endpoints:
  GET    /history/<uid>         — fetch all detections, newest first
  POST   /history/<uid>         — save a new detection
  DELETE /history/<uid>/<id>    — delete one detection

Firestore path:
  emotion_history/{uid}/detections/{detectionId}

Each document fields:
  emotion    : str
  confidence : float
  timestamp  : Firestore SERVER_TIMESTAMP (stored as DatetimeWithNanoseconds)
  tracks     : list of dicts  [{ videoId, title, artist, thumbnail }]
"""

from datetime import timezone
from flask import Blueprint, jsonify, request
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
from google.api_core.exceptions import NotFound, GoogleAPICallError
from firebase_config import db

#  Blueprint setup
history_bp = Blueprint("history", __name__, url_prefix="/history")

def _detections_ref(uid: str):
    """Shortcut: returns the 'detections' subcollection reference for a uid."""
    return db.collection("emotion_history").document(uid).collection("detections")


def _format_doc(doc) -> dict:
    """
    Convert a Firestore document snapshot into a JSON-serialisable dict.
    Timestamps are converted to 'YYYY-MM-DD HH:MM:SS' strings (UTC).
    """
    data = doc.to_dict()

    ts = data.get("timestamp")
    if ts is not None:
        try:
            dt = ts.ToDatetime() if hasattr(ts, "ToDatetime") else ts
            dt_utc = dt.replace(tzinfo=timezone.utc) if dt.tzinfo is None else dt
            data["timestamp"] = dt_utc.strftime("%Y-%m-%d %H:%M:%S")
        except Exception:
            data["timestamp"] = str(ts)

    
    if "emotion" in data and isinstance(data["emotion"], str):
        data["emotion"] = data["emotion"].capitalize()

    return {"id": doc.id, **data}


@history_bp.route("/<uid>", methods=["GET"])
def get_history(uid: str):
    """
    Return all emotion detections for a user, sorted newest → oldest.
    """
    try:
    
        docs = (
            _detections_ref(uid)
            .order_by("timestamp", direction="DESCENDING")
            .stream()
        )
        history = [_format_doc(doc) for doc in docs]
        return jsonify(history), 200

    except GoogleAPICallError as e:
        return jsonify({"error": "Firestore connection failed", "details": str(e)}), 500

    except Exception as e:
        return jsonify({"error": "Unexpected server error", "details": str(e)}), 500

@history_bp.route("/<uid>", methods=["POST"])
def save_history(uid: str):
    """
    Save a new detection for a user.

    Request body (JSON):
      {
        "emotion":    "happy",
        "confidence": 92.5,
        "tracks":     [ { videoId, title, artist, thumbnail }, ... ]
      }

    Success 201:
      { "id": "<new_doc_id>" }

    Errors:
      400 — missing required fields
      500 — Firestore write failed
    """
    body = request.get_json(silent=True)

    #Validate required fields 
    if not body:
        return jsonify({"error": "Request body must be JSON"}), 400

    missing = [f for f in ("emotion", "confidence") if f not in body]
    if missing:
        return jsonify({"error": f"Missing required fields: {missing}"}), 400

    emotion    = body["emotion"]
    confidence = body["confidence"]
    tracks     = body.get("tracks", [])

    # Type checks 
    if not isinstance(emotion, str) or not emotion.strip():
        return jsonify({"error": "'emotion' must be a non-empty string"}), 400

    if not isinstance(confidence, (int, float)):
        return jsonify({"error": "'confidence' must be a number"}), 400

    if not isinstance(tracks, list):
        return jsonify({"error": "'tracks' must be a list"}), 400

    # Write to Firestore 
    try:
        doc_data = {
            "emotion":    emotion.strip().lower(),
            "confidence": float(confidence),
            "tracks":     tracks,
            "timestamp":  SERVER_TIMESTAMP,  # Firestore fills this in server-side
        }

        # add() auto generates a document ID
        _, new_doc_ref = _detections_ref(uid).add(doc_data)

        return jsonify({"id": new_doc_ref.id}), 201

    except GoogleAPICallError as e:
        return jsonify({"error": "Firestore write failed", "details": str(e)}), 500

    except Exception as e:
        return jsonify({"error": "Unexpected server error", "details": str(e)}), 500



@history_bp.route("/<uid>/<doc_id>", methods=["DELETE"])
def delete_history(uid: str, doc_id: str):
    """
    Delete a single detection document.

    Success 200:
      { "status": "deleted" }

    Errors:
      404 — document does not exist
      500 — Firestore error
    """
    try:
        doc_ref = _detections_ref(uid).document(doc_id)

        snapshot = doc_ref.get()
        if not snapshot.exists:
            return jsonify({
                "error": f"Detection '{doc_id}' not found for user '{uid}'"
            }), 404

        doc_ref.delete()
        return jsonify({"status": "deleted"}), 200

    except GoogleAPICallError as e:
        return jsonify({"error": "Firestore error", "details": str(e)}), 500

    except Exception as e:
        return jsonify({"error": "Unexpected server error", "details": str(e)}), 500


@history_bp.route("/<uid>/analytics", methods=["GET"])
def get_mood_analytics(uid: str):
    """
    Fetch all emotion history logs for a user, calculate aggregate statistics,
    and return clean numbers to feed the Mood Analytics and Monthly UI screens.
    """
    try:
        # 1. Fetch all records from Firestore
        docs = _detections_ref(uid).stream()
        history = [_format_doc(doc) for doc in docs]

        total_scans = len(history)

        # Default placeholder package if the user hasn't scanned their face yet
        if total_scans == 0:
            return jsonify({
                "daily_average": "0.0",
                "mood_distribution": {
                    "Happy": "0%", "Sad": "0%", "Neutral": "0%",
                    "Fear": "0%", "Angry": "0%", "Surprised": "0%"
                },
                "happy_tracks_count": 0,
                "sad_tracks_count": 0,
                "primary_peak": "None",
                "total_scans": 0
            }), 200

        # 2. Setup counters for Mood Distribution mapping
        counts = {"Happy": 0, "Sad": 0, "Neutral": 0, "Fear": 0, "Angry": 0, "Surprised": 0}
        
        # Setup weights for the 10-point Weighted Vibe Index average calculation
        weights = {"Happy": 10, "Surprised": 8, "Neutral": 6, "Sad": 4, "Fear": 3, "Angry": 1}
        
        total_weight_score = 0
        happy_tracks_total = 0
        sad_tracks_total = 0

        # 3. Loop through history data array to compute values
        for record in history:
            emotion = record.get("emotion", "Neutral") # Defaults to Neutral if edge-case blank
            tracks_list = record.get("tracks", [])

            # Increment specific emotion counter if it fits our keys
            if emotion in counts:
                counts[emotion] += 1
                total_weight_score += weights[emotion]
            else:
                # Fallback for unexpected string variants
                total_weight_score += 6 

            # Count generated music recommendation arrays
            if emotion == "Happy":
                happy_tracks_total += len(tracks_list)
            elif emotion == "Sad":
                sad_tracks_total += len(tracks_list)

        # 4. Final Math Formatting Calculations
        daily_avg = round(total_weight_score / total_scans, 1)
        
        distribution_percentages = {}
        for mood, count in counts.items():
            percentage = round((count / total_scans) * 100)
            distribution_percentages[mood] = f"{percentage}%"

        # Identify which mood was recorded the most
        primary_peak = max(counts, key=counts.get) if any(counts.values()) else "Neutral"

        # 5. Pack everything neatly into JSON for Flutter
        analytics_payload = {
            "daily_average": str(daily_avg),
            "mood_distribution": distribution_percentages,
            "happy_tracks_count": happy_tracks_total,
            "sad_tracks_count": sad_tracks_total,
            "primary_peak": primary_peak,
            "total_scans": total_scans
        }

        return jsonify(analytics_payload), 200

    except Exception as e:
        return jsonify({"error": "Failed calculating analytics engines", "details": str(e)}), 500