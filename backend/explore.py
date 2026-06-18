import os
import random
import requests
from flask import Blueprint, jsonify, request

explore_bp = Blueprint("explore", __name__, url_prefix="/explore")

EXPLORE_STATIC_MAP = {
    "sinhala": [
        {"videoId": "heKksPAwfeE", "title": "Sansarini", "artist": "Yasas Medagedara", "thumbnail": "https://img.youtube.com/vi/heKksPAwfeE/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "-Bqdiuy5tTM", "title": "Meedum Dumaraye", "artist": "Kasun Kalhara", "thumbnail": "https://img.youtube.com/vi/-Bqdiuy5tTM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "oJYPppbnt1c", "title": "Ehem Beluwama Diha", "artist": "Yasas Medagedara", "thumbnail": "https://img.youtube.com/vi/oJYPppbnt1c/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "vsRQnDiIg2Y", "title": "Prathihari", "artist": "Supun Perera", "thumbnail": "https://img.youtube.com/vi/vsRQnDiIg2Y/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "iIm4gcybpsI", "title": "Kuweni", "artist": "Ridma Weerawardena", "thumbnail": "https://img.youtube.com/vi/iIm4gcybpsI/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "GAoVQbWRdyc", "title": "Kanda Gena", "artist": "Chanuka Mora", "thumbnail": "https://img.youtube.com/vi/GAoVQbWRdyc/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "Z42aFor5MiM", "title": "Thamarasa", "artist": "Dinesh Gamage", "thumbnail": "https://img.youtube.com/vi/Z42aFor5MiM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "6V62okYjrCc", "title": "Mandaram Kathawe", "artist": "Anushka Udana", "thumbnail": "https://img.youtube.com/vi/6V62okYjrCc/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "V5IZR7-MWko", "title": "Tharumal Kada Gannemi", "artist": "Sahan Chamikara", "thumbnail": "https://img.youtube.com/vi/V5IZR7-MWko/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "G-IS-scTJDo", "title": "Kohe Ho Ma", "artist": "Bhashi Devanga", "thumbnail": "https://img.youtube.com/vi/G-IS-scTJDo/mqdefault.jpg", "duration": "3:30"}
    ],
    "tamil": [
        {"videoId": "yKDWXC4o5nA", "title": "Pookkalae Sattru Oyivedungal", "artist": "A. R. Rahman ft. Haricharan & Shreya Ghoshal", "thumbnail": "https://img.youtube.com/vi/yKDWXC4o5nA/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "Wxqu1eVJ4Vs", "title": "Mersal Arasan", "artist": "A. R. Rahman ft. G.V. Prakash Kumar", "thumbnail": "https://img.youtube.com/vi/Wxqu1eVJ4Vs/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "s-1_HtGyth0", "title": "New York Nagaram", "artist": "A. R. Rahman", "thumbnail": "https://img.youtube.com/vi/s-1_HtGyth0/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "THhL-Y092pQ", "title": "Munbe Vaa", "artist": "A. R. Rahman ft. Naresh Iyer & Shreya Ghoshal", "thumbnail": "https://img.youtube.com/vi/THhL-Y092pQ/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "nWxGhq_lBII", "title": "Pookal Pookum Tharunam", "artist": "G. V. Prakash Kumar", "thumbnail": "https://img.youtube.com/vi/nWxGhq_lBII/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "fRD_3vJagxk", "title": "Vaathi Coming", "artist": "Anirudh Ravichander", "thumbnail": "https://img.youtube.com/vi/fRD_3vJagxk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "A_z5g0_hJN8", "title": "Donu Donu Donu", "artist": "Anirudh Ravichander ft. Alisha Thomas", "thumbnail": "https://img.youtube.com/vi/A_z5g0_hJN8/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "dsrku40uZMc", "title": "Vilambara Idaiweli", "artist": "Hiphop Tamizha", "thumbnail": "https://img.youtube.com/vi/dsrku40uZMc/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "067FqlIxEWA", "title": "Dheema Dheema", "artist": "Harris Jayaraj", "thumbnail": "https://img.youtube.com/vi/067FqlIxEWA/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "4Bsc2uI_LsM", "title": "Oorum Blood-um", "artist": "G. V. Prakash Kumar", "thumbnail": "https://img.youtube.com/vi/4Bsc2uI_LsM/mqdefault.jpg", "duration": "3:30"}
    ],
    "korean": [
        {"videoId": "bvJ_cNsCqE4", "title": "Dreaming", "artist": "NCT DREAM", "thumbnail": "https://img.youtube.com/vi/bvJ_cNsCqE4/mqdefault.jpg", "duration": "3:06"},
        {"videoId": "MA_B8RU9BsQ", "title": "Walk", "artist": "NCT 127", "thumbnail": "https://img.youtube.com/vi/MA_B8RU9BsQ/mqdefault.jpg", "duration": "3:29"},
        {"videoId": "-GQg25oP0S4", "title": "Super", "artist": "SEVENTEEN", "thumbnail": "https://img.youtube.com/vi/-GQg25oP0S4/mqdefault.jpg", "duration": "3:20"},
        {"videoId": "JsOOis4bBFg", "title": "S-Class", "artist": "Stray Kids", "thumbnail": "https://img.youtube.com/vi/JsOOis4bBFg/mqdefault.jpg", "duration": "3:16"},
        {"videoId": "3J7rt7bkDCY", "title": "Boy With Luv", "artist": "BTS", "thumbnail": "https://img.youtube.com/vi/3J7rt7bkDCY/mqdefault.jpg", "duration": "3:49"},
        {"videoId": "BL-aIpCLWnU", "title": "Black Mamba", "artist": "aespa", "thumbnail": "https://img.youtube.com/vi/BL-aIpCLWnU/mqdefault.jpg", "duration": "2:54"},
        {"videoId": "uR8Mrt1IpXg", "title": "Psycho", "artist": "Red Velvet", "thumbnail": "https://img.youtube.com/vi/uR8Mrt1IpXg/mqdefault.jpg", "duration": "3:31"},
        {"videoId": "UyEkTQ0OVXw", "title": "Replay", "artist": "SHINee", "thumbnail": "https://img.youtube.com/vi/UyEkTQ0OVXw/mqdefault.jpg", "duration": "3:35"},
        {"videoId": "fTc5tuEn6_U", "title": "Everytime", "artist": "CHEN x Punch", "thumbnail": "https://img.youtube.com/vi/fTc5tuEn6_U/mqdefault.jpg", "duration": "3:09"},
        {"videoId": "XAULcrSh80E", "title": "Gabriela", "artist": "KATSEYE", "thumbnail": "https://img.youtube.com/vi/XAULcrSh80E/mqdefault.jpg", "duration": "2:41"}
    ],
    "party songs": [
        {"videoId": "KT6t9R6pqkM", "title": "Where Is The Party", "artist": "Yuvan Shankar Raja", "thumbnail": "https://img.youtube.com/vi/KT6t9R6pqkM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "C5EsDsK8HLU", "title": "Madai Thiranthu", "artist": "Yogi B & Natchatra ft. Mista G", "thumbnail": "https://img.youtube.com/vi/C5EsDsK8HLU/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "sLGe9s9q-vY", "title": "Engeyum Eppothum", "artist": "G.V. Prakash Kumar", "thumbnail": "https://img.youtube.com/vi/sLGe9s9q-vY/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "VPW-0kboLck", "title": "Jalsa Song", "artist": "Yuvan Shankar Raja & Premgi Amaren", "thumbnail": "https://img.youtube.com/vi/VPW-0kboLck/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "WZfn3CjFSP0", "title": "Hey Vaada Vaada", "artist": "D. Imman", "thumbnail": "https://img.youtube.com/vi/WZfn3CjFSP0/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "CTmKrwFu7wg", "title": "Jalebi Baby", "artist": "Tesher x Jason Derulo", "thumbnail": "https://img.youtube.com/vi/CTmKrwFu7wg/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "kJQP7kiw5Fk", "title": "Despacito", "artist": "Luis Fonsi ft. Daddy Yankee", "thumbnail": "https://img.youtube.com/vi/kJQP7kiw5Fk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "TUVcZfQe-Kw", "title": "Levitating", "artist": "Dua Lipa ft. DaBaby", "thumbnail": "https://img.youtube.com/vi/TUVcZfQe-Kw/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "Wgw6tJ8yz9M", "title": "Honeypie", "artist": "JAWNY", "thumbnail": "https://img.youtube.com/vi/Wgw6tJ8yz9M/mqdefault.jpg", "duration": "3:30"}  
    ],
    "study music": [
        {"videoId": "7t3b651owlE", "title": "Itsumo Nandodemo", "artist": "Sojiro", "thumbnail": "https://img.youtube.com/vi/7t3b651owlE/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "ApXoWvfEYVU", "title": "Sunflower", "artist": "Post Malone & Swae Lee", "thumbnail": "https://img.youtube.com/vi/ApXoWvfEYVU/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "7maJOI3QMu0", "title": "River Flows in You", "artist": "Yiruma", "thumbnail": "https://img.youtube.com/vi/7maJOI3QMu0/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "K-a8s8OLBSE", "title": "cardigan", "artist": "Taylor Swift", "thumbnail": "https://img.youtube.com/vi/K-a8s8OLBSE/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "viimfQi_pUw", "title": "Ocean Eyes", "artist": "Billie Eilish", "thumbnail": "https://img.youtube.com/vi/viimfQi_pUw/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "HpphFd_mzXE", "title": "Photograph", "artist": "Ed Sheeran", "thumbnail": "https://img.youtube.com/vi/HpphFd_mzXE/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "EAuYkzbxxj0", "title": "Anchor", "artist": "Novo Amor", "thumbnail": "https://img.youtube.com/vi/EAuYkzbxxj0/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "b3LJlZBWI8w", "title": "Where's My Love (Acoustic)", "artist": "SYML", "thumbnail": "https://img.youtube.com/vi/b3LJlZBWI8w/mqdefault.jpg", "duration":"3:30"},
        {"videoId": "0cKV8_MKsMw", "title": "Blessings", "artist": "Hollow Coves", "thumbnail": "https://img.youtube.com/vi/0cKV8_MKsMw/mqdefault.jpg", "duration":"3:30"},
        {"videoId": "dzNvk80XY9s", "title": "Saturn", "artist": "Sleeping At Last", "thumbnail": "https://img.youtube.com/vi/dzNvk80XY9s/mqdefault.jpg", "duration": "3:30"}
    ],
    "techno vibes": [
        {"videoId": "mNrzmpA8JU4", "title": "Pushy", "artist": "ToKomoTai", "thumbnail": "https://img.youtube.com/vi/mNrzmpA8JU4/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "5GYeWpjq54Y", "title": "DNA (Loving You)", "artist": "Billy Gillies ft. Hannah Boleyn", "thumbnail": "https://img.youtube.com/vi/5GYeWpjq54Y/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "3wIxK8uSPV0", "title": "Set Fire To The Rain (Sebastian Busto Remix)", "artist": "Adele", "thumbnail": "https://img.youtube.com/vi/3wIxK8uSPV0/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "gSp-qfVBqKs", "title": "A Sky Full Of Stars (Jean Philippe Afro House Remix)", "artist": "Coldplay", "thumbnail": "https://img.youtube.com/vi/gSp-qfVBqKs/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "6dhdKDQgPSg", "title": "Jamaican (Bam Bam) (Sammy Flash Afro House Remix)", "artist": "HUGEL x SOLTO", "thumbnail": "https://img.youtube.com/vi/6dhdKDQgPSg/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "Tzlsno9c2PE", "title": "Yamore x Move x I Adore You (Mashup)", "artist": "DJ Sianna", "thumbnail": "https://img.youtube.com/vi/Tzlsno9c2PE/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "7z67WjLY5ro", "title": "Summertime Sadness (Zeno Altea Afro House Remix)", "artist": "Lana Del Rey", "thumbnail": "https://img.youtube.com/vi/7z67WjLY5ro/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "oepqVxKLzAs", "title": "Sweater Weather (Dave (LB) Afro House Remix)", "artist": "The Neighbourhood", "thumbnail": "https://img.youtube.com/vi/oepqVxKLzAs/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "4XMX2XBSQuo", "title": "Somebody That I Used To Know (Heliograph x Palau Afro House Remix)", "artist": "Gotye", "thumbnail": "https://img.youtube.com/vi/4XMX2XBSQuo/mqdefault.jpg", "duration": "3:30"}
        
    ],
    "romance": [
        {"videoId": "CNGjD0VG4R8", "title": "Perfect", "artist": "Ed Sheeran", "thumbnail": "https://img.youtube.com/vi/CNGjD0VG4R8/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "CxcEqhy4yKg", "title": "Love Story", "artist": "Taylor Swift", "thumbnail": "https://img.youtube.com/vi/CxcEqhy4yKg/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "Mw5mAozjC6M", "title": "Strawberries & Cigarettes", "artist": "Troye Sivan", "thumbnail": "https://img.youtube.com/vi/Mw5mAozjC6M/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "C3DlM19x4RQ", "title": "8 Letters", "artist": "Why Don't We", "thumbnail": "https://img.youtube.com/vi/C3DlM19x4RQ/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "nyuo9-OjNNg", "title": "I Wanna Be Yours", "artist": "Arctic Monkeys", "thumbnail": "https://img.youtube.com/vi/nyuo9-OjNNg/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "W8a4sUabCUo", "title": "Dandelions", "artist": "Ruth B.", "thumbnail": "https://img.youtube.com/vi/W8a4sUabCUo/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "YQ-qToZUybM", "title": "Die For You", "artist": "The Weeknd & Ariana Grande", "thumbnail": "https://img.youtube.com/vi/YQ-qToZUybM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "sXJ2hajo6rw", "title": "goodnight n go", "artist": "Ariana Grande", "thumbnail": "https://img.youtube.com/vi/sXJ2hajo6rw/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "unTus4ukPB0", "title": "They Don't Know About Us", "artist": "One Direction", "thumbnail": "https://img.youtube.com/vi/unTus4ukPB0/mqdefault.jpg", "duration": "3:30"}
    ],
    "classical": [
        {"videoId": "nqAvFx3NxUM", "title": "Clair de Lune", "artist": "Claude Debussy", "thumbnail": "https://img.youtube.com/vi/nqAvFx3NxUM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "bAqz0AwLRjk", "title": "Gymnopédie No. 1", "artist": "Erik Satie", "thumbnail": "https://img.youtube.com/vi/bAqz0AwLRjk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "izGwDsrQ1eQ", "title": "Nocturne Op. 9 No. 2", "artist": "Frédéric Chopin", "thumbnail": "https://img.youtube.com/vi/izGwDsrQ1eQ/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "3JWTaaS7LdU", "title": "River Flows in You", "artist": "Yiruma", "thumbnail": "https://img.youtube.com/vi/3JWTaaS7LdU/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "S_E2EHVxNAE", "title": "Für Elise", "artist": "Ludwig van Beethoven", "thumbnail": "https://img.youtube.com/vi/S_E2EHVxNAE/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "lp-EO5I60KA", "title": "Thinking Out Loud (Classical Piano Version)", "artist": "Ed Sheeran", "thumbnail": "https://img.youtube.com/vi/lp-EO5I60KA/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "EUrUfJW1JGk", "title": "Prelude in C Major", "artist": "Johann Sebastian Bach", "thumbnail": "https://img.youtube.com/vi/EUrUfJW1JGk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "vIGHaRE4dhk", "title": "Canon in D", "artist": "Johann Pachelbel", "thumbnail": "https://img.youtube.com/vi/vIGHaRE4dhk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "UNTPbsV7B4M", "title": "Moonlight Sonata (1st Movement)", "artist": "Ludwig van Beethoven", "thumbnail": "https://img.youtube.com/vi/UNTPbsV7B4M/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "HyTpu6BmE88", "title": "Experience", "artist": "Ludivico Einaudi", "thumbnail": "https://img.youtube.com/vi/HyTpu6BmE88/mqdefault.jpg", "duration": "3:30"}
    ],
    "hip pop": [
        {"videoId": "_CL6n0FJZpk", "title": "Still D.R.E.", "artist": "Dr. Dre ft. Snoop Dogg", "thumbnail": "https://img.youtube.com/vi/_CL6n0FJZpk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "YVkUvmDQ3HY", "title": "Without Me", "artist": "Eminem", "thumbnail": "https://img.youtube.com/vi/YVkUvmDQ3HY/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "j5-yKhDd64s", "title": "Not Afraid", "artist": "Eminem", "thumbnail": "https://img.youtube.com/vi/j5-yKhDd64s/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "SRcnnId15BA", "title": "Candy Shop", "artist": "50 Cent ft. Olivia", "thumbnail": "https://img.youtube.com/vi/SRcnnId15BA/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "5qm8PH4xAss", "title": "In Da Club", "artist": "50 Cent", "thumbnail": "https://img.youtube.com/vi/5qm8PH4xAss/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "KV2ssT8lzj8", "title": "No Love", "artist": "Eminem ft. Lil Wayne", "thumbnail": "https://img.youtube.com/vi/KV2ssT8lzj8/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "D4hAVemuQXY", "title": "Sing For The Moment", "artist": "Eminem", "thumbnail": "https://img.youtube.com/vi/D4hAVemuQXY/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "ixkoVwKQaJg", "title": "Taki Taki", "artist": "DJ Snake ft. Selena Gomez, Ozuna & Cardi B", "thumbnail": "https://img.youtube.com/vi/ixkoVwKQaJg/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "cDMhlvbOFaM", "title": "21 Questions", "artist": "50 Cent ft. Nate Dogg", "thumbnail": "https://img.youtube.com/vi/cDMhlvbOFaM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "rSOzN0eihsE", "title": "Beautiful", "artist": "Eminem", "thumbnail": "https://img.youtube.com/vi/rSOzN0eihsE/mqdefault.jpg", "duration": "3:30"}
    ],
    "jazz": [
        {"videoId": "4TYv2PhG89A", "title": "Smooth Operator", "artist": "Sade", "thumbnail": "https://img.youtube.com/vi/4TYv2PhG89A/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "ypbjIwbTR8c", "title": "Lily Was Here", "artist": "David A. Stewart ft. Candy Dulfer", "thumbnail": "https://img.youtube.com/vi/ypbjIwbTR8c/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "lSD_L-xic9o", "title": "What A Wonderful World", "artist": "Louis Armstrong", "thumbnail": "https://img.youtube.com/vi/lSD_L-xic9o/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "tO4dxvguQDk", "title": "Take Five", "artist": "The Dave Brubeck Quartet", "thumbnail": "https://img.youtube.com/vi/tO4dxvguQDk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "LAjfB0XfjkA", "title": "Feeling Good", "artist": "Nina Simone", "thumbnail": "https://img.youtube.com/vi/LAjfB0XfjkA/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "oHRNrgDIJfo", "title": "Cry Me A River", "artist": "Julie London", "thumbnail": "https://img.youtube.com/vi/oHRNrgDIJfo/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "a90tZJHBklk", "title": "Fly Me To The Moon", "artist": "Frank Sinatra", "thumbnail": "https://img.youtube.com/vi/a90tZJHBklk/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "ZEcqHA7dbwM", "title": "My Funny Valentine", "artist": "Chet Baker", "thumbnail": "https://img.youtube.com/vi/ZEcqHA7dbwM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "UZWmtxLiiFE", "title": "Blue In Green", "artist": "Miles Davis", "thumbnail": "https://img.youtube.com/vi/UZWmtxLiiFE/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "DutDD-IK2J4", "title": "Strange Fruit", "artist": "Billie Holiday", "thumbnail": "https://img.youtube.com/vi/DutDD-IK2J4/mqdefault.jpg", "duration": "3:30"}
    ],
    
    "motivational": [
        {"videoId": "ds6o9in_y-o", "title": "Rise", "artist": "League of Legends ft. The Glitch Mob, Mako & Word Alive", "thumbnail": "https://img.youtube.com/vi/ds6o9in_y-o/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "cxjvTXo9WWM", "title": "Unstoppable", "artist": "Sia", "thumbnail": "https://img.youtube.com/vi/cxjvTXo9WWM/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "r6zIGXun57U", "title": "Legends Never Die", "artist": "League of Legends ft. Against The Current", "thumbnail": "https://img.youtube.com/vi/r6zIGXun57U/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "BKVIyxQfrJc", "title": "Believer", "artist": "Imagine Dragons ft. Lil Wayne", "thumbnail": "https://img.youtube.com/vi/BKVIyxQfrJc/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "CYDP_8UTAus", "title": "Fight Back", "artist": "NEFFEX", "thumbnail": "https://img.youtube.com/vi/CYDP_8UTAus/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "xo1VInw-SKc", "title": "Fight Song", "artist": "Rachel Platten", "thumbnail": "https://img.youtube.com/vi/xo1VInw-SKc/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "Ln3StjqU-Fs", "title": "Rise Up", "artist": "TheFatRat", "thumbnail": "https://img.youtube.com/vi/Ln3StjqU-Fs/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "gOsM-DYAEhY", "title": "Whatever It Takes", "artist": "Imagine Dragons", "thumbnail": "https://img.youtube.com/vi/gOsM-DYAEhY/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "YbWkR6mFI6s", "title": "The Greatest", "artist": "Sia", "thumbnail": "https://img.youtube.com/vi/YbWkR6mFI6s/mqdefault.jpg", "duration": "3:30"},
        {"videoId": "_Z5-P9v3F8w", "title": "Never Say Never", "artist": "Justin Bieber ft. Jaden Smith", "thumbnail": "https://img.youtube.com/vi/_Z5-P9v3F8w/mqdefault.jpg", "duration": "3:30"}
    ],
}

@explore_bp.route("/vibe-genre", methods=["GET"])
def get_vibe_genre():
    """
    GET /explore/vibe-genre?query=jazz
    Handles all UI tile component actions cleanly without junk data or quota crashes.
    """
    query_input = request.args.get("query", "").strip().lower()
    
    if not query_input:
        return jsonify({"error": "Missing 'query' parameter"}), 400


    if query_input in EXPLORE_STATIC_MAP:
        print(f"🎯 Local storage pool hit for category tile: '{query_input}'. Serving instant data.")
        return jsonify(EXPLORE_STATIC_MAP[query_input]), 200

    api_key = os.getenv("YOUTUBE_API_KEY")
    if not api_key:
        return jsonify({"error": "Server API key configuration missing"}), 500

    print(f"📡 Requesting official live Google servers for custom query search input: '{query_input}'")
    
    google_url = (
        f"https://www.googleapis.com/youtube/v3/search"
        f"?part=snippet"
        f"&q={query_input}+music"
        f"&type=video"
        f"&videoCategoryId=10"
        f"&maxResults=25"
        f"&key={api_key}"
    )

    try:
        response = requests.get(google_url, timeout=8)
        data = response.json()

        if "items" not in data or not data["items"]:
            return jsonify(EXPLORE_STATIC_MAP["sinhala"]), 200

        recommended_songs = []
        for item in data["items"]:
            if "id" not in item or "videoId" not in item["id"]:
                continue

            video_id = item["id"]["videoId"]
            snippet = item["snippet"]
            title = snippet.get("title", "Unknown Title")
            
            lower_title = title.lower()
            if "live" in lower_title or "loop" in lower_title or "hours" in lower_title or "compilation" in lower_title:
                continue

            recommended_songs.append({
                "videoId": video_id,
                "title": title,
                "artist": snippet.get("channelTitle", "Unknown Artist").replace(" - Topic", ""),
                "thumbnail": f"https://img.youtube.com/vi/{video_id}/mqdefault.jpg",
                "duration": "3:30"
            })


        if len(recommended_songs) < 10:
            from youtube import EMOTION_HARDCODED_MAP
            backup_pool = EMOTION_HARDCODED_MAP.get("neutral", [])
            for backup_track in backup_pool:
                if len(recommended_songs) >= 10:
                    break
                if backup_track["videoId"] not in [s["videoId"] for s in recommended_songs]:
                    recommended_songs.append(backup_track)

        return jsonify(recommended_songs[:10]), 200    

    except Exception as e:
        print(f"❌ Explore System Exception Error: {str(e)}")
        return jsonify(EXPLORE_STATIC_MAP["sinhala"]), 200