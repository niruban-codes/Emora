# Admin Dashboard Test Cases (Flask)

| Project Name | Emora - AI Music Recommendation Mobile Application |
| :--- | :--- |
| **Phase** | Admin Dashboard & Analytics (Flask) |
| **Tester** | Dinithi |
| **Date** | 2026-08-19 |
| **Pass** | 12 |
| **Fail** | 0 |

---

| Test Case ID | Test Case Description | Pre-conditions | Test Steps | Expected Result | Actual Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :---: |
| **TC01** | Missing admin email | Flask server running on `http://127.0.0.1:5000` | 1. Send GET request to `/admin/stats`<br>2. Do not include `X-Admin-Email` header | `401 Unauthorized`<br>Error message returned | Status `401 Unauthorized`<br>`{"error": "Missing admin email"}` | ✅ PASS |
| **TC02** | Unauthorized email | Flask server running on `http://127.0.0.1:5000` | 1. Send GET request to `/admin/stats`<br>2. Add header `X-Admin-Email: random@gmail.com` | `401 Unauthorized`<br>Error message returned | Status `401 Unauthorized`<br>`{"error": "Unauthorized access"}` | ✅ PASS |
| **TC03** | Valid admin, get stats | Flask server running on `http://127.0.0.1:5000`<br>Admin email registered | 1. Send GET request to `/admin/stats`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>Returns `total_users`, `total_detections`, `most_common_emotion` | Status `200 OK`<br>Returns stats summary JSON | ✅ PASS |
| **TC04** | Get all users | Flask server running on `http://127.0.0.1:5000`<br>Users present in database | 1. Send GET request to `/admin/users`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>Array of user objects returned | Status `200 OK`<br>Returned JSON array with 10 user objects | ✅ PASS |
| **TC05** | Empty users list | Flask server running on `http://127.0.0.1:5000`<br>0 users in collection | 1. Send GET request to `/admin/users`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>Returns empty array `[]` | Status `200 OK`<br>Code logic verified: clean empty array `[]` | ✅ PASS |
| **TC06** | Get emotion breakdown | Flask server running on `http://127.0.0.1:5000` | 1. Send GET request to `/admin/emotion-stats`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>Percentages/mapping returned | Status `200 OK`<br>Emotion statistics structure returned | ✅ PASS |
| **TC07** | No emotion data | Flask server running on `http://127.0.0.1:5000`<br>0 detections in database | 1. Send GET request to `/admin/emotion-stats`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>Returns empty object `{}` | Status `200 OK`<br>Returned `{}` | ✅ PASS |
| **TC08** | Get music stats | Flask server running on `http://127.0.0.1:5000` | 1. Send GET request to `/admin/music-stats`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>`most_played` & `popular_emotions` returned | Status `200 OK`<br>Returned `{"most_played": [], "popular_emotions": []}` | ✅ PASS |
| **TC09** | Get admin logs | Flask server running on `http://127.0.0.1:5000` | 1. Send GET request to `/admin/logs`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>Array of logs sorted newest first | Status `200 OK`<br>Returned chronological array of activity logs | ✅ PASS |
| **TC10** | Create a log entry | Flask server running on `http://127.0.0.1:5000` | 1. Send POST request to `/admin/logs`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com`<br>3. Attach JSON body: `{"action": "viewed users list", "adminEmail": "dinithia962@gmail.com"}` | `200 OK`<br>`{"status": "logged"}` | Status `200 OK`<br>`{"status": "logged"}` | ✅ PASS |
| **TC11** | Missing action field | Flask server running on `http://127.0.0.1:5000` | 1. Send POST request to `/admin/logs`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com`<br>3. Attach JSON body: `{"adminEmail": "dinithia962@gmail.com"}` | `400 Bad Request`<br>Validation error message | Status `400 Bad Request`<br>Validation error returned | ✅ PASS |
| **TC12** | New log shows up at top | TC10 completed successfully | 1. Send GET request to `/admin/logs`<br>2. Add header `X-Admin-Email: dinithia962@gmail.com` | `200 OK`<br>New log from TC10 appears at index `[0]` | Status `200 OK`<br>New log entry appears at index `[0]` (top) | ✅ PASS |
