import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart'; // 👈 added

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Google Sign In (updated for google_sign_in v7.x) ─────────────────────
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Create GoogleSignIn instance with correct v7 syntax
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      // 2. Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // 3. User cancelled the sign in
      if (googleUser == null) return null;

      // 4. Get the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 5. Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 6. Sign in to Firebase with the Google credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // 7. New Database Connection Logic
      if (user != null) {
        final firestore = FirestoreService();
        
        // Check if user already exists in Firestore
        final existingProfile = await firestore.getUserProfile(user.uid);
        
        if (existingProfile == null) {
          // If profile doesn't exist, create it using Google's info
          await firestore.createUser(
            user.uid,
            user.displayName ?? "Google User", // Fallback name
            user.email ?? "",
          );
        }
      }
      
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
