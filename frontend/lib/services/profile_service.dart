import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import '../utils/constant.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class ProfileService {
  final String baseUrl = Constant.baseUrl + '/profile';

  Future<String> updateProfile(User user, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Update failed";
      }
    } catch (e) {
      return "Connection error occurred: ${e.toString()}";
    }
  }

  Future<String> uploadProfilePhoto(File imageFile, String token) async {
    try {
      var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse('$baseUrl/profile/photo');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      var multipartFile = http.MultipartFile(
        'profilePhoto',
        stream,
        length,
        filename: path.basename(imageFile.path),
      );
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Failed to upload profile photo";
      }
    } catch (e) {
      return "Connection error occurred: ${e.toString()}";
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Connection error occurred: ${e.toString()}');
    }
  }
}