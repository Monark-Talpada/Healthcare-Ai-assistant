import 'dart:convert';
import 'package:healthcareapp/utils/constant.dart';
import 'package:http/http.dart' as http;
import '../models/medicine.dart';

class MedicineService {
  static const String baseUrl = Constant.baseUrl + '/medicines';
  final String? authToken;

  MedicineService({this.authToken});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  Future<List<Medicine>> getMedicines() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Medicine.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medicines');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Medicine> addMedicine(Medicine medicine) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _headers,
        body: json.encode(medicine.toJson()),
      );
      if (response.statusCode == 201) {
        return Medicine.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add medicine');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: _headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete medicine');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Medicine> takeDose(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$id/take-dose'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return Medicine.fromJson(json.decode(response.body)['medicine']);
      } else {
        throw Exception('Failed to take dose');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}