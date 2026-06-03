from flask import Blueprint, request, jsonify
from datetime import datetime, timezone
from firebase_config import db # Automatically imports team's shared Firestore connection
from firebase_admin import auth

library_bp = Blueprint('library', __name__)

def verify_user_access(uid):
    """
    Helper to extract the Bearer token from Flutter and check if it matches the requested uid.
    Returns True if authentic, False otherwise.
    """
    auth_header = request.headers.get('Authorization')
    if not auth_header or not auth_header.startswith('Bearer '):
        return False
    
    try:
        # Extract the string token after "Bearer "
        token = auth_header.split(' ')[1]
        # Let Firebase confirm the token is valid and unexpired
        decoded_token = auth.verify_id_token(token)
        # Check if the token's UID matches the URL target UID
        return decoded_token['uid'] == uid
    except Exception:
        return False
    

#ENDPOINT 1: GET ALL PLAYLISTS FOR A USER
@library_bp.route('/library/<uid>', methods=['GET'])
def get_library(uid):
    try:
        # IDOR Security Wall Check
        if not verify_user_access(uid):
            return jsonify({"error": "Unauthorized access to library data."}), 403
       
        # Targets: library/{uid}/playlists
        playlists_ref = db.collection('library').document(uid).collection('playlists')
        docs = playlists_ref.stream()
        
        playlists_list = []
        for doc in docs:
            playlist_data = doc.to_dict()
            playlist_data['id'] = doc.id # Pass the unique Firestore document ID to Flutter
            playlists_list.append(playlist_data)
            
        return jsonify(playlists_list), 200
    except Exception as e:
       print(f"[ERROR] Failed to fetch library for user {uid}: {str(e)}") #coderabbit correction
       return jsonify({"error": "An internal server error occurred while retrieving library data."}), 500 #coderabbit correction

#ENDPOINT 2: SAVE A NEW PLAYLIST
@library_bp.route('/library/<uid>/add', methods=['POST'])
def add_to_library(uid):
    try:
       # IDOR Security Wall Check
        if not verify_user_access(uid):
            return jsonify({"error": "Unauthorized access to modify library data."}), 403

        data = request.get_json()
        if not data or 'name' not in data or 'emotion' not in data or 'tracks' not in data:
            return jsonify({"error": "Missing required fields (name, emotion, or tracks)"}), 400
            
        # FIX: Define current_utc_time before using it!
        current_utc_time = datetime.now(timezone.utc)
            
        new_playlist = {
            "name": data['name'],
            "emotion": data['emotion'],
            "tracks": data['tracks'], 
            "createdAt": current_utc_time.isoformat()
        }

        playlists_ref = db.collection('library').document(uid).collection('playlists')
        _, doc_ref = playlists_ref.add(new_playlist)
        
        return jsonify({"status": "saved", "playlistId": doc_ref.id}), 201
    except Exception as e:
        print(f"[ERROR] Failed to add playlist for user {uid}: {str(e)}") #coderabbit correction
        return jsonify({"error": "An internal server error occurred while saving the playlist."}), 500 #coderabbit correction



#ENDPOINT 3: DELETE A PLAYLIST
@library_bp.route('/library/<uid>/remove', methods=['DELETE'])
def remove_from_library(uid):
    try:
        # IDOR Security Wall Check
        if not verify_user_access(uid):
            return jsonify({"error": "Unauthorized access to modify library data."}), 403
        
        data = request.get_json()
        if not data or 'id' not in data:
            return jsonify({"error": "Missing playlist 'id' to remove"}), 400
            
        playlist_id = data['id']
        doc_ref = db.collection('library').document(uid).collection('playlists').document(playlist_id)
        
        if not doc_ref.get().exists:
            return jsonify({"error": "Playlist not found in database"}), 404
            
        doc_ref.delete()
        return jsonify({"status": "removed"}), 200
    except Exception as e:
        print(f"[ERROR] Failed to delete playlist {data.get('id')} for user {uid}: {str(e)}")#coderabbit correction
        return jsonify({"error": "An internal server error occurred while removing the playlist."}), 500#coderabbit correction
