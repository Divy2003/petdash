import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utlis/app_config/app_config.dart';

class AppointmentService {
  static const String baseUrl = AppConfig.baseUrl;

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET /appointment/business
  static Future<List<dynamic>> getBusinessAppointments() async {
    final headers = await _getHeaders();
    final res = await http.get(Uri.parse('$baseUrl/appointment/business'), headers: headers);

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      // Backend returns { appointments: [...] }
      return decoded['appointments'] ?? [];
    }
    throw Exception('Failed to fetch business appointments (${res.statusCode})');
  }

  // GET /appointment/customer
  static Future<List<dynamic>> getCustomerAppointments() async {
    final headers = await _getHeaders();
    final res = await http.get(Uri.parse('$baseUrl/appointment/customer'), headers: headers);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded['appointments'] ?? [];
    }
    throw Exception('Failed to fetch customer appointments (${res.statusCode})');
  }

  // GET /appointment/:id
  static Future<Map<String, dynamic>> getAppointmentDetails(String appointmentId) async {
    final headers = await _getHeaders();
    final res = await http.get(Uri.parse('$baseUrl/appointment/$appointmentId'), headers: headers);

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      return decoded;
    }
    throw Exception('Failed to fetch appointment details (${res.statusCode})');
  }

  // PUT /appointment/:id/status  body: { status }
  static Future<bool> updateAppointmentStatus({
    required String appointmentId,
    required String status, // 'upcoming' | 'completed' | 'cancelled'
  }) async {
    final headers = await _getHeaders();
    final res = await http.put(
      Uri.parse('$baseUrl/appointment/$appointmentId/status'),
      headers: headers,
      body: jsonEncode({'status': status}),
    );

    return res.statusCode == 200;
  }
}

