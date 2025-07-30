import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utlis/app_config/app_config.dart';

class ApiService {
  static final String baseUrl = AppConfig.baseUrl;

  // Get headers with optional authentication
  static Future<Map<String, String>> _getHeaders(
      {bool requireAuth = false}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (requireAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requireAuth = false,
    Map<String, String>? queryParams,
  }) async {
    try {
      String url = '$baseUrl$endpoint';

      if (queryParams != null && queryParams.isNotEmpty) {
        final uri = Uri.parse(url);
        final newUri = uri.replace(queryParameters: queryParams);
        url = newUri.toString();
      }

      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.get(Uri.parse(url), headers: headers);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool requireAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Generic PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool requireAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Generic DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requireAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      throw ApiException(
        responseBody['message'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}
