import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 TC09: Create user document after register
  Future<void> createUser(String uid, String name, String email) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid, // 👈 Added this
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

  // 🔹 Updated: Add emotion to a TOP-LEVEL COLLECTION
  Future<void> addEmotion(String emotion, String insight) async {
    try {
      final String? uid = _auth.currentUser?.uid;
      
      // We still want to know WHICH user this belongs to, 
      // so we store the uid as a field inside the document.
      await _db.collection('emotion_history').add({
        'userId': uid ?? 'anonymous', // Link it to the user
        'emotion': emotion,
        'insight': insight,
        'timestamp': FieldValue.serverTimestamp(),
        'isDummy': true,
      });
    } catch (e) {
      print("Error adding emotion history: $e");
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