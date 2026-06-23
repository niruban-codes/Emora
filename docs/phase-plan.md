# Emora — Team Task & Testing Assignment
### IS4110 Capstone · Group 01 · Sabaragamuwa University of Sri Lanka

## Assignment Overview
Each team member builds one phase, while another member writes and executes test cases.

## Team Responsibilities
| Phase | Module | Builder | Tester | Tester’s Responsibility |
| :--- | :--- | :--- | :--- | :--- |
| Phase 1 | Firebase Auth | Niruban | Hafsa | Write & execute test cases |
| Phase 2 | Firestore DB | Wathsiluni | Dinithi | Write & execute test cases |
| Phase 3 | Flask + DeepFace | Geethma | Niruban | Write & execute test cases |
| Phase 4 | YouTube API | Dinithi | Geethma | Write & execute test cases |
| Phase 5 | Flutter Integration | Hafsa | Wathsiluni | Write & execute test cases |
| Phase 6 | Admin Panel | — | — | Full system validation |

---

## Phase 1 — Firebase Authentication
**Builder:** Niruban  
**Tester:** Hafsa

### Build Tasks
* Create Firebase project
* Enable Email/Password and Google sign-in
* Add Flutter app and configure Firebase
* Add dependencies: `firebase_core`, `firebase_auth`
* Initialize Firebase in `main.dart`
* Implement user registration and login
* Handle errors (wrong password, user not found)

### Test Cases
* **TC01:** Register with valid email → user created
* **TC02:** Register with existing email → error shown
* **TC03:** Login with correct credentials → navigate to home
* **TC04:** Login with wrong password → error
* **TC05:** Login with unregistered email → error
* **TC06:** Google sign-in → user created
* **TC07:** Logout → return to login
* **TC08:** Test on emulator and real device

---

## Phase 2 — Firestore Database
**Builder:** Wathsiluni  
**Tester:** Dinithi

### Build Tasks
* Enable Cloud Firestore
* Design collections: `users`, `emotion_history`, `playlists`
* Set security rules (user-specific access)
* Create user document on registration
* Fetch user profile on login
* Display profile data in UI
* Implement helper functions for database operations

### Test Cases
* **TC09:** User document created on register
* **TC10:** Profile loads correctly
* **TC11:** Profile updates correctly
* **TC12:** Unauthorized access is denied
* **TC13:** Required collections exist
* **TC14:** Offline read works (cached data)

---

## Phase 3 — Flask + DeepFace
**Builder:** Geethma  
**Tester:** Niruban

### Build Tasks
* Create `backend/` folder with `app.py`
* Set up Python virtual environment
* Install dependencies: `pip install flask deepface opencv-python`
* Implement endpoints: `GET /ping`, `POST /detect-emotion`
* Perform emotion detection using DeepFace
* Return JSON responses
* Handle errors (no face, invalid file)
* Generate `requirements.txt`

### Test Cases
* **TC15:** `/ping` returns status OK
* **TC16–TC18:** Correct emotion detection (happy, sad, angry)
* **TC19:** No face → handled error
* **TC20:** Invalid file → 400 error
* **TC21:** No file → 400 error
* **TC22:** Test all supported emotions

---

## Phase 4 — YouTube API
**Builder:** Dinithi  
**Tester:** Geethma

### Build Tasks
* Obtain YouTube Data API v3 key
* Store API key in `.env`
* Implement `POST /recommend-music`
* Map emotions to search queries
* Fetch top 10 videos
* Handle API errors and quota limits

### Test Cases
* **TC23:** Returns list of 10 videos
* **TC24:** Each result contains title, thumbnail, and videoId
* **TC25:** Works for all emotion labels
* **TC26:** Invalid emotion → handled error
* **TC27:** Missing field → 400 error
* **TC28:** Results are relevant music content
* **TC29:** API quota handled properly

---

## Phase 5 — Flutter Integration
**Builder:** Hafsa  
**Tester:** Wathsiluni

### Build Tasks
* Add `dio` for HTTP requests
* Create API service class
* Implement camera/upload functionality
* Integrate emotion detection and music recommendation APIs
* Display video list with thumbnail and title
* Store emotion history in Firestore
* Add loading indicators
* Handle network errors gracefully

### Test Cases
* **TC30:** Emotion detected from image
* **TC31:** Music recommendations displayed
* **TC32:** Video playback works
* **TC33:** Emotion history stored correctly
* **TC34:** No internet → handled gracefully
* **TC35:** Test on Android device
* **TC36:** Test on iOS device
* **TC37:** Full flow runs multiple times without errors

---

## Phase 6 — Admin Panel
### Build Tasks
* Create admin dashboard in Flutter
* Implement Flask endpoints: `/admin/users`, `/admin/stats`, `/admin/logs`
* Create `admin_logs` collection
* Restrict admin access
* Display system data in dashboard

### Test Cases
* **TC38:** Retrieve list of users
* **TC39:** Retrieve system statistics
* **TC40:** Unauthorized access denied (401)
* **TC41:** Admin logs updated correctly
* **TC42:** Dashboard displays accurate data
* **TC43:** Non-admin users restricted
* **TC44:** Test on real device
