import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthcareapp/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:healthcareapp/services/profile_service.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  final String baseUrl = Constant.baseUrl + '/auth';

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
  // In auth_service.dart
Future<String> updateProfile(User updatedUser) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'), // Fix the endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_currentUser?.token}'
      },
      body: json.encode(updatedUser.toJson()),
    );

    print('Update response: ${response.statusCode}, ${response.body}'); // Add logging

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Update the current user with the response data to ensure we have the server's version
      _currentUser = User.fromJson({
        'user': data['data'],
        'token': _currentUser?.token
      });
      notifyListeners();
      return "success";
    } else {
      final data = json.decode(response.body);
      return data['message'] ?? "Update failed";
    }
  } catch (e) {
    print('Update error: $e'); // Add error logging
    return "Connection error occurred: ${e.toString()}";
  }
}

//    final ProfileService _profileService = ProfileService();

// Future<String> updateProfile(User updatedUser) async {
//   try {
//     final result = await _profileService.updateProfile(updatedUser, _currentUser!.token);
//     if (result == "success") {
//       _currentUser = updatedUser;
//       notifyListeners();
//     }
//     return result;
//   } catch (e) {
//     return "Connection error occurred";
//   }
// }


  // Add method to add emergency contact
  Future<String> addEmergencyContact(String relation, String number) async {
  try {
    // Validate input before sending
    if (relation.isEmpty || number.isEmpty) {
      return "Relation and number are required";
    }

    // Prepare the request body
    final contactData = {
      'relation': relation.trim(),
      'number': number.trim(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/emergency-contacts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_currentUser?.token}'
      },
      body: json.encode(contactData),
    );

    print('Add contact request data: $contactData');
    print('Add contact response: ${response.statusCode}, ${response.body}');

    switch (response.statusCode) {
      case 201:
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Always refresh user data to ensure consistency
          final refreshResult = await refreshUserData();
          if (refreshResult == "success") {
            return "success";
          } else {
            return "Contact added but failed to refresh data";
          }
        }
        return data['message'] ?? "Failed to add contact";
        
      case 400:
        final data = json.decode(response.body);
        return data['message'] ?? "Invalid contact data";
        
      case 401:
        return "Unauthorized. Please log in again";
        
      case 500:
        final data = json.decode(response.body);
        print('Server error details: ${data['error']}');
        return "Server error. Please try again later";
        
      default:
        return "Unexpected error occurred";
    }
  } catch (e) {
    print('Add contact error: $e');
    if (e is FormatException) {
      return "Invalid response format from server";
    }
    return "Connection error: ${e.toString()}";
  }
}

// Helper method to validate contact data
bool isValidContact(String relation, String number) {
  if (relation.isEmpty || number.isEmpty) {
    return false;
  }
  // Add any additional validation rules here
  return true;
}

// Helper method to get existing contacts
List<EmergencyContact> getEmergencyContacts() {
  return _currentUser?.emergencyContacts ?? [];
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

    print('Refresh response: ${response.statusCode}, ${response.body}'); // Add logging

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _currentUser = User.fromJson({
        'user': data['data'],
        'token': _currentUser?.token
      });
      notifyListeners();
      return "success";
    } else {
      final data = json.decode(response.body);
      return data['message'] ?? "Failed to fetch user data";
    }
  } catch (e) {
    print('Refresh error: $e'); // Add error logging
    return "Connection error occurred";
  }
}

// In auth_service.dart

Future<String> uploadProfilePhoto(File imageFile) async {
  try {
    // Create multipart request
    var uri = Uri.parse('${Constant.baseUrl}/profile/photo');
    var request = http.MultipartRequest('POST', uri);
    
    // Add authorization header
    request.headers['Authorization'] = 'Bearer ${_currentUser?.token}';
    
    // Create MultipartFile
    var stream = await imageFile.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'profilePhoto',
      stream,
      filename: 'profile_photo.jpg',
      contentType: MediaType('image', 'jpeg'),
    );
    
    // Add file to request
    request.files.add(multipartFile);
    
    // Send request
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    
    if (response.statusCode == 200) {
      final data = json.decode(responseData);
      // Update current user with new profile photo
      _currentUser = User.fromJson({
        'user': data['data'],
        'token': _currentUser?.token,
      });
      notifyListeners();
      return "success";
    } else {
      final data = json.decode(responseData);
      return data['message'] ?? "Failed to upload profile photo";
    }
  } catch (e) {
    print('Profile photo upload error: $e');
    return "Connection error occurred: ${e.toString()}";
  }
}

  Future<String> refreshProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer ${_currentUser?.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentUser = User.fromJson({
          'user': data['data'],
          'token': _currentUser?.token,
        });
        notifyListeners();
        return "success";
      } else {
        final data = json.decode(response.body);
        return data['message'] ?? "Failed to refresh profile";
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