from flask import Blueprint, request, jsonify
from firebase_admin import firestore
from firebase_config import db
from datetime import datetime, timezone


favorites_bp = Blueprint("favorites", __name__)

 
@favorites_bp.route("/<uid>", methods=["GET"])
def get_favorites(uid):
    if not uid or not uid.strip():
        return jsonify({"error": "uid is required"}), 400

    try:
        tracks_ref = (
            db.collection("favorites")
            .document(uid)
            .collection("tracks")
            .order_by("addedAt", direction=firestore.Query.DESCENDING)
        )
        docs = tracks_ref.stream()

        favorites = []
        for doc in docs:
            data = doc.to_dict()
            added_at = data.get("addedAt")

            if hasattr(added_at, "date"):
                added_at = added_at.date().isoformat()
            elif isinstance(added_at, datetime):
                added_at = added_at.date().isoformat()
            else:
                added_at = str(added_at) if added_at else None

            favorites.append(
                {
                    "id": doc.id,
                    "videoId": data.get("videoId"),
                    "title": data.get("title"),
                    "artist": data.get("artist"),
                    "thumbnail": data.get("thumbnail"),
                    "addedAt": added_at,
                }
            )

        return jsonify(favorites), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@favorites_bp.route("/<uid>/add", methods=["POST"])
def add_favorite(uid):
    if not uid or not uid.strip():
        return jsonify({"error": "uid is required"}), 400

    data = request.get_json()
    if not data:
        return jsonify({"error": "Request body is required"}), 400

    required_fields = ["videoId", "title", "artist", "thumbnail"]
    missing = [f for f in required_fields if not data.get(f)]
    if missing:
        return jsonify({"error": f"Missing required fields: {', '.join(missing)}"}), 400

    try:
        tracks_ref = (
            db.collection("favorites").document(uid).collection("tracks")
        )

        existing = tracks_ref.where("videoId", "==", data["videoId"]).limit(1).stream()
        if any(True for _ in existing):
            return jsonify({"error": "Track already in favorites"}), 400

        tracks_ref.add(
            {
                "videoId": data["videoId"],
                "title": data["title"],
                "artist": data["artist"],
                "thumbnail": data["thumbnail"],
                "addedAt": datetime.now(timezone.utc),
            }
        )

        return jsonify({"status": "saved"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@favorites_bp.route("/<uid>/remove", methods=["DELETE"])
def remove_favorite(uid):
    if not uid or not uid.strip():
        return jsonify({"error": "uid is required"}), 400

    data = request.get_json()
    if not data or not data.get("videoId"):
        return jsonify({"error": "videoId is required"}), 400

    try:
        tracks_ref = (
            db.collection("favorites").document(uid).collection("tracks")
        )

        matches = (
            tracks_ref.where("videoId", "==", data["videoId"]).limit(1).stream()
        )
        docs = list(matches)

        if not docs:
            return jsonify({"error": "Track not found in favorites"}), 404

        docs[0].reference.delete()
        return jsonify({"status": "removed"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500