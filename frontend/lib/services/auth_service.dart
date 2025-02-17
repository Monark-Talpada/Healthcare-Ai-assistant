import 'package:flutter/material.dart';
import 'package:healthcareapp/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import 'dart:io';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  final String baseUrl = Constant.baseUrl+'auth';

  Future<String> signup(String name, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        _currentUser = User.fromJson(data);
        notifyListeners();
        return "success";
      } else {
        return data['message'] ?? "Signup failed";
      }
    } catch (e) {
      return "Connection error occurred";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        _currentUser = User.fromJson(data);
        notifyListeners();
        return "success";
      } else {
        return data['message'] ?? "Login failed";
      }
    } catch (e) {
      return "Connection error occurred";
    }
  }

Future<String> updateProfile({
    String? name,
    String? phone,
    String? gender,
    int? age,
    String? bloodType,
    double? weight,
    List<Map<String, String>>? emergencyContacts,
  }) async {
    try {
      if (_currentUser?.token == null) {
        return "No authentication token found";
      }
      final url='$baseUrl/profile';
      print('$url');
      
      Map<String, dynamic> updateData = {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (age != null) 'age': age,
        if (bloodType != null) 'bloodType': bloodType,
        if (weight != null) 'weight': weight,
        if (emergencyContacts != null) 'emergencyContacts': emergencyContacts,
      };

      print('Sending update request with data: $updateData'); // Debug print

      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_currentUser?.token}'
        },
        body: json.encode(updateData),
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Update current user with new data while preserving the token
          _currentUser = User.fromJson({
            ...data['data'],
            'token': _currentUser?.token,
          });
          
          notifyListeners();
          return "success";
        } else {
          return data['message'] ?? "Update failed";
        }
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Update failed with status ${response.statusCode}";
      }
    } catch (e) {
      print('Error updating profile: $e'); // Debug print
      if (e is SocketException) {
        return "Connection error: Please check your internet connection";
      }
      return "An unexpected error occurred: ${e.toString()}";
    }
  }

  Future<String> refreshUserData() async {
    try {
      if (_currentUser?.token == null) {
        return "No authentication token found";
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer ${_currentUser?.token}'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = User.fromJson({
          ...data,
          'token': _currentUser?.token,
        });
        notifyListeners();
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Failed to fetch user data";
      }
    } catch (e) {
      print('Error refreshing user data: $e');
      return "Connection error occurred";
    }
  }

  Future<String> addEmergencyContact(String relation, String number) async {
    try {
      if (_currentUser?.token == null) {
        return "No authentication token found";
      }

      final response = await http.post(
        Uri.parse('$baseUrl/emergency-contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_currentUser?.token}'
        },
        body: json.encode({
          'relation': relation,
          'number': number,
        }),
      );

      if (response.statusCode == 201) {
        await refreshUserData();
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Failed to add contact";
      }
    } catch (e) {
      return "Connection error occurred";
    }
  }

  Future<String> deleteEmergencyContact(String contactId) async {
    try {
      if (_currentUser?.token == null) {
        return "No authentication token found";
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/emergency-contacts/$contactId'),
        headers: {
          'Authorization': 'Bearer ${_currentUser?.token}'
        },
      );

      if (response.statusCode == 200) {
        await refreshUserData();
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Failed to delete contact";
      }
    } catch (e) {
      return "Connection error occurred";
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}