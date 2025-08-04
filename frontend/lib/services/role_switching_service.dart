import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utlis/app_config/app_config.dart';
import 'api_service.dart';

class RoleSwitchingService {
  static final String baseUrl = AppConfig.baseUrl;

  /// Switch user role to a new role
  /// Returns the new token and user information on success
  static Future<Map<String, dynamic>> switchRole(String newRole) async {
    try {
      // Check if user can switch to this role, but don't fail if we can't determine it
      final canSwitch = await ApiService.canSwitchToRole(newRole);

      // Only throw error if we can definitively say they can't switch
      // If we can't determine (e.g., no token or parsing error), let the API decide
      final roleInfo = await ApiService.getCurrentUserRoleInfo();
      if (roleInfo != null && !canSwitch) {
        final availableRoles = (roleInfo['availableRoles'] as List<dynamic>?)
                ?.map((role) => role.toString())
                .toList() ??
            [];
        final currentRole = roleInfo['currentRole'];

        // If user has multiple roles but target role is not available, throw error
        if (availableRoles.length > 1 && !availableRoles.contains(newRole)) {
          throw RoleSwitchException(
            'You do not have permission to switch to $newRole role',
            statusCode: 403,
            availableRoles: availableRoles,
          );
        }

        // If user only has one role and it's the same as target, no need to switch
        if (availableRoles.length == 1 && currentRole == newRole) {
          throw RoleSwitchException(
            'You are already in $newRole role',
            statusCode: 400,
          );
        }
      }

      // Get current token for authorization
      final prefs = await SharedPreferences.getInstance();
      final currentToken = prefs.getString('auth_token');

      if (currentToken == null) {
        throw RoleSwitchException(
          'Authentication required. Please log in again.',
          statusCode: 401,
        );
      }

      // Prepare request headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $currentToken',
      };

      // Make API call to switch role
      final response = await http.post(
        Uri.parse('$baseUrl/auth/switch-role'),
        headers: headers,
        body: json.encode({'newRole': newRole}),
      );

      // Handle response
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Update stored token and user information
        await _updateStoredUserData(responseData);

        return responseData;
      } else {
        final errorData = json.decode(response.body);
        throw RoleSwitchException(
          errorData['message'] ?? 'Failed to switch role',
          statusCode: response.statusCode,
          availableRoles: errorData['availableRoles'],
        );
      }
    } catch (e) {
      if (e is RoleSwitchException) {
        rethrow;
      }
      throw RoleSwitchException('Network error: ${e.toString()}');
    }
  }

  /// Get current user's role information
  static Future<Map<String, dynamic>?> getCurrentRoleInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) return null;

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('$baseUrl/auth/role-info'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Fallback to token decoding if API fails
        return await ApiService.getCurrentUserRoleInfo();
      }
    } catch (e) {
      // Fallback to token decoding
      return await ApiService.getCurrentUserRoleInfo();
    }
  }

  /// Check if user can switch to a specific role
  static Future<bool> canSwitchToRole(String targetRole) async {
    try {
      final roleInfo = await getCurrentRoleInfo();
      if (roleInfo == null) return false;

      final availableRoles = (roleInfo['availableRoles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [];
      return availableRoles.contains(targetRole);
    } catch (e) {
      return false;
    }
  }

  /// Get list of available roles for current user
  static Future<List<String>> getAvailableRoles() async {
    try {
      final roleInfo = await getCurrentRoleInfo();
      if (roleInfo == null) return [];

      return List<String>.from(roleInfo['availableRoles'] ?? []);
    } catch (e) {
      return [];
    }
  }

  /// Get current active role
  static Future<String?> getCurrentRole() async {
    try {
      final roleInfo = await getCurrentRoleInfo();
      return roleInfo?['currentRole'];
    } catch (e) {
      return null;
    }
  }

  /// Check if user has multiple roles available
  static Future<bool> hasMultipleRoles() async {
    try {
      final availableRoles = await getAvailableRoles();
      return availableRoles.length > 1;
    } catch (e) {
      return false;
    }
  }

  /// Update stored user data after role switch
  static Future<void> _updateStoredUserData(
      Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();

    // Update token
    if (responseData['token'] != null) {
      await prefs.setString('auth_token', responseData['token']);
    }

    // Update user type based on current role
    if (responseData['user'] != null &&
        responseData['user']['currentRole'] != null) {
      await prefs.setString('user_type', responseData['user']['currentRole']);
    }

    // Store additional user information if needed
    if (responseData['user'] != null) {
      await prefs.setString('user_data', json.encode(responseData['user']));
    }
  }

  /// Validate role switch request before making API call
  static Future<RoleSwitchValidation> validateRoleSwitch(String newRole) async {
    try {
      final roleInfo = await getCurrentRoleInfo();

      if (roleInfo == null) {
        return RoleSwitchValidation(
          isValid: false,
          errorMessage: 'User authentication required',
        );
      }

      final currentRole = roleInfo['currentRole'];
      final availableRoles = (roleInfo['availableRoles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [];

      // Check if already in target role
      if (currentRole == newRole) {
        return RoleSwitchValidation(
          isValid: false,
          errorMessage: 'Already in $newRole role',
        );
      }

      // Check if role is available
      if (!availableRoles.contains(newRole)) {
        return RoleSwitchValidation(
          isValid: false,
          errorMessage: 'You do not have access to $newRole role',
          availableRoles: availableRoles,
        );
      }

      return RoleSwitchValidation(
        isValid: true,
        currentRole: currentRole,
        targetRole: newRole,
        availableRoles: availableRoles,
      );
    } catch (e) {
      return RoleSwitchValidation(
        isValid: false,
        errorMessage: 'Error validating role switch: ${e.toString()}',
      );
    }
  }
}

/// Exception class for role switching errors
class RoleSwitchException implements Exception {
  final String message;
  final int? statusCode;
  final List<String>? availableRoles;

  RoleSwitchException(
    this.message, {
    this.statusCode,
    this.availableRoles,
  });

  @override
  String toString() => 'RoleSwitchException: $message';
}

/// Validation result for role switch requests
class RoleSwitchValidation {
  final bool isValid;
  final String? errorMessage;
  final String? currentRole;
  final String? targetRole;
  final List<String>? availableRoles;

  RoleSwitchValidation({
    required this.isValid,
    this.errorMessage,
    this.currentRole,
    this.targetRole,
    this.availableRoles,
  });
}
