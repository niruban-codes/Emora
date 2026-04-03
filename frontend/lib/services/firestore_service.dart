import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 TC09: Create user document after register
  Future<void> createUser(String uid, String name, String email) async {
    try {
      await _db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  // 🔹 TC10: Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // 🔹 TC11: Update user profile
  Future<void> updateUserProfile(String uid, String name) async {
    try {
      await _db.collection('users').doc(uid).update({
        'name': name,
      });
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  // 🔹 Add emotion (for emotion_history)
  Future<void> addEmotion(String uid, String emotion) async {
    try {
      await _db.collection('emotion_history').add({
        'userId': uid,
        'emotion': emotion,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding emotion: $e");
    }
  }

  // 🔹 Add playlist
  Future<void> addPlaylist(String uid, String playlistName) async {
    try {
      await _db.collection('playlists').add({
        'userId': uid,
        'name': playlistName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding playlist: $e");
    }
  }
}