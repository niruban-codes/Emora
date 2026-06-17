import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  // Localhost connection string for testing on your computer.
  // Note: If you are running on an Android Emulator, change "127.0.0.1" to "10.0.2.2"
  final String baseUrl =
      "https://emora-api-backend-ggccceepbsa2f4dk.eastasia-01.azurewebsites.net";

  // 1. AI EMOTION DETECTION (Camera Screen Bridge)
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
        return response.data as Map<String, dynamic>; // Returns facial analysis results dict
      }
    } on DioException catch (e) {
      print("AI Detection Server Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  // 2. GET USER PLAYLISTS (Library UI Bridge)
  Future<List<dynamic>?> getUserLibrary(String uid) async {
    try {
      Response response = await _dio.get("$baseUrl/library/$uid");
      if (response.statusCode == 200) {
        return response.data; // Returns array of saved user playlists
      }
    } on DioException catch (e) {
      print("Library Fetch Error: ${e.response?.data ?? e.message}");
    }
    return null;
  }

  // 3. SAVE PLAYLIST (Firestore Sync Bridge)
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

  // 4. DELETE PLAYLIST (Library Maintenance Bridge)
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


// 5. SAVE MOOD DETECTION HISTORY (Azure DB Sync Bridge)
  Future<bool> saveMoodHistoryToAzure({
    required String uid,
    required String emotion,
    required List<dynamic> tracks,
  }) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/history/add",
        data: {
          "uid": uid,
          "emotion": emotion,
          "timestamp": DateTime.now().toUtc().toIso8601String(),
          "tracks": tracks,
        },
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } on DioException catch (e) {
      print("Azure History sync failed: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  // 6. FETCH MOOD DETECTION HISTORY (For building your History list view)
  Future<List<dynamic>?> getMoodHistoryFromAzure(String uid) async {
    try {
      Response response = await _dio.get("$baseUrl/history/get/$uid");
      if (response.statusCode == 200) {
        return response.data; // Returns list of past history objects from Azure
      }
    } on DioException catch (e) {
      print("Azure History retrieval failed: ${e.response?.data ?? e.message}");
    }
    return null;
  }

}
