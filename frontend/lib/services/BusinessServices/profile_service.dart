import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/profile_model.dart';
import '../../utlis/app_config/app_config.dart';

class ProfileService {
  static final String baseUrl = AppConfig.baseUrl;

  // Helper function to get content type using mime package
  static String _getContentType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    if (mimeType != null && mimeType.startsWith('image/')) {
      return mimeType;
    }
    // Default to jpeg if mime type detection fails
    return 'image/jpeg';
  }

  // Get headers with authentication
  static Future<Map<String, String>> _getHeaders(
      {bool isMultipart = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print('📦 Retrieved token: $token');

    if (token == null || token.isEmpty || token.contains('mock_token')) {
      throw Exception(
          'Authentication failed. Token missing or invalid. Please login again.');
    }

    Map<String, String> headers = {};

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    headers['Authorization'] = 'Bearer $token';

    return headers;
  }

  // Get user profile
  static Future<ProfileModel?> getProfile() async {
    try {
      print('🔄 Fetching profile...');
      print('📍 URL: $baseUrl/profile/get-profile');

      final headers = await _getHeaders();
      print('🔑 Headers: $headers');

      final response = await http.get(
        Uri.parse('$baseUrl/profile/get-profile'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        throw Exception(
            'Server returned HTML instead of JSON. Server may be down or endpoint incorrect. Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['profile'] != null) {
          print('✅ Profile fetched successfully');
          return ProfileModel.fromJson(data['profile']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch profile');
      }

      return null;
    } catch (e) {
      print('❌ Profile fetch error: ${e.toString()}');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        throw Exception(
            'Cannot connect to server. Please check your internet connection.');
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Update profile with multipart form data for images
  static Future<ProfileModel?> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? shopOpenTime,
    String? shopCloseTime,
    File? profileImageFile,
    File? shopImageFile,
  }) async {
    try {
      print('🔄 Starting profile update...');
      print('📍 URL: $baseUrl/profile/create-update-profile');

      final headers = await _getHeaders(isMultipart: true);
      print('🔑 Headers: $headers');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/profile/create-update-profile'),
      );

      request.headers.addAll(headers);

      if (name != null && name.isNotEmpty) {
        request.fields['name'] = name;
        print('📝 Adding name: $name');
      }
      if (email != null && email.isNotEmpty) {
        request.fields['email'] = email;
        print('📧 Adding email: $email');
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        request.fields['phoneNumber'] = phoneNumber;
        print('📱 Adding phone: $phoneNumber');
      }
      if (shopOpenTime != null && shopOpenTime.isNotEmpty) {
        request.fields['shopOpenTime'] = shopOpenTime;
        print('🕐 Adding shop open time: $shopOpenTime');
      }
      if (shopCloseTime != null && shopCloseTime.isNotEmpty) {
        request.fields['shopCloseTime'] = shopCloseTime;
        print('🕕 Adding shop close time: $shopCloseTime');
      }

      if (profileImageFile != null) {
        print('🖼️ Adding profile image: ${profileImageFile.path}');
        final extension = profileImageFile.path.split('.').last.toLowerCase();

        // Validate file extension
        if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
          try {
            final multipartFile = await http.MultipartFile.fromPath(
              'profileImage',
              profileImageFile.path,
              // Explicitly set content type based on extension
              contentType:
                  MediaType.parse(_getContentType(profileImageFile.path)),
            );
            request.files.add(multipartFile);
            print(
                '📎 Added profile image: ${profileImageFile.path} ($extension)');
          } catch (e) {
            print('❌ Failed to add profile image ${profileImageFile.path}: $e');
            throw Exception(
                'Failed to process profile image: ${profileImageFile.path}');
          }
        } else {
          throw Exception(
              'Invalid profile image format: ${profileImageFile.path}. Only JPG, PNG, and GIF are allowed.');
        }
      }

      if (shopImageFile != null) {
        print('🏪 Adding shop image: ${shopImageFile.path}');
        final extension = shopImageFile.path.split('.').last.toLowerCase();

        // Validate file extension
        if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
          try {
            final multipartFile = await http.MultipartFile.fromPath(
              'shopImage',
              shopImageFile.path,
              // Explicitly set content type based on extension
              contentType: MediaType.parse(_getContentType(shopImageFile.path)),
            );
            request.files.add(multipartFile);
            print('📎 Added shop image: ${shopImageFile.path} ($extension)');
          } catch (e) {
            print('❌ Failed to add shop image ${shopImageFile.path}: $e');
            throw Exception(
                'Failed to process shop image: ${shopImageFile.path}');
          }
        } else {
          throw Exception(
              'Invalid shop image format: ${shopImageFile.path}. Only JPG, PNG, and GIF are allowed.');
        }
      }

      print('📤 Sending request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        throw Exception(
            'Server returned HTML instead of JSON. Server may be down or endpoint incorrect. Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['profile'] != null) {
          print('✅ Profile updated successfully');
          return ProfileModel.fromJson(data['profile']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }

      return null;
    } catch (e) {
      print('❌ Profile update error: ${e.toString()}');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        throw Exception(
            'Cannot connect to server. Please check your internet connection.');
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Optional: Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty && !token.contains('mock_token');
  }
}
