"""
Endpoints:
  GET  /admin/stats
  GET  /admin/users
  GET  /admin/emotion-stats
  GET  /admin/music-stats
  GET  /admin/logs
  POST /admin/logs
"""

from flask import Blueprint, request, jsonify
from datetime import datetime
from collections import Counter
from firebase_config import db  # existing initialized Firestore client

admin_bp = Blueprint("admin", __name__, url_prefix="/admin")

AUTHORIZED_ADMIN_EMAILS = {
    'niru2324@gmail.com',
    'sparkswills40@gmail.com',
    'admin@emora.com',
    'geethmapiyaratne285@gmail.com',
    'nirubannallirajah@gmail.com',
    'hafsanafli2003@gmail.com',
    'dinithia962@gmail.com',
}


def require_admin(req):
    """
    Checks X-Admin-Email header first, then falls back to
    'adminEmail' in JSON body. Returns (email, None) on success,
    or (None, (response, status_code)) on failure.
    """
    email = req.headers.get("X-Admin-Email")

    if not email and req.is_json:
        body = req.get_json(silent=True) or {}
        email = body.get("adminEmail")

    if not email:
        return None, (jsonify({"error": "Missing admin email"}), 401)

    if email not in AUTHORIZED_ADMIN_EMAILS:
        return None, (jsonify({"error": "Unauthorized admin"}), 401)

    return email, None

# GET /admin/stats

@admin_bp.route("/stats", methods=["GET"])
def get_stats():
    _, err = require_admin(request)
    if err:
        return err

    try:
        users_stream = db.collection("users").stream()
        total_users = sum(1 for _ in users_stream)

        emotion_counter = Counter()
        total_detections = 0

        # emotion_history/{uid}/detections/{id}
        for doc in db.collection("emotion_history").stream():
            data = doc.to_dict() or {}
            emotion = data.get("emotion")
            if emotion and isinstance(emotion, str):
                clean_emotion = emotion.strip().lower()
                emotion_counter[clean_emotion] += 1
                total_detections += 1

        most_common_emotion = (
            emotion_counter.most_common(1)[0][0].capitalize()
            if emotion_counter
            else "None"
        )

        return jsonify({
            "total_users": total_users,
            "total_detections": total_detections,
            "most_common_emotion": most_common_emotion
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# GET /admin/users
@admin_bp.route("/users", methods=["GET"])
def get_users():
    _, err = require_admin(request)
    if err:
        return err

    try:
        users = []
        for doc in db.collection("users").stream():
            data = doc.to_dict() or {}
            users.append({
                "uid": doc.id,
                "name": data.get("name") or data.get("displayName") or "Anonymous",
                "email": data.get("email") or "No Email",
                "photo": data.get("photo")or data.get("photoUrl") or "",
                "createdAt": str(data.get("createdAt") or "")
            })
        return jsonify(users), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# GET /admin/emotion-stats
@admin_bp.route("/emotion-stats", methods=["GET"])
def get_emotion_stats():
    _, err = require_admin(request)
    if err:
        return err

    try:
        emotion_counter = Counter()
        total = 0

        for doc in db.collection("emotion_history").stream():
            data = doc.to_dict() or {}
            emotion = data.get("emotion")
            if emotion and isinstance(emotion, str):
                clean_emotion = emotion.strip().lower()
                emotion_counter[clean_emotion] += 1
                total += 1

        if total == 0:
            return jsonify({
                "happy": 0.0,
                "sad": 0.0,
                "neutral": 0.0,
                "surprise": 0.0,
                "fear": 0.0,
                "angry": 0.0
            }), 200

        percentages = {
            emotion: round((count / total) * 100, 1)
            for emotion, count in emotion_counter.items()
        }
        return jsonify(percentages), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# GET /admin/music-stats
@admin_bp.route("/music-stats", methods=["GET"])
def get_music_stats():
    _, err = require_admin(request)
    if err:
        return err

    try:
        song_counts = Counter()
        song_titles = {}
        emotion_counter = Counter()

        for doc in db.collection("emotion_history").stream():
            data = doc.to_dict() or {}
            emotion = data.get("emotion")
            if emotion and isinstance(emotion, str):
                emotion_counter[emotion.strip().lower()] += 1

            tracks = data.get("tracks", [])
            if isinstance(tracks, list):
                for track in tracks:
                    if isinstance(track, dict):
                        title = track.get("title")
                        vid = track.get("videoId") or title
                        if title and vid:
                            song_counts[vid] += 1
                            song_titles[vid] = title
        for doc in db.collection("playlist_history").stream():
            data = doc.to_dict() or {}
            songs = data.get("songs", [])
            if isinstance(songs, list):
                for song in songs:
                    if isinstance(song, dict):
                        title = song.get("mainSong") or song.get("title")
                        if title:
                            song_counts[title] += 1
                            song_titles[title] = title

        # 3. Aggregate from favorites if populated
        for user_doc in db.collection("favorites").stream():
            tracks_stream = (
                db.collection("favorites")
                .document(user_doc.id)
                .collection("tracks")
                .stream()
            )
            for track_doc in tracks_stream:
                data = track_doc.to_dict() or {}
                vid = data.get("videoId") or data.get("title")
                title = data.get("title", "Unknown")
                if vid:
                    song_counts[vid] += 1
                    song_titles[vid] = title

        most_played = [
            {
                "videoId": vid,
                "title": song_titles.get(vid, vid),
                "playCount": count
            }
            for vid, count in song_counts.most_common(10)
        ]

        popular_emotions = [e.capitalize() for e, _ in emotion_counter.most_common(5)]

        return jsonify({
            "most_played": most_played,
            "popular_emotions": popular_emotions
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# GET /admin/logs
@admin_bp.route("/logs", methods=["GET"])
def get_logs():
    _, err = require_admin(request)
    if err:
        return err

    try:
        logs = []
        query = db.collection("admin_logs").order_by(
            "timestamp", direction="DESCENDING"
        )
        for doc in query.stream():
            data = doc.to_dict() or {}
            logs.append({
                "id": doc.id,
                "action": data.get("action", "Admin Action"),
                "adminEmail": data.get("adminEmail", "admin@emora.com"),
                "timestamp": str(data.get("timestamp") or "")
            })
        return jsonify(logs), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# POST /admin/logs
@admin_bp.route("/logs", methods=["POST"])
def create_log():
    admin_email, err = require_admin(request)
    if err:
        return err

    try:
        body = request.get_json(silent=True) or {}
        action = body.get("action")

        if not action:
            return jsonify({"error": "Missing required field: action"}), 400

        log_entry = {
            "action": action,
            "adminEmail": body.get("adminEmail", admin_email),
            "timestamp": datetime.utcnow().isoformat()
        }
        db.collection("admin_logs").add(log_entry)

        return jsonify({"status": "logged"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500