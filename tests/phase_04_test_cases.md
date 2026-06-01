# Phase 4 Test Cases — YouTube Integration & Recommendations (Flask)

| Project Name | Emora - AI Music Recommendation Mobile Application |
|---|---|
| Phase | Phase 4 - YouTube Integration & Recommendations |
| Tester | Geethma |
| Date | 2026-05-22 |
| Pass | 12 |
| Fail | 0 |

---

| Test Case ID | Test Case Description | Pre-conditions | Test Steps | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|
| TC23 | Music Recommendation - Happy emotion | Flask server running on `http://127.0.0.1:5000` | 1. Send POST request to `/youtube/recommend-music`<br>2. Attach JSON body: `{"emotion": "happy"}` | Valid song recommendations list returned with HTTP 200 | Recommendations returned for `"happy"` emotion - HTTP 200 | ✅ PASS |
| TC24 | Response Structure Verification | Valid recommendation request sent | 1. Analyze the JSON response array from `/youtube/recommend-music` | Every object contains `videoId`, `title`, and `thumbnail` fields | All objects contain `videoId`, `title`, and `thumbnail` - HTTP 200 | ✅ PASS |
| TC25 | Capacity Check - All 6 Emotions | Flask server running, data source configured | 1. Loop POST requests to `/youtube/recommend-music` for `happy`, `sad`, `angry`, `fear`, `neutral`, `surprise` | Each of the 6 emotions successfully returns exactly 10 songs | All 6 emotions returned exactly 10 songs each - HTTP 200 | ✅ PASS |
| TC26 | Fallback Handling - Invalid Emotion | Flask server running | 1. Send POST request to `/youtube/recommend-music`<br>2. Pass an unsupported emotion string | System returns a default fallback list of songs instead of breaking | Fallback songs returned successfully - HTTP 200 | ✅ PASS |
| TC27 | Error Handling - Missing Request Field | Flask server running | 1. Send POST request to `/youtube/recommend-music`<br>2. Send an empty JSON body or omit the `"emotion"` key | `{"error": "Missing required field..."}` returned with HTTP 400 | Error returned for missing field - HTTP 400 | ✅ PASS |
| TC28 | Vibe-Genre Search - Valid Query | Flask server running | 1. Send GET request to `/explore/vibe-genre?query=sinhala` | Returns structured music data matching the `"sinhala"` query with HTTP 200 | Valid data returned for query `"sinhala"` - HTTP 200 | ✅ PASS |
| TC29 | Error Handling - Empty Explore Query | Flask server running | 1. Send GET request to `/explore/vibe-genre?query=` | Returns a bad request error message with HTTP 400 | Error returned for empty query string - HTTP 400 | ✅ PASS |
| TC30 | Recent Searches - Fetch History | Flask server running, user history exists | 1. Send GET request to `/youtube/recent-searches/test123` | Returns a list of previous search queries for user `"test123"` with HTTP 200 | User search history fetched successfully - HTTP 200 | ✅ PASS |
| TC31 | Recent Searches - Save Query | Flask server running | 1. Send POST request to `/youtube/recent-searches/test123` with query data | Search query is logged for the user, returning HTTP 201 Created | Search query saved successfully - HTTP 201 | ✅ PASS |
| TC32 | Vibe-Genre Search - Emotion Query | Flask server running | 1. Send GET request to `/explore/vibe-genre?query=happy songs` | Filters and returns relevant songs based on the vibe keyword with HTTP 200 | Relevant songs returned for `"happy songs"` - HTTP 200 | ✅ PASS |
| TC33 | HTTP Protocol Validation | Flask server running | 1. Execute all Phase 4 endpoints across edge test scenarios | All endpoints must strictly return correct semantic HTTP status codes (`200`, `201`, `400`) | All status codes matched expected specifications perfectly | ✅ PASS |
| TC34 | System Stability & Stress | Flask server running under continuous testing | 1. Execute rapid concurrent requests across all endpoints | The Flask server remains active and handles routing without unhandled exceptions or crashing | Zero server crashes or exceptions recorded during execution | ✅ PASS |

---
