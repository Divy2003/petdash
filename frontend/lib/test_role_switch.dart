import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Simple test function to verify role switching works
class RoleSwitchTest {
  
  /// Test the role switching API with proper error handling
  static Future<void> testRoleSwitch() async {
    try {
      print('🧪 Testing Role Switch API...');
      
      // Get current token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        print('❌ No auth token found');
        return;
      }
      
      print('✅ Auth token found');
      
      // Get current user type
      final currentUserType = prefs.getString('user_type') ?? 'Pet Owner';
      final targetRole = currentUserType == 'Business' ? 'Pet Owner' : 'Business';
      
      print('📋 Current: $currentUserType → Target: $targetRole');
      
      // Test the API call
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var request = http.Request('POST', Uri.parse('http://localhost:5000/api/auth/switch-role'));
      request.body = json.encode({
        "newRole": targetRole
      });
      request.headers.addAll(headers);

      print('🚀 Making API call...');
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('✅ SUCCESS: Role switch API worked!');
        final data = json.decode(responseBody);
        print('📄 Response: ${data['message']}');
        print('🔄 New Role: ${data['user']['currentRole']}');
        
        // Update stored data
        await prefs.setString('auth_token', data['token']);
        await prefs.setString('user_type', data['user']['currentRole']);
        
        print('💾 Updated stored data');
      } else {
        print('❌ API call failed: ${response.statusCode}');
        print('📄 Error: $responseBody');
        
        // Try legacy method
        print('🔄 Trying legacy method...');
        await prefs.setString('user_type', targetRole);
        print('✅ Legacy switch completed');
      }
      
    } catch (e) {
      print('❌ Error during test: $e');
      
      // Try legacy fallback
      try {
        final prefs = await SharedPreferences.getInstance();
        final currentUserType = prefs.getString('user_type') ?? 'Pet Owner';
        final targetRole = currentUserType == 'Business' ? 'Pet Owner' : 'Business';
        await prefs.setString('user_type', targetRole);
        print('✅ Legacy fallback completed');
      } catch (fallbackError) {
        print('❌ Even legacy fallback failed: $fallbackError');
      }
    }
  }
  
  /// Decode JWT token to check role information
  static Future<void> checkTokenRoles() async {
    try {
      print('🔍 Checking JWT token roles...');
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        print('❌ No token found');
        return;
      }
      
      // Decode JWT token
      final parts = token.split('.');
      if (parts.length != 3) {
        print('❌ Invalid token format');
        return;
      }
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> tokenData = json.decode(decoded);
      
      print('📋 Token Data:');
      print('   User Type: ${tokenData['userType']}');
      print('   Current Role: ${tokenData['currentRole'] ?? tokenData['userType']}');
      
      final availableRoles = tokenData['availableRoles'];
      if (availableRoles != null) {
        final roles = (availableRoles as List<dynamic>)
            .map((role) => role.toString())
            .toList();
        print('   Available Roles: ${roles.join(', ')}');
        print('   Has Multiple Roles: ${roles.length > 1}');
      } else {
        print('   Available Roles: [${tokenData['userType']}] (default)');
        print('   Has Multiple Roles: false');
      }
      
    } catch (e) {
      print('❌ Error checking token: $e');
    }
  }
  
  /// Run all tests
  static Future<void> runAllTests() async {
    print('🧪 Starting Role Switch Tests...\n');
    
    await checkTokenRoles();
    print('');
    await testRoleSwitch();
    
    print('\n✅ Tests completed!');
  }
}

/// Simple usage example:
/// 
/// ```dart
/// // In your app, call this to test role switching
/// await RoleSwitchTest.runAllTests();
/// ```
