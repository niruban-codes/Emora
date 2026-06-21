import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUser(String uid, String name, String email) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  Future<void> updateUserProfile(String uid, String name) async {
    try {
      await _db.collection('users').doc(uid).update({'name': name});
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<void> addEmotion(String emotion, String insight) async {
    try {
      final String? uid = _auth.currentUser?.uid;

      await _db.collection('emotion_history').add({
        'userId': uid ?? 'anonymous',
        'emotion': emotion.toLowerCase(),
        'insight': insight,
        'timestamp': FieldValue.serverTimestamp(),
        'isDummy': false,
      });
    } catch (e) {
      print("Error adding emotion history: $e");
    }
  }

  Future<void> savePlaylistHistory({
    required String emotion,
    required List<Map<String, dynamic>> songs,
  }) async {
    try {
      final String? uid = _auth.currentUser?.uid;

      await _db.collection('playlist_history').add({
        'userId': uid ?? 'anonymous',
        'emotion': emotion,
        'songs': songs,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("✅ Playlist History saved for: $emotion");
    } catch (e) {
      print("❌ Failed to save Playlist History: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getNotificationsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList(),
        );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isNew': false});
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }
}
