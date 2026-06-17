import 'dart:io';
import 'package:dio/dio.dart';

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

  Future<List<dynamic>?> getMoodHistoryFromAzure(String uid) async {
    try {
      Response response = await _dio.get("$baseUrl/history/get/$uid");
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      print("Azure History retrieval failed: ${e.response?.data ?? e.message}");
    }
    return null;
  }
}
