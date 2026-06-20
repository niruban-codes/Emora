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
        {"videoId": "UlANZSYZ2Js", "title": "What Makes You Beautiful", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/UlANZSYZ2Js/mqdefault.jpg", "duration": "3:18"},
        {"videoId": "nfWlot6h_JM", "title": "Shake It Off", "artist": "Taylor Swift", "thumbnail": "https://img.youtube.com/vi/nfWlot6h_JM/mqdefault.jpg", "duration": "3:39"},
        {"videoId": "ZbZSe6N_BXs", "title": "Happy", "artist": "Pharrell Williams", "thumbnail": "https://img.youtube.com/vi/ZbZSe6N_BXs/mqdefault.jpg", "duration": "3:53"},
        {"videoId": "6JCLY0Rlx6Q", "title": "Shut Up and Dance", "artist": "WALK THE MOON", "thumbnail": "https://img.youtube.com/vi/6JCLY0Rlx6Q/mqdefault.jpg", "duration": "3:19"},
        {"videoId": "TUVcZfQe-Kw", "title": "Levitating", "artist": "Dua Lipa feat. DaBaby", "thumbnail": "https://img.youtube.com/vi/TUVcZfQe-Kw/mqdefault.jpg", "duration": "3:23"},
        {"videoId": "gdZLi9oWNZg", "title": "Dynamite", "artist": "BTS", "thumbnail": "https://img.youtube.com/vi/gdZLi9oWNZg/mqdefault.jpg", "duration": "3:19"},
        {"videoId": "OPf0YbXqDm0", "title": "Uptown Funk", "artist": "Mark Ronson feat. Bruno Mars", "thumbnail": "https://img.youtube.com/vi/OPf0YbXqDm0/mqdefault.jpg", "duration": "4:30"},
        {"videoId": "UqyT8IEBkvY", "title": "24K Magic", "artist": "Bruno Mars", "thumbnail": "https://img.youtube.com/vi/UqyT8IEBkvY/mqdefault.jpg", "duration": "3:46"},
        {"videoId": "7oBU7d5oenQ", "title": "Good Time", "artist": "Owl City & Carly Rae Jepsen", "thumbnail": "https://img.youtube.com/vi/7oBU7d5oenQ/mqdefault.jpg", "duration": "3:26"},
        {"videoId": "SmbmeOgWsqE", "title": "Good As Hell", "artist": "Lizzo", "thumbnail": "https://img.youtube.com/vi/SmbmeOgWsqE/mqdefault.jpg", "duration": "2:46"},
        {"videoId": "ekr2nIex040", "title": "APT.", "artist": "ROSÉ & Bruno Mars", "thumbnail": "https://img.youtube.com/vi/ekr2nIex040/mqdefault.jpg", "duration": "2:54"}
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
        {"videoId": "W-TE_Ys4iwM", "title": "Story of My Life", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/W-TE_Ys4iwM/mqdefault.jpg", "duration": "4:08"},
        {"videoId": "A8dH4cKGa6s", "title": "Ordinary", "artist": "Alex Warren", "thumbnail": "https://img.youtube.com/vi/A8dH4cKGa6s/mqdefault.jpg", "duration": "2:34"},
        {"videoId": "UM3389FUnKo", "title": "Night Changes", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/UM3389FUnKo/mqdefault.jpg", "duration": "3:42"},
        {"videoId": "KRUWn3dLoRg", "title": "Ghost", "artist": "Justin Bieber", "thumbnail": "https://img.youtube.com/vi/KRUWn3dLoRg/mqdefault.jpg", "duration": "2:33"},
        {"videoId": "PaOGelP1JE0", "title": "Home", "artist": "Chris Mason", "thumbnail": "https://img.youtube.com/vi/PaOGelP1JE0/mqdefault.jpg", "duration": "3:52"},
        {"videoId": "K4DyBUG242c", "title": "On & On", "artist": "Cartoon & Jéja", "thumbnail": "https://img.youtube.com/vi/K4DyBUG242c/mqdefault.jpg", "duration": "3:27"},
        {"videoId": "RJOqJ-RitOg", "title": "Just Hold On", "artist": "Steve Aoki & Louis Tomlinson", "thumbnail": "https://img.youtube.com/vi/RJOqJ-RitOg/mqdefault.jpg", "duration": "3:19"},
        {"videoId": "U9pGr6KMdyg", "title": "Where We Started", "artist": "Lost Sky feat. Jex", "thumbnail": "https://img.youtube.com/vi/U9pGr6KMdyg/mqdefault.jpg", "duration": "3:41"},
        {"videoId": "u9raS7-NisU", "title": "Daylight", "artist": "Taylor Swift", "thumbnail": "https://img.youtube.com/vi/u9raS7-NisU/mqdefault.jpg", "duration": "4:53"},
        {"videoId": "rbmdfEQODOw", "title": "The Fate of Ophelia", "artist": "Taylor Swift", "thumbnail": "https://img.youtube.com/vi/rbmdfEQODOw/mqdefault.jpg", "duration": "3:59"},
        {"videoId": "T8_o-hCDvk", "title": "Clouds", "artist": "JVKE", "thumbnail": "https://img.youtube.com/vi/T8_o-hCDvk/mqdefault.jpg", "duration": "2:44"}
    ],
    "sad": [
        {"videoId": "Cd0Y5yTEbKQ", "title": "Forbidden Fruit", "artist": "Sam Tinnesz X Tommee Profitt X brooke", "thumbnail": "https://img.youtube.com/vi/Cd0Y5yTEbKQ/mqdefault.jpg", "duration": "3:25"},
        {"videoId": "aY30nSWhX9g", "title": "Don't Let It Break Your Heart", "artist": "Louis Tomlinson", "thumbnail": "https://img.youtube.com/vi/aY30nSWhX9g/mqdefault.jpg", "duration": "3:25"},
        {"videoId": "4fqwVBuunxY", "title": "Hurts So Good", "artist": "Astrid S", "thumbnail": "https://img.youtube.com/vi/4fqwVBuunxY/mqdefault.jpg", "duration": "3:29"},
        {"videoId": "m4iPSPoe1Y8", "title": "See You Again", "artist": "Wiz Khalifa feat. Charlie Puth", "thumbnail": "https://img.youtube.com/vi/m4iPSPoe1Y8/mqdefault.jpg", "duration": "3:58"},
        {"videoId": "2PRvp-mP_q0", "title": "drivers license", "artist": "Olivia Rodrigo", "thumbnail": "https://img.youtube.com/vi/2PRvp-mP_q0/mqdefault.jpg", "duration": "4:07"},
        {"videoId": "WQq98YPV8yk", "title": "Moral of the Story", "artist": "Ashe", "thumbnail": "https://img.youtube.com/vi/WQq98YPV8yk/mqdefault.jpg", "duration": "3:21"},
        {"videoId": "8TpcBDJZsJA", "title": "Happier", "artist": "Ed Sheeran", "thumbnail": "https://img.youtube.com/vi/8TpcBDJZsJA/mqdefault.jpg", "duration": "3:41"},
        {"videoId": "eiG_DUXD8YQ", "title": "Treat You Better", "artist": "Shawn Mendes", "thumbnail": "https://img.youtube.com/vi/eiG_DUXD8YQ/mqdefault.jpg", "duration": "3:08"},
        {"videoId": "jKIEUdAMtrQ", "title": "Minefields", "artist": "Faouzia & John Legend", "thumbnail": "https://img.youtube.com/vi/jKIEUdAMtrQ/mqdefault.jpg", "duration": "3:13"},
        {"videoId": "AG-erEMhumc", "title": "you broke me first", "artist": "Tate McRae", "thumbnail": "https://img.youtube.com/vi/AG-erEMhumc/mqdefault.jpg", "duration": "2:49"},
        {"videoId": "V1Pl8CzNzCw", "title": "lovely", "artist": "Billie Eilish & Khalid", "thumbnail": "https://img.youtube.com/vi/V1Pl8CzNzCw/mqdefault.jpg", "duration": "3:20"},
        {"videoId": "51u5fnyrGj4", "title": "Arcade", "artist": "Duncan Laurence", "thumbnail": "https://img.youtube.com/vi/51u5fnyrGj4/mqdefault.jpg", "duration": "3:04"},
        {"videoId": "hLQl3WQQoQ0", "title": "Someone Like You", "artist": "Adele", "thumbnail": "https://img.youtube.com/vi/hLQl3WQQoQ0/mqdefault.jpg", "duration": "4:45"},
        {"videoId": "mzQ8eepcJGQ", "title": "I'm Not The Only One", "artist": "Sam Smith", "thumbnail": "https://img.youtube.com/vi/mzQ8eepcJGQ/mqdefault.jpg", "duration": "3:59"},
        {"videoId": "8v_4O44sfjM", "title": "jar of hearts", "artist": "Christina Perri", "thumbnail": "https://img.youtube.com/vi/8v_4O44sfjM/mqdefault.jpg", "duration": "4:06"},
        {"videoId": "5-ZiKXrnvog", "title": "Dynasty", "artist": "MIIA", "thumbnail": "https://img.youtube.com/vi/5-ZiKXrnvog/mqdefault.jpg", "duration": "3:46"},
        {"videoId": "a2giXO6eyuI", "title": "Set Fire to the Rain", "artist": "Adele", "thumbnail": "https://img.youtube.com/vi/a2giXO6eyuI/mqdefault.jpg", "duration": "4:03"},
        {"videoId": "Pvcc5yEPpTc", "title": "We Don't Talk Anymore", "artist": "Charlie Puth feat. Selena Gomez", "thumbnail": "https://img.youtube.com/vi/Pvcc5yEPpTc/mqdefault.jpg", "duration": "3:37"},
        {"videoId": "50VNCymT-Cs", "title": "Let Me Down Slowly", "artist": "Alec Benjamin", "thumbnail": "https://img.youtube.com/vi/50VNCymT-Cs/mqdefault.jpg", "duration": "2:49"},
        {"videoId": "Ow7Zg2AUZks", "title": "Before You Go", "artist": "Lewis Capaldi", "thumbnail": "https://img.youtube.com/vi/Ow7Zg2AUZks/mqdefault.jpg", "duration": "3:35"}
    ],  
    "surprise": [
        {"videoId": "IpFX2vq8HKw", "title": "blue", "artist": "yung kai", "thumbnail": "https://img.youtube.com/vi/IpFX2vq8HKw/mqdefault.jpg", "duration": "3:24"},
        {"videoId": "1wq47tabJh0", "title": "Mood", "artist": "Yagih Mael", "thumbnail": "https://img.youtube.com/vi/1wq47tabJh0/mqdefault.jpg", "duration": "3:22"},
        {"videoId": "V9PVRfjEBTI", "title": "BIRDS OF A FEATHER", "artist": "Billie Eilish", "thumbnail": "https://img.youtube.com/vi/V9PVRfjEBTI/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "f5-IY_Ja1RM", "title": "her", "artist": "JVKE", "thumbnail": "https://img.youtube.com/vi/f5-IY_Ja1RM/mqdefault.jpg", "duration": "3:21"},
        {"videoId": "JAERpGGh-wA", "title": "Infinity", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/JAERpGGh-wA/mqdefault.jpg", "duration": "4:09"},
        {"videoId": "09efb966Bn8", "title": "Beauty And A Beat (Acoustic)", "artist": "Justin Bieber", "thumbnail": "https://img.youtube.com/vi/09efb966Bn8/mqdefault.jpg", "duration": "3:10"},
        {"videoId": "KrgJp7Z1Hv8", "title": "It'll Be Okay", "artist": "Shawn Mendes", "thumbnail": "https://img.youtube.com/vi/KrgJp7Z1Hv8/mqdefault.jpg", "duration": "3:43"},
        {"videoId": "aZDlaZCpKYw", "title": "pick up the phone", "artist": "Henry Moodie", "thumbnail": "https://img.youtube.com/vi/aZDlaZCpKYw/mqdefault.jpg", "duration": "3:24"},
        {"videoId": "W8a4sUabCUo", "title": "Dandelions", "artist": "Ruth B.", "thumbnail": "https://img.youtube.com/vi/W8a4sUabCUo/mqdefault.jpg", "duration": "3:53"},
        {"videoId": "k4V3Mo61fJM", "title": "Fix You", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/k4V3Mo61fJM/mqdefault.jpg", "duration": "4:56"},
        {"videoId": "A8dH4cKGa6s", "title": "Ordinary", "artist": "Alex Warren", "thumbnail": "https://img.youtube.com/vi/A8dH4cKGa6s/mqdefault.jpg", "duration": "2:34"},
        {"videoId": "KRUWn3dLoRg", "title": "Ghost", "artist": "Justin Bieber", "thumbnail": "https://img.youtube.com/vi/KRUWn3dLoRg/mqdefault.jpg", "duration": "2:33"},
        {"videoId": "8ofCZObsnOo", "title": "Hold On", "artist": "Chord Overstreet", "thumbnail": "https://img.youtube.com/vi/8ofCZObsnOo/mqdefault.jpg", "duration": "3:19"},
        {"videoId": "iKzRIweSBLA", "title": "Perfect", "artist": "Ed Sheeran", "thumbnail": "https://img.youtube.com/vi/iKzRIweSBLA/mqdefault.jpg", "duration": "4:23"},
        {"videoId": "vv3um0BlygY", "title": "Enchanted", "artist": "Taylor Swift", "thumbnail": "https://img.youtube.com/vi/vv3um0BlygY/mqdefault.jpg", "duration": "5:52"},
        {"videoId": "Io2Yjy3nV_c", "title": "YOUTH", "artist": "Troye Sivan", "thumbnail": "https://img.youtube.com/vi/Io2Yjy3nV_c/mqdefault.jpg", "duration": "3:05"},
        {"videoId": "RVv_rate258", "title": "Why Don't You Stay", "artist": "Jeff Satur", "thumbnail": "https://img.youtube.com/vi/RVv_rate258/mqdefault.jpg", "duration": "3:47"},
        {"videoId": "r8EVmdyJp-M", "title": "24/7, 365", "artist": "elijah woods", "thumbnail": "https://img.youtube.com/vi/r8EVmdyJp-M/mqdefault.jpg", "duration": "3:11"},
        {"videoId": "J_QGZspO4gg", "title": "Snowman", "artist": "Sia", "thumbnail": "https://img.youtube.com/vi/J_QGZspO4gg/mqdefault.jpg", "duration": "2:45"},
        {"videoId": "GxldQ9eX2wo", "title": "Until I Found You", "artist": "Stephen Sanchez", "thumbnail": "https://img.youtube.com/vi/GxldQ9eX2wo/mqdefault.jpg", "duration": "2:57"}
    ],
    "fear": [
        {"videoId": "k4V3Mo61fJM", "title": "Fix You (Live)", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/k4V3Mo61fJM/mqdefault.jpg", "duration": "5:22"},
        {"videoId": "psuRGfAaju4", "title": "Fireflies", "artist": "Owl City", "thumbnail": "https://img.youtube.com/vi/psuRGfAaju4/mqdefault.jpg", "duration": "3:48"},
        {"videoId": "HhjHYkPQ8F0", "title": "Alone, Pt. II", "artist": "Alan Walker & Ava Max", "thumbnail": "https://img.youtube.com/vi/HhjHYkPQ8F0/mqdefault.jpg", "duration": "2:59"},
        {"videoId": "h3pJZSTQqIg", "title": "Strawberry Swing", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/h3pJZSTQqIg/mqdefault.jpg", "duration": "4:09"},
        {"videoId": "JAERpGGh-wA", "title": "Infinity", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/JAERpGGh-wA/mqdefault.jpg", "duration": "4:09"},
        {"videoId": "ZNra8eK0K6k", "title": "How Far I'll Go", "artist": "Alessia Cara", "thumbnail": "https://img.youtube.com/vi/ZNra8eK0K6k/mqdefault.jpg", "duration": "2:55"},
        {"videoId": "up3_D60P6l8", "title": "The Water Is Fine", "artist": "Chloe Ament", "thumbnail": "https://img.youtube.com/vi/up3_D60P6l8/mqdefault.jpg", "duration": "4:10"},
        {"videoId": "Xdv83MFJd7U", "title": "Seasons In The Sun", "artist": "Westlife", "thumbnail": "https://img.youtube.com/vi/Xdv83MFJd7U/mqdefault.jpg", "duration": "4:01"},
        {"videoId": "OT5msu-dap8", "title": "Shape Of My Heart", "artist": "Backstreet Boys", "thumbnail": "https://img.youtube.com/vi/OT5msu-dap8/mqdefault.jpg", "duration": "3:50"},
        {"videoId": "KKQl-pIRQMY", "title": "Photograph", "artist": "Ed Sheeran", "thumbnail": "https://img.youtube.com/vi/KKQl-pIRQMY/mqdefault.jpg", "duration": "4:19"},
        {"videoId": "PEM0Vs8jf1w", "title": "Golden Hour", "artist": "JVKE", "thumbnail": "https://img.youtube.com/vi/PEM0Vs8jf1w/mqdefault.jpg", "duration": "3:52"},
        {"videoId": "ElN_4vUvTPs", "title": "Human Nature", "artist": "Michael Jackson", "thumbnail": "https://img.youtube.com/vi/ElN_4vUvTPs/mqdefault.jpg", "duration": "4:06"},
        {"videoId": "f5-IY_Ja1RM", "title": "Her", "artist": "JVKE", "thumbnail": "https://img.youtube.com/vi/f5-IY_Ja1RM/mqdefault.jpg", "duration": "3:21"},
        {"videoId": "ddShTTQKao0", "title": "Heaven", "artist": "Calum Scott", "thumbnail": "https://img.youtube.com/vi/ddShTTQKao0/mqdefault.jpg", "duration": "3:14"},
        {"videoId": "DCYmJDO2_IE", "title": "Cinnamon Girl", "artist": "Lana Del Rey", "thumbnail": "https://img.youtube.com/vi/DCYmJDO2_IE/mqdefault.jpg", "duration": "5:01"},
        {"videoId": "85NWn-k1p58", "title": "Fade", "artist": "Jeff Satur", "thumbnail": "https://img.youtube.com/vi/85NWn-k1p58/mqdefault.jpg", "duration": "4:22"},
        {"videoId": "96C7zX178-s", "title": "Right Now", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/96C7zX178-s/mqdefault.jpg", "duration": "3:20"},
        {"videoId": "W8a4sUabCUo", "title": "Dandelions", "artist": "Ruth B.", "thumbnail": "https://img.youtube.com/vi/W8a4sUabCUo/mqdefault.jpg", "duration": "3:53"},
        {"videoId": "b-BYf-BpC3Y", "title": "Different Kind Of Beautiful", "artist": "Alec Benjamin", "thumbnail": "https://img.youtube.com/vi/b-BYf-BpC3Y/mqdefault.jpg", "duration": "3:21"},
        {"videoId": "GZXHBgjQjNM", "title": "Drowning", "artist": "Backstreet Boys", "thumbnail": "https://img.youtube.com/vi/GZXHBgjQjNM/mqdefault.jpg", "duration": "4:28"}
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
        {"videoId": "450p7goxZqg", "title": "All of Me", "artist": "John Legend", "thumbnail": "https://img.youtube.com/vi/450p7goxZqg/mqdefault.jpg", "duration": "4:43"},
        {"videoId": "KIfYtDl4B2g", "title": "Numb", "artist": "Linkin Park", "thumbnail": "https://img.youtube.com/vi/KIfYtDl4B2g/mqdefault.jpg", "duration": "3:07"},
        {"videoId": "7wtfhZwyrcc", "title": "Believer", "artist": "Imagine Dragons", "thumbnail": "https://img.youtube.com/vi/7wtfhZwyrcc/mqdefault.jpg", "duration": "3:24"},
        {"videoId": "mWRsgZuwf_8", "title": "Demons", "artist": "Imagine Dragons", "thumbnail": "https://img.youtube.com/vi/mWRsgZuwf_8/mqdefault.jpg", "duration": "2:57"},
        {"videoId": "uEDhGX-UTeI", "title": "Bad Liar", "artist": "Imagine Dragons", "thumbnail": "https://img.youtube.com/vi/uEDhGX-UTeI/mqdefault.jpg", "duration": "4:20"},
        {"videoId": "s7-GTShjcqY", "title": "Darkside", "artist": "NEONI", "thumbnail": "https://img.youtube.com/vi/s7-GTShjcqY/mqdefault.jpg", "duration": "3:15"},
        {"videoId": "T3E9Wjbq44E", "title": "Stereo Hearts", "artist": "Gym Class Heroes feat. Adam Levine", "thumbnail": "https://img.youtube.com/vi/T3E9Wjbq44E/mqdefault.jpg", "duration": "3:31"},
        {"videoId": "FyqjDe9e_hE", "title": "Sorry Not Sorry", "artist": "Demi Lovato", "thumbnail": "https://img.youtube.com/vi/FyqjDe9e_hE/mqdefault.jpg", "duration": "3:23"},
        {"videoId": "rW843YCHrh0", "title": "Drag Me Down", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/rW843YCHrh0/mqdefault.jpg", "duration": "3:12"},
        {"videoId": "Kr4EQDVETuA", "title": "Billie Jean", "artist": "Michael Jackson", "thumbnail": "https://img.youtube.com/vi/Kr4EQDVETuA/mqdefault.jpg", "duration": "4:54"},
        {"videoId": "DGfcVrU5XSY", "title": "Really Don't Care", "artist": "Demi Lovato feat. Cher Lloyd", "thumbnail": "https://img.youtube.com/vi/DGfcVrU5XSY/mqdefault.jpg", "duration": "3:21"}
    ]
  
}

@youtube_bp.route("/recommend-music", methods=["POST"])
def recommend_music():
    """POST /youtube/recommend-music"""
    body = request.get_json(silent=True)
    if not body or "emotion" not in body:
        return jsonify({"error": "Missing 'emotion' field in request body"}), 400
        
    input_emotion = str(body["emotion"]).strip().lower()
    uid = body.get("uid")
    
    full_pool = EMOTION_HARDCODED_MAP.get(input_emotion, EMOTION_HARDCODED_MAP["neutral"])
    
    if not full_pool:
        full_pool = EMOTION_HARDCODED_MAP["neutral"]
        
    if len(full_pool) > 20:
        selected_songs = random.sample(full_pool, 20)
    else:
        selected_songs = full_pool.copy()
        random.shuffle(selected_songs)
    
    if uid:
        try:
            notification_data = {
                "title": "Playlist Generated",
                "subtitle": f"Your new '{input_emotion.capitalize()}' playlist is ready with {len(selected_songs)} tracks.",
                "iconType": "music",
                "isNew": True,
                "timestamp": SERVER_TIMESTAMP
            }
            db.collection("users").document(uid).collection("notifications").add(notification_data)
            print(f"✅ Notification pushed to Firebase for user {uid}")
        except Exception as e:
            print(f"❌ Failed to send notification: {str(e)}")
        
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

@youtube_bp.route("/search", methods=["POST"])
def search_youtube():
    """POST /youtube/search"""
    body = request.get_json(silent=True)
    if not body or "query" not in body:
        return jsonify({"error": "Missing 'query' field"}), 400

    search_query = body["query"]
    api_key = os.getenv("YOUTUBE_API_KEY")
    
    if not api_key:
        return jsonify({"error": "Server API configuration missing"}), 500

    print(f"📡 User searching YouTube for: '{search_query}'")
    
    google_url = (
        f"https://www.googleapis.com/youtube/v3/search"
        f"?part=snippet"
        f"&q={search_query}"
        f"&type=video"
        f"&videoCategoryId=10" 
        f"&maxResults=15"
        f"&key={api_key}"
    )
    
    try:
        response = requests.get(google_url, timeout=8)
        data = response.json()
        
        if "items" not in data or not data["items"]:
            return jsonify([]), 200 
            
        search_results = []
        for item in data["items"]:
            if "videoId" not in item["id"]:
                continue
                
            video_id = item["id"]["videoId"]
            snippet = item["snippet"]
            
            search_results.append({
                "videoId": video_id,
                "title": snippet.get("title", "Unknown Title"),
                "artist": snippet.get("channelTitle", "Unknown Artist").replace(" - Topic", ""),
                "thumbnail": f"https://img.youtube.com/vi/{video_id}/mqdefault.jpg",
                "duration": "3:30"
            })
            
        return jsonify(search_results), 200
        
    except Exception as e:
        print(f"❌ YouTube Search Network Error: {str(e)}")
        return jsonify([]), 500