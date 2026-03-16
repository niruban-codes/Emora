#  Emora — Emotion-Based Music Recommendation System

> A smart mobile application that detects your emotions through facial analysis and recommends music that matches your mood.

---

##  About the Project

Most music recommendation systems focus on listening history and genre preferences — Emora is different. It is a mobile application that analyzes a user's emotional state through facial recognition — either by uploading a photo from the gallery or using live camera detection — and generates a personalized playlist that suits or uplifts their mood.

---

##  Features

-  **Image Upload Emotion Detection** — Upload a photo from your gallery or capture an image using the camera to detect emotions (Happy, Sad, Angry, Neutral...) using AI
-  **Live Emotion Detection** — Detect emotions in real-time using the device camera without uploading an image
-  **Live Camera Detection** — Use your device's camera for real-time emotion detection without needing to upload an image
-  **Smart Music Recommendations** — Automatically generates playlists matched to your detected mood via Spotify / YouTube API
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
| Music API          | Spotify Web API / YouTube API        |
| UI Design          | Figma                                |
| Version Control    | Git & GitHub                         |

---

##  System Architecture

The system is composed of six core modules:

1. **User Authentication Module** — Registration, login, session management
2. **Emotion Detection Module** — AI-based facial emotion recognition supporting both uploaded images and live camera-based real-time detection
3. **Music Recommendation Module** — Emotion-to-playlist mapping via streaming APIs
4. **Playlist Management Module** — Create, edit, and view emotion-based playlists
5. **Admin Management Module** — Manage users, songs, and categories
6. **Analytics & Accuracy Module** — Mood detection stats and system performance insights

---

##  Getting Started

### Prerequisites

- Flutter SDK installed
- Python 3.8+
- Firebase project configured
- Spotify Developer account (for API credentials)
- Android device or emulator (Android 10+, 4GB RAM minimum)

## Project Structure

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

| Index No  | Name               | 
|-----------|--------------------|
| 22FIS0455 | N. Niruban         |
| 22FIS0447 | D.G.S. Piyaratne   |
| 22FIS0452 | H.H.D.A. Fernando  |
| 22FIS0450 | U.L.P. Wathsiluni  |
| 22FIS0449 | M.N.H.F. Hafsa     |

**Internal Supervisor:** Mr. H. M. K. T. Gunawardane — Sabaragamuwa University of Sri Lanka  
**Mentor:** W. M. P. K. Wijethunga — Arimac Lanka PVT LTD

---

##  Roadmap

###  Phase I (Current)
- [x] Image upload and live camera-based emotion detection
- [x] Live camera-based real-time emotion detection
- [x] Spotify / YouTube API integration
- [x] Android app (Flutter)
- [x] User authentication and profile management
- [x] Rule-based emotion-to-music mapping
- [x] Mood history and basic analytics

### Phase II (Planned)
- [ ] iOS and web versions
- [ ] Advanced personalization using long-term behavior analysis
- [ ] Custom fine-tuned deep learning models
- [ ] Offline music playback

---

## References

- [DeepFace Library](https://github.com/serengil/deepface)
- [OpenCV Documentation](https://opencv.org/)
- [Spotify Web API](https://developer.spotify.com/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Google ML Kit](https://pub.dev/packages/google_ml_kit)

---

## License

This project was developed for academic purposes as part of the IS4110 Capstone Project at Sabaragamuwa University of Sri Lanka.


