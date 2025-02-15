import 'package:flutter/material.dart';
import 'package:healthcareapp/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';


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

  // Add method to update user profile
  Future<String> updateProfile(User updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_currentUser?.token}'
        },
        body: json.encode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        // Keep the token when updating the user
        _currentUser = updatedUser.copyWith();
        notifyListeners();
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Update failed";
      }
    } catch (e) {
      return "Connection error occurred";
    }
  }

  // Add method to add emergency contact
  Future<String> addEmergencyContact(String relation, String number) async {
    try {
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
        final data = json.decode(response.body);
        final newContact = EmergencyContact.fromJson(data);
        final updatedContacts = [..._currentUser!.emergencyContacts, newContact];
        _currentUser = _currentUser!.copyWith(emergencyContacts: updatedContacts);
        notifyListeners();
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Failed to add contact";
      }
    } catch (e) {
      return "Connection error occurred";
    }
  }

  // Add method to delete emergency contact
  Future<String> deleteEmergencyContact(String contactId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/emergency-contacts/$contactId'),
        headers: {
          'Authorization': 'Bearer ${_currentUser?.token}'
        },
      );

      if (response.statusCode == 200) {
        final updatedContacts = _currentUser!.emergencyContacts
            .where((contact) => contact.id != contactId)
            .toList();
        _currentUser = _currentUser!.copyWith(emergencyContacts: updatedContacts);
        notifyListeners();
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Failed to delete contact";
      }
    } catch (e) {
      return "Connection error occurred";
    }
  }

  Future<String> refreshUserData() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer ${_currentUser?.token}'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Keep the existing token when updating the user data
      final updatedUser = User.fromJson({'user': data, 'token': _currentUser?.token});
      _currentUser = updatedUser;
      notifyListeners();
      return "success";
    } else {
      final data = json.decode(response.body);
      return data['message'] ?? "Failed to fetch user data";
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