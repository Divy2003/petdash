import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utlis/app_config/app_config.dart';
import 'api_service.dart';

class ProfileService {
  // Get user profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.get('/profile/get-profile', requireAuth: true);

      if (response['profile'] != null) {
        return response['profile'];
      }

      throw Exception('Profile data not found');
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    File? profileImage,
    File? shopImage,
    String? shopOpenTime,
    String? shopCloseTime,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${AppConfig.baseUrl}/profile/create-update-profile'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      if (name != null) request.fields['name'] = name;
      if (email != null) request.fields['email'] = email;
      if (phoneNumber != null) request.fields['phoneNumber'] = phoneNumber;
      if (address != null) request.fields['address'] = address;
      if (shopOpenTime != null) request.fields['shopOpenTime'] = shopOpenTime;
      if (shopCloseTime != null) request.fields['shopCloseTime'] = shopCloseTime;

      // Add profile image file if provided
      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profileImage', profileImage.path),
        );
      }

      // Add shop image file if provided
      if (shopImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('shopImage', shopImage.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        final responseData = json.decode(response.body);
        return responseData;

      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  // Get shared data (for role-based information)
  static Future<Map<String, dynamic>> getSharedData() async {
    try {
      final response = await ApiService.get('/profile/shared-data', requireAuth: true);

      if (response['data'] != null) {
        return response['data'];
      }

      throw Exception('Shared data not found');
    } catch (e) {
      throw Exception('Failed to fetch shared data: ${e.toString()}');
    }
  }

  // Get user addresses
  static Future<List<Map<String, dynamic>>> getUserAddresses() async {
    try {
      final response = await ApiService.get('/profile/addresses', requireAuth: true);

      if (response['addresses'] != null) {
        return List<Map<String, dynamic>>.from(response['addresses']);
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch addresses: ${e.toString()}');
    }
  }

  // Add new address
  static Future<Map<String, dynamic>> addAddress({
    required String label,
    required String streetName,
    required String city,
    required String state,
    required String zipCode,
    String? country,
    bool isPrimary = false,
  }) async {
    try {
      final response = await ApiService.post('/profile/addresses', {
        'label': label,
        'streetName': streetName,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'country': country ?? 'USA',
        'isPrimary': isPrimary,
      }, requireAuth: true);

      return response;
    } catch (e) {
      throw Exception('Failed to add address: ${e.toString()}');
    }
  }

  // Update existing address
  static Future<Map<String, dynamic>> updateAddress({
    required String addressId,
    String? label,
    String? streetName,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};
      if (label != null) updateData['label'] = label;
      if (streetName != null) updateData['streetName'] = streetName;
      if (city != null) updateData['city'] = city;
      if (state != null) updateData['state'] = state;
      if (zipCode != null) updateData['zipCode'] = zipCode;
      if (country != null) updateData['country'] = country;

      final response = await ApiService.put('/profile/addresses/$addressId', updateData, requireAuth: true);

      return response;
    } catch (e) {
      throw Exception('Failed to update address: ${e.toString()}');
    }
  }

  // Delete address
  static Future<void> deleteAddress(String addressId) async {
    try {
      await ApiService.delete('/profile/addresses/$addressId', requireAuth: true);
    } catch (e) {
      throw Exception('Failed to delete address: ${e.toString()}');
    }
  }

  // Set primary address
  static Future<Map<String, dynamic>> setPrimaryAddress(String addressId) async {
    try {
      final response = await ApiService.put('/profile/addresses/$addressId/primary', {}, requireAuth: true);

      return response;
    } catch (e) {
      throw Exception('Failed to set primary address: ${e.toString()}');
    }
  }

  // Get primary address
  static Future<Map<String, dynamic>?> getPrimaryAddress() async {
    try {
      final response = await ApiService.get('/profile/addresses/primary', requireAuth: true);

      if (response['address'] != null) {
        return response['address'];
      }

      return null;
    } catch (e) {
      throw Exception('Failed to fetch primary address: ${e.toString()}');
    }
  }
}
