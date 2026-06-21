from datetime import timezone
from flask import Blueprint, jsonify, request
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
from google.api_core.exceptions import NotFound, GoogleAPICallError
from firebase_config import db

admin_bp = Blueprint("admin", __name__, url_prefix="/admin")

# Hardcoded for now (per project scope). Add/remove emails here as needed.
# A set gives O(1) lookups and avoids accidental duplicate entries.

ADMIN_WHITELIST = {
    'niru2324@gmail.com',
    'sparkswills40@gmail.com',
    'admin@emora.com',
    'geethmapiyaratne285@gmail.com',
    'nirubannallirajah@gmail.com',
    'hafsanafli2003@gmail.com',
    'dinithia962@gmail.com',
}


def _format_timestamp(ts):
    """
    Convert a Firestore timestamp into 'YYYY-MM-DD HH:MM:SS' (UTC).
    Matches the formatting used in history.py so all admin/user-facing
    dates are consistent across the app.
    """
    if ts is None:
        return None
    try:
        dt = ts.ToDatetime() if hasattr(ts, "ToDatetime") else ts
        dt_utc = dt.replace(tzinfo=timezone.utc) if dt.tzinfo is None else dt
        return dt_utc.strftime("%Y-%m-%d %H:%M:%S")
    except Exception:
        return str(ts)



# ENDPOINT 1: Check Admin Status
# POST /admin/check-status
# Body: { "email": "user@example.com" }

@admin_bp.route("/check-status", methods=["POST"])
def check_admin_status():
    body = request.get_json(silent=True)

    if not body or "email" not in body:
        return jsonify({"error": "Missing email parameter"}), 400

    raw_email = body["email"]
    if not isinstance(raw_email, str) or not raw_email.strip():
        return jsonify({"error": "'email' must be a non-empty string"}), 400

    email = raw_email.strip().lower()
    is_admin = email in ADMIN_WHITELIST

    return jsonify({"email": email, "isAdmin": is_admin}), 200


# ENDPOINT 2: Get All Users
# GET /admin/users

@admin_bp.route("/users", methods=["GET"])
def get_all_users():
    """
    Fetches all registered users from Firestore for the admin dashboard list.
    """
    try:
        docs = db.collection("users").stream()

        user_list = []
        for doc in docs:
            data = doc.to_dict()
            user_list.append({
                "uid": doc.id,
                "name": data.get("name", "Unknown"),
                "email": data.get("email", "No Email"),
                "createdAt": _format_timestamp(data.get("createdAt")),
                "status": data.get("status", "active"),  # used later by admin controls (suspend/unsuspend)
            })

        return jsonify({"users": user_list}), 200

    except GoogleAPICallError as e:
        return jsonify({"error": "Firestore connection failed", "details": str(e)}), 500

    except Exception as e:
        return jsonify({"error": "Unexpected server error", "details": str(e)}), 500
