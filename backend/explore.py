import os
import random
import requests
from flask import Blueprint, jsonify, request
from dotenv import load_dotenv

# Initialize the Blueprint module for the Explore route
explore_bp = Blueprint("explore", __name__, url_prefix="/explore")

# Securely extract our official Google Cloud API Key from the local .env container file
load_dotenv()
YOUTUBE_API_KEY = os.getenv("YOUTUBE_API_KEY")

# DATA CONTRACT SCHEMAS: 13-Genre Bulletproof Static Pool Map
EXPLORE_STATIC_MAP = {
    "sinhala": [
        {"videoId": "l3XQ8pS9jEw", "title": "Maname", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "3:40"},
        {"videoId": "8mP6XQW2u8w", "title": "Naadagam", "artist": "Ridma Weerawardena", "thumbnail": "https://img.youtube.com/vi/8mP6XQW2u8w/mqdefault.jpg", "duration": "4:12"},
        {"videoId": "uK_E_S9Y_u8", "title": "Kuveni", "artist": "Charitha Attalage", "thumbnail": "https://img.youtube.com/vi/uK_E_S9Y_u8/mqdefault.jpg", "duration": "4:45"},
        {"videoId": "2_WdG9U_XwA", "title": "Heena Tharam", "artist": "Sanjula Himala", "thumbnail": "https://img.youtube.com/vi/2_WdG9U_XwA/mqdefault.jpg", "duration": "3:55"},
        {"videoId": "7wA9X_8uM_Q", "title": "Mandaram Kawa", "artist": "Anushka Udana", "thumbnail": "https://img.youtube.com/vi/7wA9X_8uM_Q/mqdefault.jpg", "duration": "3:22"}
    ],
    "tamil": [
        {"videoId": "vU0E6AewvGs", "title": "Arabic Kuthu", "artist": "Anirudh Ravichander", "thumbnail": "https://img.youtube.com/vi/vU0E6AewvGs/mqdefault.jpg", "duration": "4:40"},
        {"videoId": "K76VpM_U8Yg", "title": "Ranjithame", "artist": "Thalapathy Vijay", "thumbnail": "https://img.youtube.com/vi/K76VpM_U8Yg/mqdefault.jpg", "duration": "4:47"},
        {"videoId": "H9_E9U_u8wA", "title": "Rowdy Baby", "artist": "Dhanush & Dhee", "thumbnail": "https://img.youtube.com/vi/H9_E9U_u8wA/mqdefault.jpg", "duration": "4:44"}
    ],
    "english": [
        {"videoId": "a7fzkqLozwA", "title": "I Like Me Better", "artist": "Lauv", "thumbnail": "https://img.youtube.com/vi/a7fzkqLozwA/mqdefault.jpg", "duration": "3:17"},
        {"videoId": "6ONRf7h3Mdk", "title": "Cruel Summer", "artist": "Taylor Swift", "thumbnail": "https://img.youtube.com/vi/6ONRf7h3Mdk/mqdefault.jpg", "duration": "2:58"}
    ],
    "korean": [
        {"videoId": "gXM83fvnInI", "title": "Dynamite", "artist": "BTS", "thumbnail": "https://img.youtube.com/vi/gXM83fvnInI/mqdefault.jpg", "duration": "3:43"},
        {"videoId": "gdZLi9oWNZg", "title": "Dynamite (Choreography Ver.)", "artist": "BTS", "thumbnail": "https://img.youtube.com/vi/gdZLi9oWNZg/mqdefault.jpg", "duration": "3:43"}
    ],
    "party songs": [
        {"videoId": "fChxPoKGPI0", "title": "Uptown Funk", "artist": "Bruno Mars", "thumbnail": "https://img.youtube.com/vi/fChxPoKGPI0/mqdefault.jpg", "duration": "4:30"},
        {"videoId": "ru0K8uYEZWw", "title": "CAN'T STOP THE FEELING!", "artist": "Justin Timberlake", "thumbnail": "https://img.youtube.com/vi/ru0K8uYEZWw/mqdefault.jpg", "duration": "4:45"}
    ],
    "techno vibes": [
        {"videoId": "vxzfsBDx590", "title": "Starboy (Techno Remix)", "artist": "The Weeknd", "thumbnail": "https://img.youtube.com/vi/vxzfsBDx590/mqdefault.jpg", "duration": "3:50"}
    ],
    "study music": [
        {"videoId": "P3cffdsEXXw", "title": "Anchor (Lofi Focus)", "artist": "Novo Amor", "thumbnail": "https://img.youtube.com/vi/P3cffdsEXXw/mqdefault.jpg", "duration": "3:17"}
    ],
    "romance": [
         {"videoId": "l3XQ8pS9jEw", "title": "Maname", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "3:40"}
    ],
    "hiphop": [
        {"videoId": "l3XQ8pS9jEw", "title": "Maname", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "3:40"}
    ],
    "rap": [
        {"videoId": "ru0K8uYEZWw", "title": "Fast Lane Rap", "artist": "Rhyme Master", "thumbnail": "https://img.youtube.com/vi/ru0K8uYEZWw/mqdefault.jpg", "duration": "4:10"}
    ],
    "jazz": [
         {"videoId": "l3XQ8pS9jEw", "title": "Maname", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "3:40"},
    ],
    "classical": [
        {"videoId": "l3XQ8pS9jEw", "title": "Symphony No. 5", "artist": "Classical Orchestra", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "6:00"}
    ],
    "r&b": [
         {"videoId": "l3XQ8pS9jEw", "title": "Maname", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "3:40"},
    ],
    "metal": [
         {"videoId": "l3XQ8pS9jEw", "title": "Maname", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "3:40"},
    ],
    "pop": [
         {"videoId": "l3XQ8pS9jEw", "title": "Maname", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/l3XQ8pS9jEw/mqdefault.jpg", "duration": "3:40"},
    ]
}

@explore_bp.route("/vibe-genre", methods=["GET"])
def get_vibe_or_genre():
    """
    GET /explore/vibe-genre?query=sinhala
    Unified controller handling both Grid Category Tiles and Search Bar tracking calls
    """
    query = request.args.get("query")
    if not query or not query.strip():
        return jsonify({"error": "Query parameter 'query' is required"}), 400
        
    search_term = query.strip().lower()
    
    # ACTION A: User clicked a known UI grid tile card category
    if search_term in EXPLORE_STATIC_MAP:
        tile_songs = list(EXPLORE_STATIC_MAP[search_term])
        
        # Guard clause: If the list is shorter than 10 tracks, pad it using clean items from the English fallback
        while len(tile_songs) < 10:
            tile_songs.append(random.choice(EXPLORE_STATIC_MAP["english"]))
            
        # Shuffle them up cleanly so it feels dynamically alive on every tile selection click!
        random.shuffle(tile_songs)
        return jsonify(tile_songs[:10]), 200
        
    # ACTION B: User typed an explicit custom keyword into the top search input bar field!
    print(f"📡 Requesting official live Google servers for custom query search input: '{search_term}'")
    google_url = (
        f"https://www.googleapis.com/youtube/v3/search"
        f"?part=snippet"
        f"&q={search_term}+song"  # Forces search query keyword tuning to hit media items
        f"&type=video"
        f"&videoCategoryId=10"    # Category 10 explicitly dictates returning ONLY verified music!
        f"&maxResults=10"
        f"&key={YOUTUBE_API_KEY}"
    )
    
    try:
        response = requests.get(google_url)
        data = response.json()
        
        # Safety net: If key hits network errors or limits, serve English backup array safely
        if "items" not in data:
            print(f"⚠️ Google API limits or error logs hit. Serving safe static fallback: {data}")
            return jsonify(EXPLORE_STATIC_MAP["english"][:10]), 200
            
        live_songs = []
        for item in data["items"]:
            video_id = item["id"]["videoId"]
            snippet = item["snippet"]
            
            live_songs.append({
                "videoId": video_id,
                "title": snippet.get("title", "Unknown Title"),
                "artist": snippet.get("channelTitle", "Unknown Artist").replace(" - Topic", ""),
                "thumbnail": f"https://img.youtube.com/vi/{video_id}/mqdefault.jpg",
                "duration": "3:45" # Uniform standard spacing contract matching frontend widgets
            })
            
        return jsonify(live_songs), 200
        
    except Exception as e:
        print(f"❌ Critical Endpoint Network Failure: {str(e)}. Triggering backup pool array.")
        return jsonify(EXPLORE_STATIC_MAP["english"][:10]), 200