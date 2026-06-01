from flask import Blueprint, request, jsonify
from datetime import datetime
from firebase_config import db # Automatically imports your team's shared Firestore connection

library_bp = Blueprint('library', __name__)

#ENDPOINT 1: GET ALL PLAYLISTS FOR A USER
@library_bp.route('/library/<uid>', methods=['GET'])
def get_library(uid):
    try:
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
        return jsonify({"error": str(e)}), 500


#ENDPOINT 2: SAVE A NEW PLAYLIST
@library_bp.route('/library/<uid>/add', methods=['POST'])
def add_to_library(uid):
    try:
        data = request.get_json()
        if not data or 'name' not in data or 'emotion' not in data or 'tracks' not in data:
            return jsonify({"error": "Missing required fields (name, emotion, or tracks)"}), 400
            
        new_playlist = {
            "name": data['name'],
            "emotion": data['emotion'],
            "tracks": data['tracks'], # Expects an array of song dictionaries
            "createdAt": datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        }
        
        playlists_ref = db.collection('library').document(uid).collection('playlists')
        _, doc_ref = playlists_ref.add(new_playlist)
        
        return jsonify({"status": "saved", "playlistId": doc_ref.id}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


#ENDPOINT 3: DELETE A PLAYLIST
@library_bp.route('/library/<uid>/remove', methods=['DELETE'])
def remove_from_library(uid):
    try:
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
        return jsonify({"error": str(e)}), 500