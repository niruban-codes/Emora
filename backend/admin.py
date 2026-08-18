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
        users_ref = db.collection("users").stream()
        total_users = sum(1 for _ in users_ref)

        emotion_counter = Counter()
        total_detections = 0

        # emotion_history/{uid}/detections/{id}
        for user_doc in db.collection("emotion_history").stream():
            detections = db.collection("emotion_history") \
                            .document(user_doc.id) \
                            .collection("detections") \
                            .stream()
            for det in detections:
                data = det.to_dict() or {}
                emotion = data.get("emotion")
                if emotion:
                    emotion_counter[emotion] += 1
                    total_detections += 1

        most_common_emotion = (
            emotion_counter.most_common(1)[0][0] if emotion_counter else None
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
                "name": data.get("name"),
                "email": data.get("email"),
                "photo": data.get("photo"),
                "createdAt": data.get("createdAt")
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

        for user_doc in db.collection("emotion_history").stream():
            detections = db.collection("emotion_history") \
                            .document(user_doc.id) \
                            .collection("detections") \
                            .stream()
            for det in detections:
                data = det.to_dict() or {}
                emotion = data.get("emotion")
                if emotion:
                    emotion_counter[emotion] += 1
                    total += 1

        if total == 0:
            return jsonify({}), 200

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
        song_favorite_counts = Counter()   # videoId - number of users who favorited it
        song_titles = {}                   # videoId - title
        emotion_counter = Counter()

        # favorites/{uid}/tracks/{id} — no playCount field exists, so "most played" is derived from how many users favorited each track.
        for user_doc in db.collection("favorites").stream():
            tracks = db.collection("favorites") \
                       .document(user_doc.id) \
                       .collection("tracks") \
                       .stream()
            for track in tracks:
                data = track.to_dict() or {}
                video_id = data.get("videoId")
                if not video_id:
                    continue
                song_favorite_counts[video_id] += 1
                song_titles[video_id] = data.get("title", "Unknown")

# popular emotions from detections, reused from emotion_history
        for user_doc in db.collection("emotion_history").stream():
            detections = db.collection("emotion_history") \
                            .document(user_doc.id) \
                            .collection("detections") \
                            .stream()
            for det in detections:
                data = det.to_dict() or {}
                emotion = data.get("emotion")
                if emotion:
                    emotion_counter[emotion] += 1

        most_played = [
            {"videoId": vid, "title": song_titles.get(vid, "Unknown"), "playCount": count}
            for vid, count in song_favorite_counts.most_common(10)
        ]
        popular_emotions = [e for e, _ in emotion_counter.most_common(5)]

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
                "action": data.get("action"),
                "adminEmail": data.get("adminEmail"),
                "timestamp": data.get("timestamp")
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