import 'dart:io';

class ApiService {
  final String baseUrl = 'https://your-flask-api.com/api';

  // Stub for Flask Emotion Detection
  Future<String> detectEmotion(File imageFile) async {
    // TODO: Replace with actual MultipartRequest to Flask backend
    await Future.delayed(const Duration(seconds: 2)); // Simulate network
    return "Happy"; // Simulated response
  }

  // Stub for getting Spotify recommendations based on mood
  Future<List<dynamic>> getRecommendations(String mood) async {
    // TODO: Fetch from Flask backend which calls Spotify API
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}
