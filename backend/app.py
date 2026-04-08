from flask import Flask, jsonify, request
import os
from dotenv import load_dotenv
from emotion import detect_emotion

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY")

@app.route("/ping", methods=["GET"])
def ping():
    return jsonify({"status": "ok"}), 200

@app.route("/detect-emotion", methods=["POST"])
def detect_emotion_route():
    if "image" not in request.files:
        return jsonify({"error": "No image file attached"}), 400
    
    file = request.files["image"]
    
    if file.filename == "":
        return jsonify({"error": "No file selected"}), 400
    
    image_path = "temp_image.jpg"
    file.save(image_path)
    
    try:
        result = detect_emotion(image_path)
        return jsonify(result), 200
    except ValueError as e:
        error_msg = str(e)
        if "Face could not be detected" in error_msg:
            return jsonify({"error": "No face detected in the image"}), 400
        return jsonify({"error": error_msg}), 500
    finally:
        if os.path.exists(image_path):
            os.remove(image_path)

@app.errorhandler(400)
def bad_request(e):
    return jsonify({"error": "Bad request"}), 400

@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": "Route not found"}), 404

@app.errorhandler(500)
def server_error(e):
    return jsonify({"error": "Internal server error"}), 500

if __name__ == "__main__":
    app.run(debug=True)