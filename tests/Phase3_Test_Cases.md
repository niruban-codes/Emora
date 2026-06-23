# Phase 3 Test Cases — Emotion Detection (Flask + DeepFace)

| | |
|---|---|
| **Project Name** | Emora - AI Music Recommendation Mobile Application |
| **Phase** | Phase 3 - Emotion Detection (Flask + DeepFace) |
| **Tester** | Niruban |
| **Date** | 2026-04-12 |
| **Pass** | 8 |
| **Fail** | 0 |

---

| Test Case ID | Test Case Description | Pre-conditions | Test Steps | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| TC15 | Health Check - GET /ping endpoint | Flask server running on http://127.0.0.1:5000 | 1. Open Postman 2. Send GET request to /ping | `{"status": "ok"}` with HTTP 200 | `{"status": "ok"}` - HTTP 200 | ✅ PASS |
| TC16 | Emotion Detection - Sad face image | Flask server running, valid face image available | 1. Send POST to /detect-emotion 2. Attach sad face image in form-data (key: image) | `{"emotion": "sad", "confidence": ...}` with HTTP 200 | `{"emotion": "sad", "confidence": 99.28}` - HTTP 200 | ✅ PASS |
| TC17 | Emotion Detection - Happy face image | Flask server running, valid face image available | 1. Send POST to /detect-emotion 2. Attach happy face image in form-data (key: image) | `{"emotion": "happy", "confidence": ...}` with HTTP 200 | `{"emotion": "happy", "confidence": 76.14}` - HTTP 200 | ✅ PASS |
| TC18 | Emotion Detection - Angry face image | Flask server running, valid face image available | 1. Send POST to /detect-emotion 2. Attach angry face image in form-data (key: image) | `{"emotion": "angry", "confidence": ...}` with HTTP 200 | `{"emotion": "angry", "confidence": 99.83}` - HTTP 200 | ✅ PASS |
| TC19 | Error Handling - No face in image | Flask server running, non-face image available | 1. Send POST to /detect-emotion 2. Attach landscape/food image in form-data (key: image) | `{"error": "No face detected in the image"}` with HTTP 400 | `{"error": "No face detected in the image"}` - HTTP 400 | ✅ PASS |
| TC20 | Error Handling - Invalid file type (.txt) | Flask server running, .txt file available | 1. Send POST to /detect-emotion 2. Attach a .txt file in form-data (key: image) | `{"error": "Invalid file type..."}` with HTTP 400 | `{"error": "Invalid file type. Please upload a jpg, jpeg, png or webp image"}` - HTTP 400 | ✅ PASS |
| TC21 | Error Handling - No file attached | Flask server running | 1. Send POST to /detect-emotion 2. Send request with empty body (no file) | `{"error": "No image file attached"}` with HTTP 400 | `{"error": "No image file attached"}` - HTTP 400 | ✅ PASS |
| TC22 | All 6 Emotions Detection | Flask server running, images for all 6 emotions available | 1. Send POST to /detect-emotion 2. Test with images for: happy, sad, angry, fear, neutral, surprise | All 6 emotions detected correctly with confidence scores | All 6 emotions detected: happy(76.14%), sad(99.28%), angry(99.83%), fear(40.89%), neutral(88.67%), surprise(100%) | ✅ PASS |
