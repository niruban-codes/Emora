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
from datetime import datetime, timedelta
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

        admin_logs_count = sum(1 for _ in db.collection("admin_logs").stream())

        return jsonify({
            "total_users": total_users,
            "total_detections": total_detections,
            "top_emotion": most_common_emotion.upper(),
            "most_common_emotion": most_common_emotion,
            "admin_actions": admin_logs_count
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

        timeframe = request.args.get("timeframe", "weekly").lower()
        now = datetime.utcnow()

        if timeframe == "daily":
            cutoff_date = now - timedelta(days=1)
        elif timeframe == "monthly":
            cutoff_date = now - timedelta(days=30)
        else:  # default weekly
            cutoff_date = now - timedelta(days=7)

        emotion_counter = Counter()
        total = 0

        for doc in db.collection("emotion_history").stream():
            data = doc.to_dict() or {}

            raw_ts = data.get("timestamp") or data.get("createdAt")
            if raw_ts:
                try:
                    if isinstance(raw_ts, str):
                        doc_time = datetime.fromisoformat(
                            raw_ts.replace("Z", "+00:00")
                        ).replace(tzinfo=None)
                    elif hasattr(raw_ts, "to_datetime"):
                        doc_time = raw_ts.to_datetime().replace(tzinfo=None)
                    elif isinstance(raw_ts, datetime):
                        doc_time = raw_ts.replace(tzinfo=None)
                    else:
                        doc_time = None

                    if doc_time and doc_time < cutoff_date:
                        continue
                except Exception:
                    pass

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
        distinct_tracks = set()

        for doc in db.collection("emotion_history").stream():
            data = doc.to_dict() or {}
            emotion = data.get("emotion")
            if emotion and isinstance(emotion, str):
                emotion_counter[emotion.strip().lower()] += 1

            tracks = data.get("tracks") or data.get("recommendedTracks") or []
            if isinstance(tracks, list):
                for track in tracks:
                    title = ""
                    vid = ""
                    if isinstance(track, dict):
                        title = track.get("title") or track.get("name") or ""
                        vid = track.get("videoId") or title
                    elif isinstance(track, str):
                        title = track
                        vid = track

                    if title and vid:
                        song_counts[vid] += 1
                        song_titles[vid] = title


        for doc in db.collection("playlist_history").stream():
            data = doc.to_dict() or {}
            songs = data.get("songs") or data.get("tracks") or []
            if isinstance(songs, list):
                for song in songs:
                    title = ""
                    if isinstance(song, dict):
                        title = song.get("mainSong") or song.get("title") or song.get("name") or ""
                    elif isinstance(song, str):
                        title = song

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
                title = data.get("title", "Unknown Track")
                if vid:
                    distinct_tracks.add(title)
                    song_counts[vid] += 2
                    song_titles[vid] = title

        top_emotion = "N/A"
        if emotion_counter:
            top_emotion = emotion_counter.most_common(1)[0][0].upper()

        top_song = "N/A"
        top_fav_count = 0
        if song_counts:
            top_vid, top_fav_count = song_counts.most_common(1)[0]
            top_song = song_titles.get(top_vid, top_vid)

        top_favorited_tracks = [
            {"title": song_titles.get(vid, vid), "count": count}
            for vid, count in song_counts.most_common(5)
        ]

        top_detection_moods = [
            {"mood": mood.capitalize(), "count": count}
            for mood, count in emotion_counter.most_common(5)
        ]

        most_played = [
            {
                "videoId": vid,
                "title": song_titles.get(vid, vid),
                "playCount": count
            }
            for vid, count in song_counts.most_common(10)
        ]

        return jsonify({
            "top_emotion": top_emotion,
            "tracks_in_charts": len(distinct_tracks),
            "top_favorite_count": top_fav_count,
            "top_song": top_song,
            "top_favorited_tracks": top_favorited_tracks,
            "top_detection_moods": top_detection_moods,
            "most_played": most_played,
            "popular_emotions": [m["mood"] for m in top_detection_moods]
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