import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utlis/app_config/app_config.dart';
import '../../models/profile_model.dart';

class AddressService {
  static const String baseUrl = AppConfig.baseUrl;

  // Get headers with authentication
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get all user addresses
  static Future<List<AddressModel>> getUserAddresses() async {
    try {
      print('🔄 Fetching user addresses...');
      print('📍 URL: $baseUrl/profile/addresses');

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/profile/addresses'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['addresses'] != null) {
          final List<dynamic> addressesJson = data['addresses'];
          return addressesJson
              .map((json) => AddressModel.fromJson(json))
              .toList();
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch addresses');
      }

      return [];
    } catch (e) {
      print('❌ Address fetch error: ${e.toString()}');
      throw Exception('Failed to fetch addresses: ${e.toString()}');
    }
  }

  // Add new address
  static Future<AddressModel?> addAddress({
    required String label,
    required String streetName,
    required String city,
    required String state,
    required String zipCode,
    String? country,
    bool isPrimary = false,
  }) async {
    try {
      print('🔄 Adding new address...');
      print('📍 URL: $baseUrl/profile/addresses');

      final headers = await _getHeaders();
      final body = json.encode({
        'label': label,
        'streetName': streetName,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'country': country ?? 'USA',
        'isPrimary': isPrimary,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/profile/addresses'),
        headers: headers,
        body: body,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['address'] != null) {
          return AddressModel.fromJson(data['address']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add address');
      }

      return null;
    } catch (e) {
      print('❌ Add address error: ${e.toString()}');
      throw Exception('Failed to add address: ${e.toString()}');
    }
  }

  // Update existing address
  static Future<AddressModel?> updateAddress({
    required String addressId,
    String? label,
    String? streetName,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    try {
      print('🔄 Updating address...');
      print('📍 URL: $baseUrl/profile/addresses/$addressId');

      final headers = await _getHeaders();
      final body = json.encode({
        if (label != null) 'label': label,
        if (streetName != null) 'streetName': streetName,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zipCode != null) 'zipCode': zipCode,
        if (country != null) 'country': country,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/profile/addresses/$addressId'),
        headers: headers,
        body: body,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['address'] != null) {
          return AddressModel.fromJson(data['address']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update address');
      }

      return null;
    } catch (e) {
      print('❌ Update address error: ${e.toString()}');
      throw Exception('Failed to update address: ${e.toString()}');
    }
  }

  // Set address as primary
  static Future<bool> setPrimaryAddress(String addressId) async {
    try {
      print('🔄 Setting primary address...');
      print('📍 URL: $baseUrl/profile/addresses/$addressId/primary');

      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/profile/addresses/$addressId/primary'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to set primary address');
      }
    } catch (e) {
      print('❌ Set primary address error: ${e.toString()}');
      throw Exception('Failed to set primary address: ${e.toString()}');
    }
  }

  // Delete address
  static Future<bool> deleteAddress(String addressId) async {
    try {
      print('🔄 Deleting address...');
      print('📍 URL: $baseUrl/profile/addresses/$addressId');

      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/profile/addresses/$addressId'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete address');
      }
    } catch (e) {
      print('❌ Delete address error: ${e.toString()}');
      throw Exception('Failed to delete address: ${e.toString()}');
    }
  }

  // Get primary address
  static Future<AddressModel?> getPrimaryAddress() async {
    try {
      print('🔄 Fetching primary address...');
      print('📍 URL: $baseUrl/profile/addresses/primary');

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/profile/addresses/primary'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['address'] != null) {
          return AddressModel.fromJson(data['address']);
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch primary address');
      }

      return null;
    } catch (e) {
      print('❌ Primary address fetch error: ${e.toString()}');
      throw Exception('Failed to fetch primary address: ${e.toString()}');
    }
  }
}
