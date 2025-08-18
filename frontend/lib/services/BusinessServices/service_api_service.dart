import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/service_model.dart';
import '../../utlis/app_config/app_config.dart';

class ServiceApiService {
  // Get headers with token
  static Future<Map<String, String>> _getMultipartHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Authorization': 'Bearer $token',
    };
  }

  // Create a new service
  static Future<ServiceModel> createService(
      ServiceRequest serviceRequest, {
        List<File>? imageFiles,
      }) async {

    // If no images, use the no-images endpoint to avoid multipart issues
    if (imageFiles == null || imageFiles.isEmpty) {
      final uri = Uri.parse('${AppConfig.baseUrl}/service/create-no-images');
      return _sendJsonServiceRequest(
        uri: uri,
        method: 'POST',
        serviceRequest: serviceRequest,
      );
    } else {
      final uri = Uri.parse('${AppConfig.baseUrl}/service/create');
      return _sendMultipartServiceRequest(
        uri: uri,
        method: 'POST',
        serviceRequest: serviceRequest,
        imageFiles: imageFiles,
      );
    }
  }

  // Update an existing service
  static Future<ServiceModel> updateService(
      String serviceId,
      ServiceRequest serviceRequest, {
        List<File>? imageFiles,
      }) async {

    // If no images, use the no-images endpoint to avoid multipart issues
    if (imageFiles == null || imageFiles.isEmpty) {
      final uri = Uri.parse('${AppConfig.baseUrl}/service/update-no-images/$serviceId');
      return _sendJsonServiceRequest(
        uri: uri,
        method: 'PUT',
        serviceRequest: serviceRequest,
      );
    } else {
      final uri = Uri.parse('${AppConfig.baseUrl}/service/update/$serviceId');
      return _sendMultipartServiceRequest(
        uri: uri,
        method: 'PUT',
        serviceRequest: serviceRequest,
        imageFiles: imageFiles,
      );
    }
  }

  // Delete a service
  static Future<bool> deleteService(String serviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/service/delete/$serviceId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Failed to delete service');
    }
  }

  // Get all services
  static Future<List<ServiceModel>> getAllServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/service'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE') || response.body.trim().startsWith('<html')) {
        throw Exception('Server returned HTML instead of JSON. Please check the API endpoint.');
      }

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final List services = data['services'] ?? data['data'] ?? [];
          return services.map((e) => ServiceModel.fromJson(e)).toList();
        } catch (e) {
          print('JSON parsing error in getAllServices: $e');
          return [];
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to fetch services');
        } catch (e) {
          throw Exception('Failed to fetch services. Status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        throw Exception('No internet connection. Please check your network.');
      }
      rethrow;
    }
  }

  // Get services by business (with pagination and optional category)
  static Future<List<ServiceModel>> getBusinessServices({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final uri = Uri.parse('${AppConfig.baseUrl}/service/business/all').replace(
        queryParameters: queryParams,
      );

      print('Making request to: $uri');
      print('Headers: Authorization: Bearer $token');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body (first 200 chars): ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE') || response.body.trim().startsWith('<html')) {
        throw Exception('Server returned HTML instead of JSON. Please check the API endpoint.');
      }

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          final List services = data['services'] ?? data['data'] ?? [];
          return services.map((e) => ServiceModel.fromJson(e)).toList();
        } catch (e) {
          // If JSON parsing fails, return empty list instead of crashing
          print('JSON parsing error: $e');
          return [];
        }
      } else if (response.statusCode == 404) {
        // If business services endpoint not found, try the general services endpoint
        print('Business services endpoint not found, trying general services endpoint...');
        try {
          return await getAllServices();
        } catch (e) {
          print('General services endpoint also failed: $e');
          return [];
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to fetch business services');
        } catch (e) {
          throw Exception('Failed to fetch business services. Status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        throw Exception('No internet connection. Please check your network.');
      }
      rethrow;
    }
  }

  // Get single service by ID
  static Future<ServiceModel> getServiceById(String serviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/service/$serviceId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE') || response.body.trim().startsWith('<html')) {
        throw Exception('Server returned HTML instead of JSON. Please check the API endpoint.');
      }

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return ServiceModel.fromJson(data['service'] ?? data);
        } catch (e) {
          throw Exception('Failed to parse service data: $e');
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to fetch service');
        } catch (e) {
          throw Exception('Failed to fetch service. Status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        throw Exception('No internet connection. Please check your network.');
      }
      rethrow;
    }
  }

  // Common multipart request for create/update
  static Future<ServiceModel> _sendMultipartServiceRequest({
    required Uri uri,
    required String method,
    required ServiceRequest serviceRequest,
    List<File>? imageFiles,
  }) async {
    final headers = await _getMultipartHeaders();
    final request = http.MultipartRequest(method, uri);
    request.headers.addAll(headers);

    final data = serviceRequest.toJson();
    data.forEach((key, value) {
      if (value != null) {
        request.fields[key] = (value is Map || value is List)
            ? json.encode(value)
            : value.toString();
      }
    });

    if (imageFiles != null && imageFiles.isNotEmpty) {
      for (var file in imageFiles) {
        // Validate file before adding
        final extension = file.path.toLowerCase().split('.').last;
        if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
          try {
            final multipartFile = await http.MultipartFile.fromPath(
              'images',
              file.path,
              // Explicitly set content type based on extension
              contentType: MediaType.parse(_getContentType(extension)),
            );
            request.files.add(multipartFile);
            print('📎 Added file: ${file.path} ($extension)');
          } catch (e) {
            print('❌ Failed to add file ${file.path}: $e');
            throw Exception('Failed to process image file: ${file.path}');
          }
        } else {
          throw Exception('Invalid file format: ${file.path}. Only JPG, PNG, and GIF are allowed.');
        }
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    // Logging for debugging
    print('📤 Request URL: ${uri.toString()}');
    print('🔢 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    try {
      final responseBody = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ServiceModel.fromJson(responseBody['service']);
      } else {
        throw Exception(responseBody['message'] ?? 'Service request failed');
      }
    } catch (e) {
      throw Exception('Failed to parse response: ${response.body}');
    }
  }

  // JSON request for services without images
  static Future<ServiceModel> _sendJsonServiceRequest({
    required Uri uri,
    required String method,
    required ServiceRequest serviceRequest,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode(serviceRequest.toJson());

      print('📤 JSON Request URL: ${uri.toString()}');
      print('📤 Request Body: $body');

      http.Response response;
      if (method == 'POST') {
        response = await http.post(uri, headers: headers, body: body);
      } else if (method == 'PUT') {
        response = await http.put(uri, headers: headers, body: body);
      } else {
        throw Exception('Unsupported method: $method');
      }

      print('🔢 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE') || response.body.trim().startsWith('<html')) {
        throw Exception('Server returned HTML instead of JSON. Please check the API endpoint.');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final responseBody = json.decode(response.body);
          return ServiceModel.fromJson(responseBody['service']);
        } catch (e) {
          throw Exception('Failed to parse service data: $e');
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Service request failed');
        } catch (e) {
          throw Exception('Service request failed. Status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        throw Exception('No internet connection. Please check your network.');
      }
      rethrow;
    }
  }

  // Helper method to get content type based on file extension
  static String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }
}
