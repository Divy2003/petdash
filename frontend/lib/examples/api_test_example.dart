import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Example demonstrating the exact API call you mentioned
class ApiTestExample {
  
  /// Test the role switching API with the exact code you provided
  static Future<Map<String, dynamic>> testRoleSwitchApi({
    String? customToken,
    String targetRole = "Pet Owner",
  }) async {
    try {
      // Get token from SharedPreferences if not provided
      String? token = customToken;
      if (token == null) {
        final prefs = await SharedPreferences.getInstance();
        token = prefs.getString('auth_token');
      }

      if (token == null) {
        return {
          'success': false,
          'error': 'No authentication token found',
          'statusCode': 401,
        };
      }

      // Your exact API call code
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var request = http.Request('POST', Uri.parse('http://localhost:5000/api/auth/switch-role'));
      request.body = json.encode({
        "newRole": targetRole
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        
        // Update stored token and user data
        await _updateStoredData(responseData);
        
        return {
          'success': true,
          'data': responseData,
          'statusCode': response.statusCode,
          'message': 'Role switched successfully',
        };
      } else {
        final errorData = json.decode(responseBody);
        return {
          'success': false,
          'error': errorData['message'] ?? response.reasonPhrase,
          'statusCode': response.statusCode,
          'availableRoles': errorData['availableRoles'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
        'statusCode': null,
      };
    }
  }

  /// Update stored authentication data after successful role switch
  static Future<void> _updateStoredData(Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Update token
    if (responseData['token'] != null) {
      await prefs.setString('auth_token', responseData['token']);
    }
    
    // Update user type based on current role
    if (responseData['user'] != null && responseData['user']['currentRole'] != null) {
      await prefs.setString('user_type', responseData['user']['currentRole']);
    }
  }

  /// Check current role from JWT token
  static Future<Map<String, dynamic>?> getCurrentRoleFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) return null;
      
      // Decode JWT token
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> tokenData = json.decode(decoded);
      
      return {
        'currentRole': tokenData['currentRole'] ?? tokenData['userType'],
        'availableRoles': tokenData['availableRoles'] ?? [tokenData['userType']],
        'userType': tokenData['userType'],
        'userId': tokenData['id'],
      };
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  /// Validate if user can switch to target role
  static Future<bool> canSwitchToRole(String targetRole) async {
    try {
      final roleInfo = await getCurrentRoleFromToken();
      if (roleInfo == null) return false;
      
      final availableRoles = List<String>.from(roleInfo['availableRoles'] ?? []);
      return availableRoles.contains(targetRole);
    } catch (e) {
      return false;
    }
  }
}

/// Widget to test the API functionality
class ApiTestWidget extends StatefulWidget {
  const ApiTestWidget({Key? key}) : super(key: key);

  @override
  State<ApiTestWidget> createState() => _ApiTestWidgetState();
}

class _ApiTestWidgetState extends State<ApiTestWidget> {
  String? _testResult;
  bool _isLoading = false;
  Map<String, dynamic>? _currentRoleInfo;

  @override
  void initState() {
    super.initState();
    _loadCurrentRoleInfo();
  }

  Future<void> _loadCurrentRoleInfo() async {
    final roleInfo = await ApiTestExample.getCurrentRoleFromToken();
    setState(() {
      _currentRoleInfo = roleInfo;
    });
  }

  Future<void> _testApiCall(String targetRole) async {
    setState(() {
      _isLoading = true;
      _testResult = null;
    });

    final result = await ApiTestExample.testRoleSwitchApi(targetRole: targetRole);
    
    setState(() {
      _isLoading = false;
      if (result['success']) {
        _testResult = 'SUCCESS!\n'
            'Message: ${result['message']}\n'
            'Status Code: ${result['statusCode']}\n'
            'New Role: ${result['data']['user']['currentRole']}\n'
            'Previous Role: ${result['data']['previousRole']}';
      } else {
        _testResult = 'FAILED!\n'
            'Error: ${result['error']}\n'
            'Status Code: ${result['statusCode']}\n'
            '${result['availableRoles'] != null ? 'Available Roles: ${result['availableRoles'].join(', ')}' : ''}';
      }
    });

    // Reload role info after test
    await _loadCurrentRoleInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Role Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Role Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_currentRoleInfo != null) ...[
                      Text('Current Role: ${_currentRoleInfo!['currentRole']}'),
                      Text('User Type: ${_currentRoleInfo!['userType']}'),
                      Text('Available Roles: ${_currentRoleInfo!['availableRoles'].join(', ')}'),
                      Text('User ID: ${_currentRoleInfo!['userId']}'),
                    ] else ...[
                      const Text('No authentication token found'),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Test Buttons
            const Text(
              'Test Role Switching API',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _testApiCall('Pet Owner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Switch to Pet Owner'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _testApiCall('Business'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Switch to Business'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Loading indicator
            if (_isLoading) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Testing API call...'),
                  ],
                ),
              ),
            ],

            // Test Result
            if (_testResult != null) ...[
              const Text(
                'Test Result:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _testResult!.startsWith('SUCCESS')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _testResult!.startsWith('SUCCESS')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Text(
                  _testResult!,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: _testResult!.startsWith('SUCCESS')
                        ? Colors.green[700]
                        : Colors.red[700],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // API Code Example
            const Text(
              'API Call Code:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                '''var headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer <your-token>'
};

var request = http.Request('POST', 
  Uri.parse('http://localhost:5000/api/auth/switch-role'));
request.body = json.encode({
  "newRole": "Pet Owner"
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
} else {
  print(response.reasonPhrase);
}''',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
