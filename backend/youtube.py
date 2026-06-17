import os
import requests
import random
from flask import Blueprint, jsonify, request
from google.cloud.firestore_v1 import SERVER_TIMESTAMP
from firebase_config import db  

youtube_bp = Blueprint("youtube", __name__, url_prefix="/youtube")


EMOTION_HARDCODED_MAP = {
    "happy": [
        {"videoId": "a7fzkqLozwA", "title": "I Like Me Better", "artist": "Lauv", "thumbnail": "https://img.youtube.com/vi/a7fzkqLozwA/mqdefault.jpg", "duration": "3:17"},
        {"videoId": "Lf9OgcXV5cE", "title": "Beauty and a Beat", "artist": "Justin Bieber feat. Nicki Minaj", "thumbnail": "https://img.youtube.com/vi/Lf9OgcXV5cE/mqdefault.jpg", "duration": "4:53"},
        {"videoId": "JiDeN4h6eQk", "title": "Dancing In The Dark", "artist": "Rihanna", "thumbnail": "https://img.youtube.com/vi/JiDeN4h6eQk/mqdefault.jpg", "duration": "3:43"},
        {"videoId": "Il-an3K9pjg", "title": "2002", "artist": "Anne-Marie", "thumbnail": "https://img.youtube.com/vi/Il-an3K9pjg/mqdefault.jpg", "duration": "3:21"},
        {"videoId": "nYh-n7EOtMA", "title": "Cheap Thrills", "artist": "Sia", "thumbnail": "https://img.youtube.com/vi/nYh-n7EOtMA/mqdefault.jpg", "duration": "3:44"},
        {"videoId": "q4sLmgUD9xs", "title": "Better When I'm Dancin'", "artist": "Meghan Trainor", "thumbnail": "https://img.youtube.com/vi/q4sLmgUD9xs/mqdefault.jpg", "duration": "2:57"},
        {"videoId": "tD4HCZe-tew", "title": "Can't Stop the Feeling!", "artist": "Justin Timberlake", "thumbnail": "https://img.youtube.com/vi/tD4HCZe-tew/mqdefault.jpg", "duration": "3:56"},
        {"videoId": "fWNaR-rxAic", "title": "Call Me Maybe", "artist": "Carly Rae Jepsen", "thumbnail": "https://img.youtube.com/vi/fWNaR-rxAic/mqdefault.jpg", "duration": "3:13"},
        {"videoId": "oF8efZmoGZE", "title": "Shower", "artist": "Becky G", "thumbnail": "https://img.youtube.com/vi/oF8efZmoGZE/mqdefault.jpg", "duration": "3:26"},
        {"videoId": "UlANZSYZ2Js", "title": "What Makes You Beautiful", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/UlANZSYZ2Js/mqdefault.jpg", "duration": "3:18"}
    ],
    "neutral": [
        {"videoId": "ApXoWvfEYVU", "title": "Sunflower", "artist": "Post Malone & Swae Lee", "thumbnail": "https://img.youtube.com/vi/ApXoWvfEYVU/mqdefault.jpg", "duration": "2:42"},
        {"videoId": "by3yRdlQvzs", "title": "Location", "artist": "Khalid", "thumbnail": "https://img.youtube.com/vi/by3yRdlQvzs/mqdefault.jpg", "duration": "3:42"},
        {"videoId": "YdgoG8hTMUw", "title": "Banana Pancakes", "artist": "Jack Johnson", "thumbnail": "https://img.youtube.com/vi/YdgoG8hTMUw/mqdefault.jpg", "duration": "3:12"},
        {"videoId": "P3cffdsEXXw", "title": "Golden", "artist": "Harry Styles", "thumbnail": "https://img.youtube.com/vi/P3cffdsEXXw/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "2Vv-BfVoq4g", "title": "Perfect", "artist": "Ed Sheeran", "thumbnail": "https://img.youtube.com/vi/2Vv-BfVoq4g/mqdefault.jpg", "duration": "4:42"},
        {"videoId": "viimfQi_pUw", "title": "Ocean Eyes", "artist": "Billie Eilish", "thumbnail": "https://img.youtube.com/vi/viimfQi_pUw/mqdefault.jpg", "duration": "3:21"},
        {"videoId": "oyEuk8j8imI", "title": "Love Yourself", "artist": "Justin Bieber", "thumbnail": "https://img.youtube.com/vi/oyEuk8j8imI/mqdefault.jpg", "duration": "4:33"},
        {"videoId": "0zGcUoRlhmw", "title": "Closer", "artist": "The Chainsmokers feat. Halsey", "thumbnail": "https://img.youtube.com/vi/0zGcUoRlhmw/mqdefault.jpg", "duration": "4:07"},
        {"videoId": "m7Bc3pLyij0", "title": "Happier", "artist": "Marshmello feat. Bastille", "thumbnail": "https://img.youtube.com/vi/m7Bc3pLyij0/mqdefault.jpg", "duration": "3:54"},
        {"videoId": "euCqAq6BRa4", "title": "Let Me Love You", "artist": "DJ Snake feat. Justin Bieber", "thumbnail": "https://img.youtube.com/vi/euCqAq6BRa4/mqdefault.jpg", "duration": "3:26"},
        {"videoId": "mRD0-GxqHVo", "title": "Heat Waves", "artist": "Glass Animals", "thumbnail": "https://img.youtube.com/vi/mRD0-GxqHVo/mqdefault.jpg", "duration": "3:56"},
        {"videoId": "zABLecsR5UE", "title": "Someone You Loved", "artist": "Lewis Capaldi", "thumbnail": "https://img.youtube.com/vi/zABLecsR5UE/mqdefault.jpg", "duration": "3:06"},
        {"videoId": "VF-r5TtlT9w", "title": "Adore You", "artist": "Harry Styles", "thumbnail": "https://img.youtube.com/vi/VF-r5TtlT9w/mqdefault.jpg", "duration": "3:39"},
        {"videoId": "SlPhMPnQ58k", "title": "Memories", "artist": "Maroon 5", "thumbnail": "https://img.youtube.com/vi/SlPhMPnQ58k/mqdefault.jpg", "duration": "3:16"},
        {"videoId": "W-TE_Ys4iwM", "title": "Story of My Life", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/W-TE_Ys4iwM/mqdefault.jpg", "duration": "4:08"}
    ],
    "sad": [
        {"videoId": "nb8CnIo_-_A", "title": "Babydoll", "artist": "Dominic Fike", "thumbnail": "https://img.youtube.com/vi/nb8CnIo_-_A/mqdefault.jpg", "duration": "1:40"},
        {"videoId": "sElE_BfQ67s", "title": "Apocalypse", "artist": "Cigarettes After Sex", "thumbnail": "https://img.youtube.com/vi/sElE_BfQ67s/mqdefault.jpg", "duration": "4:51"},
        {"videoId": "odeHP8N4LKc", "title": "Let It Happen", "artist": "Tame Impala", "thumbnail": "https://img.youtube.com/vi/odeHP8N4LKc/mqdefault.jpg", "duration": "7:51"},
        {"videoId": "pyGU-UudvrM", "title": "I Thought I Saw Your Face Today", "artist": "She & Him", "thumbnail": "https://img.youtube.com/vi/pyGU-UudvrM/mqdefault.jpg", "duration": "2:51"},
        {"videoId": "lcCbn6wXdFw", "title": "Machakari (From 'Sillunu Oru Kadhal')", "artist": "A.R. Rahman", "thumbnail": "https://img.youtube.com/vi/lcCbn6wXdFw/mqdefault.jpg", "duration": "3:59"},
        {"videoId": "FvOpPeKSf_4", "title": "Glimpse of Us", "artist": "Joji", "thumbnail": "https://img.youtube.com/vi/FvOpPeKSf_4/mqdefault.jpg", "duration": "3:54"},
        {"videoId": "c8zq4kAn_O0", "title": "back to friends", "artist": "sombr", "thumbnail": "https://img.youtube.com/vi/c8zq4kAn_O0/mqdefault.jpg", "duration": "3:22"},
        {"videoId": "b3-lyX9O6kY", "title": "Iravingu Theevai (From '96')", "artist": "Govind Vasantha", "thumbnail": "https://img.youtube.com/vi/b3-lyX9O6kY/mqdefault.jpg", "duration": "4:18"},
        {"videoId": "DCYmJDO2_IE", "title": "Cinnamon Girl", "artist": "Lana Del Rey", "thumbnail": "https://img.youtube.com/vi/DCYmJDO2_IE/mqdefault.jpg", "duration": "5:01"},
        {"videoId": "U2SVCCENLjE", "title": "Co2", "artist": "Prateek Kuhad", "thumbnail": "https://img.youtube.com/vi/U2SVCCENLjE/mqdefault.jpg", "duration": "2:44"},
        {"videoId": "GCdwKhTtNNw", "title": "Sweater Weather", "artist": "The Neighbourhood", "thumbnail": "https://img.youtube.com/vi/GCdwKhTtNNw/mqdefault.jpg", "duration": "4:13"},
        {"videoId": "7wD4H3rghYU", "title": "Sundari Kannal (From 'Thalapathy')", "artist": "Ilaiyaraaja", "thumbnail": "https://img.youtube.com/vi/7wD4H3rghYU/mqdefault.jpg", "duration": "7:31"},
        {"videoId": "RBumgq5yVrA", "title": "Let Her Go", "artist": "Passenger", "thumbnail": "https://img.youtube.com/vi/RBumgq5yVrA/mqdefault.jpg", "duration": "4:15"},
        {"videoId": "5e4INH1yr9c", "title": "Nothing's New", "artist": "Rio Romeo", "thumbnail": "https://img.youtube.com/vi/5e4INH1yr9c/mqdefault.jpg", "duration": "3:29"},
        {"videoId": "MwpMEbgC7DA", "title": "Another Love", "artist": "Tom Odell", "thumbnail": "https://img.youtube.com/vi/MwpMEbgC7DA/mqdefault.jpg", "duration": "4:08"},
        {"videoId": "8kX6LwuhKLs", "title": "Happier", "artist": "Olivia Rodrigo", "thumbnail": "https://img.youtube.com/vi/8kX6LwuhKLs/mqdefault.jpg", "duration": "2:57"},
        {"videoId": "3XqqkrJENB4", "title": "Cry", "artist": "Cigarettes After Sex", "thumbnail": "https://img.youtube.com/vi/3XqqkrJENB4/mqdefault.jpg", "duration": "4:17"},
        {"videoId": "KtlgYxa6BMU", "title": "The Night We Met", "artist": "Lord Huron", "thumbnail": "https://img.youtube.com/vi/KtlgYxa6BMU/mqdefault.jpg", "duration": "3:29"},
        {"videoId": "TdrL3QxjyVw", "title": "Summertime Sadness", "artist": "Lana Del Rey", "thumbnail": "https://img.youtube.com/vi/TdrL3QxjyVw/mqdefault.jpg", "duration": "4:26"},
        {"videoId": "a2giXO6eyuI", "title": "Set Fire to the Rain", "artist": "Adele", "thumbnail": "https://img.youtube.com/vi/a2giXO6eyuI/mqdefault.jpg", "duration": "4:03"},
        {"videoId": "27CBPR7CSks", "title": "Kun Faya Kun (From 'Rockstar')", "artist": "A.R. Rahman", "thumbnail": "https://img.youtube.com/vi/27CBPR7CSks/mqdefault.jpg", "duration": "6:21"}
    ],
    "surprise": [
        {"videoId": "tR3PbDt5Q4Q", "title": "Irumbile Oru Idhaiyam (From 'Enthiran')", "artist": "A.R. Rahman feat. Lady Kash", "thumbnail": "https://img.youtube.com/vi/tR3PbDt5Q4Q/mqdefault.jpg", "duration": "4:59"},
        {"videoId": "fChxPoKGPI0", "title": "Endhira Logathu Sundariye (From '2.0')", "artist": "A.R. Rahman", "thumbnail": "https://img.youtube.com/vi/fChxPoKGPI0/mqdefault.jpg", "duration": "5:33"},
        {"videoId": "fJ9rUzIMcZQ", "title": "Bohemian Rhapsody", "artist": "Queen", "thumbnail": "https://img.youtube.com/vi/fJ9rUzIMcZQ/mqdefault.jpg", "duration": "5:55"},
        {"videoId": "PEM0Vs8jf1w", "title": "Golden Hour", "artist": "JVKE", "thumbnail": "https://img.youtube.com/vi/PEM0Vs8jf1w/mqdefault.jpg", "duration": "3:52"},
        {"videoId": "vxzfsBDx590", "title": "Vaathi Coming (From 'Master')", "artist": "Anirudh Ravichander", "thumbnail": "https://img.youtube.com/vi/vxzfsBDx590/mqdefault.jpg", "duration": "3:55"},
        {"videoId": "4Bsc2uI_LsM", "title": "Oorum Blood (From 'Dude')", "artist": "Sai Abhyankkar feat. Paal Dabba", "thumbnail": "https://img.youtube.com/vi/4Bsc2uI_LsM/mqdefault.jpg", "duration": "4:29"},
        {"videoId": "2ogKpj5QuSY", "title": "Aaluma Doluma (From 'Vedalam')", "artist": "Anirudh Ravichander", "thumbnail": "https://img.youtube.com/vi/2ogKpj5QuSY/mqdefault.jpg", "duration": "3:27"},
        {"videoId": "d-JBBNg8YKs", "title": "SICKO MODE", "artist": "Travis Scott", "thumbnail": "https://img.youtube.com/vi/d-JBBNg8YKs/mqdefault.jpg", "duration": "5:15"},
        {"videoId": "5GJWxDKyk3A", "title": "Mr. Brightside", "artist": "The Killers", "thumbnail": "https://img.youtube.com/vi/5GJWxDKyk3A/mqdefault.jpg", "duration": "3:44"},
        
    ],
    "fear": [
        {"videoId": "kN0iD0pI3o0", "title": "breathin", "artist": "Ariana Grande", "thumbnail": "https://img.youtube.com/vi/kN0iD0pI3o0/mqdefault.jpg", "duration": "3:18"},
        {"videoId": "Svfd999aej8", "title": "Keep Breathing", "artist": "Ingrid Michaelson", "thumbnail": "https://img.youtube.com/vi/Svfd999aej8/mqdefault.jpg", "duration": "3:26"},
        {"videoId": "HNBCVM4KbUM", "title": "Three Little Birds", "artist": "Bob Marley & The Wailers", "thumbnail": "https://img.youtube.com/vi/HNBCVM4KbUM/mqdefault.jpg", "duration": "3:00"},
        {"videoId": "C8QJmI_V3j4", "title": "By Your Side", "artist": "Sade", "thumbnail": "https://img.youtube.com/vi/C8QJmI_V3j4/mqdefault.jpg", "duration": "4:41"},
        {"videoId": "k4V3Mo61fJM", "title": "Fix You (Live)", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/k4V3Mo61fJM/mqdefault.jpg", "duration": "5:22"},
        {"videoId": "3jL4S4X97sQ", "title": "Vienna", "artist": "Billy Joel", "thumbnail": "https://img.youtube.com/vi/3jL4S4X97sQ/mqdefault.jpg", "duration": "3:34"},
        {"videoId": "GBSu_ltDu1w", "title": "Blackbird", "artist": "The Beatles", "thumbnail": "https://img.youtube.com/vi/GBSu_ltDu1w/mqdefault.jpg", "duration": "2:18"},
        {"videoId": "h3pJZSTQqIg", "title": "Strawberry Swing", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/h3pJZSTQqIg/mqdefault.jpg", "duration": "4:09"},
        {"videoId": "bEeaS6fuUoA", "title": "Lovely Day", "artist": "Bill Withers", "thumbnail": "https://img.youtube.com/vi/bEeaS6fuUoA/mqdefault.jpg", "duration": "4:15"},
        {"videoId": "36tggrpRoTI", "title": "In My Blood", "artist": "Shawn Mendes", "thumbnail": "https://img.youtube.com/vi/36tggrpRoTI/mqdefault.jpg", "duration": "3:31"}
    ],
    "angry": [
        {"videoId": "ElN_4vUvTPs", "title": "Human Nature", "artist": "Michael Jackson", "thumbnail": "https://img.youtube.com/vi/ElN_4vUvTPs/mqdefault.jpg", "duration": "4:06"},
        {"videoId": "a59gmGkq_pw", "title": "Cold Water", "artist": "Major Lazer feat. Justin Bieber & MØ", "thumbnail": "https://img.youtube.com/vi/a59gmGkq_pw/mqdefault.jpg", "duration": "3:06"},
        {"videoId": "bzRMneypG04", "title": "Fix You", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/bzRMneypG04/mqdefault.jpg", "duration": "4:56"},
        {"videoId": "A8dH4cKGa6s", "title": "Ordinary", "artist": "Alex Warren", "thumbnail": "https://img.youtube.com/vi/A8dH4cKGa6s/mqdefault.jpg", "duration": "2:34"},
        {"videoId": "6k8cpUkKK4c", "title": "Count on Me", "artist": "Bruno Mars", "thumbnail": "https://img.youtube.com/vi/6k8cpUkKK4c/mqdefault.jpg", "duration": "3:18"},
        {"videoId": "aY30nSWhX9g", "title": "Don't Let It Break Your Heart", "artist": "Louis Tomlinson", "thumbnail": "https://img.youtube.com/vi/aY30nSWhX9g/mqdefault.jpg", "duration": "3:25"},
        {"videoId": "Vt4Tq89R8u0", "title": "Just Hold On", "artist": "Steve Aoki & Louis Tomlinson", "thumbnail": "https://img.youtube.com/vi/Vt4Tq89R8u0/mqdefault.jpg", "duration": "3:19"},
        {"videoId": "8UY5BGFLtK0", "title": "Payphone", "artist": "Maroon 5 feat. Wiz Khalifa", "thumbnail": "https://img.youtube.com/vi/8UY5BGFLtK0/mqdefault.jpg", "duration": "3:52"},
        {"videoId": "MiAoetOXKcY", "title": "Say Yes To Heaven", "artist": "Lana Del Rey", "thumbnail": "https://img.youtube.com/vi/MiAoetOXKcY/mqdefault.jpg", "duration": "3:29"},
        {"videoId": "tdVAqxNLXiw", "title": "Yellow", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/tdVAqxNLXiw/mqdefault.jpg", "duration": "4:27"},
        {"videoId": "450p7goxZqg", "title": "All of Me", "artist": "John Legend", "thumbnail": "https://img.youtube.com/vi/450p7goxZqg/mqdefault.jpg", "duration": "4:43"}
    ]
  
}

@youtube_bp.route("/recommend-music", methods=["POST"])
def recommend_music():
    """POST /youtube/recommend-music"""
    body = request.get_json(silent=True)
    if not body or "emotion" not in body:
        return jsonify({"error": "Missing 'emotion' field in request body"}), 400
        
    input_emotion = str(body["emotion"]).strip().lower()
    
    # Fetch pool for this specific emotion
    full_pool = EMOTION_HARDCODED_MAP.get(input_emotion, EMOTION_HARDCODED_MAP["neutral"])
    
    # Safety fallback if the array list is completely empty
    if not full_pool:
        full_pool = EMOTION_HARDCODED_MAP["neutral"]
        
    if len(full_pool) > 10:
        selected_songs = random.sample(full_pool, 10)
    else:
        selected_songs = full_pool
        
    return jsonify(selected_songs), 200

@youtube_bp.route("/recommend-more", methods=["POST"])
def recommend_more_songs():
    """
    POST /youtube/recommend-more
    Takes a currently playing song's title and artist, and queries live recommendation tracks!
    """
    body = request.get_json(silent=True)
    
    if not body or "title" not in body or "artist" not in body:
        return jsonify({"error": "Missing 'title' or 'artist' parameter in request body"}), 400
        
    search_query = f"{body['title']} {body['artist']} similar songs"
    
    api_key = os.getenv("YOUTUBE_API_KEY")
    if not api_key:
        return jsonify({"error": "Server API configuration missing"}), 500

    print(f"📡 Requesting official live Google recommendations for keyword pool: '{search_query}'")
    
    
    google_url = (
        f"https://www.googleapis.com/youtube/v3/search"
        f"?part=snippet"
        f"&q={search_query}"
        f"&type=video"
        f"&videoCategoryId=10"
        f"&maxResults=10"
        f"&key={api_key}"
    )
    
    try:
        response = requests.get(google_url, timeout=8)
        data = response.json()
        
        if "items" not in data or not data["items"]:
            return jsonify(EMOTION_HARDCODED_MAP["neutral"]), 200 
            
        recommended_songs = []
        for item in data["items"]:
            if "videoId" not in item["id"]:
                continue
                
            video_id = item["id"]["videoId"]
            snippet = item["snippet"]
            
            recommended_songs.append({
                "videoId": video_id,
                "title": snippet.get("title", "Unknown Title"),
                "artist": snippet.get("channelTitle", "Unknown Artist").replace(" - Topic", ""),
                "thumbnail": f"https://img.youtube.com/vi/{video_id}/mqdefault.jpg",
                "duration": "3:30"
            })
            
        return jsonify(recommended_songs), 200
        
    except Exception as e:
        print(f"❌ Recommendation System Network Error: {str(e)}")
        return jsonify(EMOTION_HARDCODED_MAP["neutral"]), 200 



@youtube_bp.route("/recent-searches/<uid>", methods=["POST"])
def save_recent_search(uid: str):
    body = request.get_json(silent=True)
    if not body or "keyword" not in body:
        return jsonify({"error": "Missing 'keyword' field in request body"}), 400
    try:
        search_data = {"keyword": str(body["keyword"]).strip(), "timestamp": SERVER_TIMESTAMP}
        _, new_doc = db.collection("users").document(uid).collection("recent_searches").add(search_data)
        return jsonify({"id": new_doc.id, "message": "Search saved successfully"}), 201
    except Exception as e:
        return jsonify({"error": "Database write failure", "details": str(e)}), 500

@youtube_bp.route("/recent-searches/<uid>", methods=["GET"])
def get_recent_searches(uid: str):
    try:
        docs = db.collection("users").document(uid).collection("recent_searches").order_by("timestamp", direction="DESCENDING").stream()
        search_history = [{"id": doc.id, "keyword": doc.to_dict().get("keyword"), "timestamp": str(doc.to_dict().get("timestamp"))} for doc in docs]
        return jsonify(search_history), 200
    except Exception as e:
        return jsonify({"error": "Database retrieval failure", "details": str(e)}), 500