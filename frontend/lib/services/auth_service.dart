import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  final String baseUrl = 'http://localhost:5000/api/auth'; // Replace with your actual backend URL

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

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}