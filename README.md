#  Emora — Emotion-Based Music Recommendation System

> A smart mobile application that detects your emotions through facial analysis and recommends music that matches your mood.

---

##  About the Project

Most music recommendation systems focus on listening history and genre preferences — Emora is different. It is a mobile application that analyzes a user's **emotional state** through facial recognition — either from an uploaded photo or via live camera detection — and generates a personalized playlist that suits or uplifts their mood.

---

##  Features

-  **Live Camera Detection** — Use your device's camera for real-time emotion detection without needing to upload an image
-  **Photo-Based Emotion Detection** — Upload a photo from your gallery to detect emotions (Happy, Sad, Angry, Neutral,Surprise, Fear) using AI
-  **Smart Music Recommendations** — Automatically generates playlists matched to your detected mood via YouTube API
-  **Music Player** — Play, pause, skip tracks with volume control and track info display
-  **Playlist & Favorites Management** — Save, create, and manage emotion-based playlists
-  **Mood History & Analytics** — Track your emotional trends and listening patterns over time
-  **Secure Authentication** — User registration, login, and profile management via Firebase
-  **Admin Dashboard** — Manage users, songs, and music categories

---

##  Tech Stack

| Layer              | Technology                           |
|--------------------|--------------------------------------|
| Mobile Frontend    | Flutter (Dart)                       |
| Backend API        | Python / Flask                       |
| Emotion Detection  | DeepFace / OpenCV                    |
| Database & Auth    | Firebase (Firestore + Firebase Auth) |
| Music API          | YouTube Data API v3                  |
| UI Design          | Figma                                |
| Version Control    | Git & GitHub                         |
| Deployment         | Microsoft Azure                      |

---

##  System Architecture

The system is composed of six core modules:

1. **User Authentication Module** — Registration, login, session management
2. **Emotion Detection Module** — AI-based facial emotion recognition supporting both uploaded image and live camera input
3. **Music Recommendation Module** — Emotion-to-playlist mapping via streaming APIs
4. **Playlist Management Module** — Create, edit, and view emotion-based playlists
5. **Admin Management Module** — Manage users, songs, and categories
6. **Analytics & Accuracy Module** — Mood detection stats and system performance insights

---

##  Getting Started

### Prerequisites

- Flutter SDK installed
- Python 3.11
- Firebase project configured
- Android device or emulator (Android 10+, 4GB RAM minimum)


##  Project Structure

```
emora/
├── backend/                  # Flask API
│   ├── app.py
│   ├── modules/
│   │   ├── auth/
│   │   ├── emotion/
│   │   ├── recommendation/
│   │   ├── playlist/
│   │   ├── admin/
│   │   └── analytics/
│   └── requirements.txt
│
├── frontend/                 # Flutter App
│   ├── lib/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── services/
│   └── pubspec.yaml
│
└── README.md
```

---

##  Team — Group 01 (IS)

| Index No | Name | Backend Responsibility | Frontend Responsibility | Testing Responsibility |
|-----------|-------------------|---------------------------------------|------------------------------------------|-------------------------|
| 22FIS0447 | D.G.S. Piyaratne | Emotion Detection & Admin Panel | Authentication & Home Screens | Phase 4 |
| 22FIS0449 | M.N.H.F. Hafsa | Flutter Integration | Mood Analytics & Account Settings | Phase 1 |
| 22FIS0450 | U.L.P. Wathsiluni | Firestore Integration | Admin Panel Screens | Phase 5 |
| 22FIS0452 | H.H.D.A. Fernando | YouTube API Integration | Emotion Detection & Mood Result Screens | Phase 2 & 6 |
| 22FIS0455 | N. Niruban | Firebase Authentication & Admin Panel | Splash Screens & Music Player Screens | Phase 3 |

**Internal Supervisor:** Mr. H. M. K. T. Gunawardane — Sabaragamuwa University of Sri Lanka  
**Mentor:** W. M. P. K. Wijethunga — Arimac Lanka PVT LTD

---

##  Roadmap

### Phase 1 — User Authentication ✅ Done
- [x] User registration and login via Firebase Auth
- [x] Session management and profile handling

### Phase 2 — Firestore Database ✅ Done
- [x] Firestore collections and data structure set up
- [x] User data, mood history, and playlist storage

### Phase 3 — Emotion Detection ✅ Done
- [x] Flask backend set up and deployed
- [x] Photo upload-based emotion detection via DeepFace
- [x] Live camera-based real-time emotion detection
- [x] `/detect-emotion` endpoint with error handling

### Phase 4 — Music Recommendation ✅ Done
- [x] YouTube Data API v3 integrated
- [x] Emotion-to-music query mapping
- [x] `/recommend-music` endpoint for all emotion categories
- [x] Explore / vibe-genre endpoint

### Phase 5 — Admin Panel ✅ Done
- [x] Admin dashboard with user and content management
- [x] Six admin endpoints built and tested

### Phase 6 — Flutter Integration ✅ Done
- [x] Full Flutter frontend connected to Flask backend
- [x] End-to-end flow from emotion detection to music playback
- [x] Favourites, history, and playlist screens integrated
- [x] Final testing and deployment

---

## References

- [DeepFace Library](https://github.com/serengil/deepface)
- [OpenCV Documentation](https://opencv.org/)
- [YouTube Data API v3](https://developers.google.com/youtube/v3/getting-started)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Google ML Kit](https://pub.dev/packages/google_ml_kit)

---

##  License

This project was developed for academic purposes as part of the IS4110 Capstone Project at Sabaragamuwa University of Sri Lanka.

