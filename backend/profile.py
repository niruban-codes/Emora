from flask import Blueprint, request, jsonify
from firebase_config import db

profile_bp = Blueprint("profile", __name__, url_prefix="/profile")

@profile_bp.route('/<uid>', methods=['GET'])
def get_profile(uid):
    try:
        user_ref = db.collection('users').document(uid)
        user_doc = user_ref.get()

        if not user_doc.exists:
            return jsonify({"error": "User not found"}), 404

        user_data = user_doc.to_dict()
        
        profile_data = {
            "uid": uid,
            "name": user_data.get("name"),
            "email": user_data.get("email"),
            "photo": user_data.get("photo"),
            "createdAt": user_data.get("createdAt")
        }
        return jsonify(profile_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@profile_bp.route('/<uid>', methods=['PUT'])
def update_profile(uid):
    try:
        data = request.get_json()
        
        if not data or ("name" not in data and "photo" not in data):
            return jsonify({"error": "Bad request. Provide 'name' or 'photo' to update."}), 400

        user_ref = db.collection('users').document(uid)
        user_doc = user_ref.get()

        if not user_doc.exists:
            return jsonify({"error": "User not found"}), 404

        update_data = {}
        if "name" in data:
            update_data["name"] = data["name"]
        if "photo" in data:
            update_data["photo"] = data["photo"]

        user_ref.update(update_data)

        return jsonify({"message": "Profile updated successfully", "updated": update_data}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500