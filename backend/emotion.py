from deepface import DeepFace

def detect_emotion(image_path):
    try:
        result = DeepFace.analyze(
            img_path=image_path,
            actions=["emotion"],
            enforce_detection=False
        )
        face_confidence = result[0].get("face_confidence", 0)
        if face_confidence < 0.5:
            raise ValueError("No face detected in the image")
        dominant_emotion = result[0]["dominant_emotion"]
        emotion_confidence = float(result[0]["emotion"][dominant_emotion])
        return {
            "emotion": dominant_emotion,
            "confidence": round(emotion_confidence, 2)
        }
    except ValueError:
        raise
    except Exception as e:
        raise ValueError(str(e))