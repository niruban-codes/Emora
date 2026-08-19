import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl =
      "https://emora-api-backend-ggccceepbsa2f4dk.eastasia-01.azurewebsites.net";

  Future<Map<String, dynamic>?> detectEmotion(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      Response response = await _dio.post(
        "$baseUrl/detect-emotion",
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } on DioException catch (e) {
      print("AI Detection Server Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Future<List<dynamic>?> getUserLibrary(String uid) async {
    try {
      Response response = await _dio.get("$baseUrl/library/$uid");
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      print("Library Fetch Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Future<bool> savePlaylistToLibrary(
    String uid,
    String name,
    String emotion,
    List<Map<String, dynamic>> tracks,
  ) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/library/$uid/add",
        data: {"name": name, "emotion": emotion, "tracks": tracks},
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      print("Save Playlist Error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<bool> deletePlaylistFromLibrary(String uid, String playlistId) async {
    try {
      Response response = await _dio.delete(
        "$baseUrl/library/$uid/remove",
        data: {"id": playlistId},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print("Delete Playlist Error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<bool> saveMoodHistoryToAzure({
    required String uid,
    required String emotion,
    required List<dynamic> tracks,
    double confidence = 95.0,
  }) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/history/$uid",
        data: {"emotion": emotion, "confidence": confidence, "tracks": tracks},
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      print("Azure History sync failed: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<List<dynamic>?> getMoodHistoryFromAzure(String uid) async {
    try {
      Response response = await _dio.get("$baseUrl/history/$uid");
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      print("Azure History retrieval failed: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  // Fetch calculation metrics for the analytics dashboard
  Future<Map<String, dynamic>?> getMoodAnalyticsFromAzure(String uid) async {
    try {
      Response response = await _dio.get("$baseUrl/history/$uid/analytics");
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } on DioException catch (e) {
      print(
        " Azure Analytics bridge failure: ${e.response?.data ?? e.message}",
      );
    }
    return null;
  }

  Future<List<dynamic>?> searchYouTube(String query) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/youtube/search",
        data: {"query": query},
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      print("Search Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Options get _adminOptions {
    final currentEmail =
        FirebaseAuth.instance.currentUser?.email ??
        'geethmapiyaratne285@gmail.com';
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'X-Admin-Email': currentEmail,
      },
    );
  }

  Future<Map<String, dynamic>?> getAdminStats() async {
    try {
      final response = await _dio.get(
        "$baseUrl/admin/stats",
        options: _adminOptions,
      );
      if (response.statusCode == 200)
        return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print("Admin Stats Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Future<List<dynamic>?> getAdminUsers() async {
    try {
      final response = await _dio.get(
        "$baseUrl/admin/users",
        options: _adminOptions,
      );
      if (response.statusCode == 200) return response.data as List<dynamic>;
    } on DioException catch (e) {
      print("Admin Users Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAdminEmotionStats() async {
    try {
      final response = await _dio.get(
        "$baseUrl/admin/emotion-stats",
        options: _adminOptions,
      );
      if (response.statusCode == 200)
        return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print("Admin Emotion Stats Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAdminMusicStats() async {
    try {
      final response = await _dio.get(
        "$baseUrl/admin/music-stats",
        options: _adminOptions,
      );
      if (response.statusCode == 200)
        return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print("Admin Music Stats Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Future<List<dynamic>?> getAdminLogs() async {
    try {
      final response = await _dio.get(
        "$baseUrl/admin/logs",
        options: _adminOptions,
      );
      if (response.statusCode == 200) return response.data as List<dynamic>;
    } on DioException catch (e) {
      print("Admin Logs Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  Future<bool> createAdminLog(String action) async {
    try {
      final response = await _dio.post(
        "$baseUrl/admin/logs",
        data: {"action": action},
        options: _adminOptions,
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print("Create Log Error: ${e.response?.data ?? e.message}");
      return false;
    }
  }
}
