from deepface import DeepFace

def detect_emotion(image_path):
    try:
        result = DeepFace.analyze(
            img_path=image_path,
            actions=["emotion"],
            enforce_detection=False
        )

        analysis = result[0]

        face_confidence = analysis.get("face_confidence", 0)
        if face_confidence == 0:
            return{
                "success": False,
                "error":"No clear face detected"
            }
        
            
        dominant_emotion = analysis["dominant_emotion"]
        emotion_confidence = float(analysis["emotion"][dominant_emotion])

        return {
            "success": True,
            "emotion": dominant_emotion,
            "confidence": round(emotion_confidence, 2)
        }
    
    except Exception as e:
       return{
        "success": False,
        "error":str(e)
    }