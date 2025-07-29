import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utlis/app_config/app_config.dart';

class ApiTestService {
  // Test basic connectivity to the server
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      return {
        'success': true,
        'statusCode': response.statusCode,
        'body': response.body,
        'message': 'Connection successful'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Connection failed'
      };
    }
  }

  // Test authentication
  static Future<Map<String, dynamic>> testAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        return {
          'success': false,
          'message': 'No auth token found'
        };
      }

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/auth/verify'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'body': response.body,
        'message': response.statusCode == 200 ? 'Auth valid' : 'Auth invalid'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Auth test failed'
      };
    }
  }

  // Test services endpoint
  static Future<Map<String, dynamic>> testServicesEndpoint() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/business/services'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'body': response.body.length > 500 ? '${response.body.substring(0, 500)}...' : response.body,
        'message': 'Services endpoint test complete'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Services endpoint test failed'
      };
    }
  }

  // Test alternative services endpoint
  static Future<Map<String, dynamic>> testAlternativeServicesEndpoint() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/services'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      return {
        'success': response.statusCode == 200,
        'statusCode': response.statusCode,
        'body': response.body.length > 500 ? '${response.body.substring(0, 500)}...' : response.body,
        'message': 'Alternative services endpoint test complete'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Alternative services endpoint test failed'
      };
    }
  }
}
