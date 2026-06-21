"""
Initializes Firebase Admin SDK and exposes a Firestore client.
 
All other modules (history.py, youtube.py, favorites.py, library.py)
should import `db` from this file — never re-initialize Firebase elsewhere.
 
Setup:
  - Place serviceAccountKey.json inside backend/
  - Ensure serviceAccountKey.json is listed in .gitignore
"""
import os
import firebase_admin
from firebase_admin import credentials, firestore
from dotenv import load_dotenv

load_dotenv()
_KEY_PATH = os.path.join(os.path.dirname(__file__), "serviceAccountKey.json")

def _initialize_firebase() -> firestore.Client:
    """
    Initialize Firebase only once, even if this module is imported
    multiple times. Returns a Firestore client.
    """
    if not firebase_admin._apps:  # Guard: don't initialize twice
        if not os.path.exists(_KEY_PATH):
            raise FileNotFoundError(
                f"serviceAccountKey.json not found at: {_KEY_PATH}\n"
                "Download it from Firebase Console → Project Settings → Service Accounts."
            )
        cred = credentials.Certificate(_KEY_PATH)
        firebase_admin.initialize_app(cred)
 
    return firestore.client()

db: firestore.Client = _initialize_firebase()