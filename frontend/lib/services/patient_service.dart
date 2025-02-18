// lib/services/patient_service.dart
import 'dart:convert';
import 'package:healthcareapp/utils/constant.dart';
import 'package:http/http.dart' as http;
import '../models/patient_model.dart';

class PatientService {
  final String baseUrl = Constant.baseUrl + '/patients';

  Future<Map<String, dynamic>> createPatient(Map<String, dynamic> patientData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(patientData)
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      }
      throw Exception('Failed to create patient: ${response.body}');
    } catch (e) {
      throw Exception('Error creating patient: $e');
    }
  }

  Future<Map<String, dynamic>> getPatient(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to get patient: ${response.body}');
    } catch (e) {
      throw Exception('Error getting patient: $e');
    }
  }

  Future<Map<String, dynamic>> updatePatient(String id, Map<String, dynamic> patientData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(patientData)
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to update patient: ${response.body}');
    } catch (e) {
      throw Exception('Error updating patient: $e');
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete patient: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting patient: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllPatients() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to get patients: ${response.body}');
    } catch (e) {
      throw Exception('Error getting patients: $e');
    }
  }
 }