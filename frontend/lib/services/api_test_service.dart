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
      final userType = prefs.getString('user_type') ?? '';

      if (token.isEmpty) {
        return {
          'success': false,
          'message': 'No auth token found',
          'token': 'EMPTY',
          'userType': userType,
        };
      }

      // Check if token looks like a JWT (has 3 parts separated by dots)
      final tokenParts = token.split('.');
      if (tokenParts.length != 3) {
        return {
          'success': false,
          'message': 'Invalid token format - not a JWT',
          'token': token.length > 50 ? '${token.substring(0, 50)}...' : token,
          'userType': userType,
          'tokenParts': tokenParts.length,
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
        'message': response.statusCode == 200 ? 'Auth valid' : 'Auth invalid',
        'token': token.length > 50 ? '${token.substring(0, 50)}...' : token,
        'userType': userType,
        'tokenParts': tokenParts.length,
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
        Uri.parse('${AppConfig.baseUrl}/service/business/all'),
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
        Uri.parse('${AppConfig.baseUrl}/service'),
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

  // Clear stored authentication data
  static Future<Map<String, dynamic>> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_type');

      return {
        'success': true,
        'message': 'Authentication data cleared successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to clear auth data'
      };
    }
  }

  // Get stored authentication info
  static Future<Map<String, dynamic>> getAuthInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final userType = prefs.getString('user_type') ?? '';

      return {
        'success': true,
        'hasToken': token.isNotEmpty,
        'tokenLength': token.length,
        'tokenPreview': token.length > 50 ? '${token.substring(0, 50)}...' : token,
        'userType': userType,
        'isValidJWT': token.split('.').length == 3,
        'message': 'Auth info retrieved'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to get auth info'
      };
    }
  }
}
