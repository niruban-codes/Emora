# Phase 5 — Flutter Integration Test Cases

**Builder:** Hafsa  
**Tester:** Wathsiluni  
**Test Case Range:** TC35–TC44  
**Total Test Cases:** 10

| TCID | TC Description | Pre Conditions | Test Steps | Expected Results | Actual Results | Status |
|---|---|---|---|---|---|---|
| TC35 | Verify photo capture/upload and emotion detection. | App installed; permissions granted; backend and internet available. | Open app → camera/upload → take/select photo → submit. | Photo uploads and detected emotion is displayed. | Photo was successfully uploaded and the correct emotion was displayed. | PASS |
| TC36 | Verify music recommendations appear after emotion detection. | Emotion detection successful; recommendation API and internet available. | Complete detection → wait for response → observe screen. | Recommendations matching the detected emotion appear automatically. | Music recommendations appeared automatically after emotion detection. | PASS |
| TC37 | Verify a recommended video can be opened and played. | Recommendations are displayed; internet available. | Open playlist → tap a video → observe player. | Selected video opens and plays without errors. | The selected video opened and played successfully without errors. | PASS |
| TC38 | Verify successful emotion detection is saved to Mood History. | User logged in; detection successful; database available. | Perform detection → open Mood History. | Detection appears with correct emotion and date/time. | The detection was saved and appeared in Mood History with the correct emotion and date/time. | PASS |
| TC39 | Verify multiple detections are stored separately. | User logged in; database available. | Perform two detections → open Mood History. | Each detection appears as a separate record. | Both detections were saved as separate records with correct emotions and timestamps. | PASS |
| TC40 | Verify loading indicators during API requests. | Backend and internet available. | Start detection → observe during request → wait for response. | Loading indicator appears during request and disappears after response. | Loading indicator appeared during the API request and disappeared after the response. | PASS |
| TC41 | Verify network/API failure is handled without crashing. | App open on detection screen; internet can be disabled. | Disable internet → submit photo → observe response. | Friendly error is shown and app does not crash. | A friendly network error was displayed and the app remained responsive without crashing. | PASS |
| TC42 | Verify complete flow on a real Android device. | Supported Android device; permissions, backend and internet available. | Open app → upload photo → detect → view recommendations → play video. | Complete flow works without errors. | The complete flow was successfully completed on the Android device without errors. | PASS |
| TC43 | Verify complete flow on a real iOS device. | Supported iOS device; permissions, backend and internet available. | Open app → upload photo → detect → view recommendations → play video. | Complete flow works without errors. | The complete flow was successfully completed on the iOS device without errors. | PASS |
| TC44 | Verify complete demo flow works three consecutive times. | App, backend, database, recommendation service and internet available. | Run complete flow three times consecutively. | All three runs complete without crashes or incorrect results. | The complete flow was successfully repeated three times without crashes, failed requests, or incorrect results. | PASS |