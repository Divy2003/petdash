import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utlis/app_config/app_config.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  String? _userType;
  String? get userType => _userType;

  // Initialize token and user type from shared preferences
  Future<void> initToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userType = prefs.getString('user_type');
    notifyListeners();
  }

  // Save token and user type to shared preferences
  Future<void> saveToken(String token, {String? userType}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;

    if (userType != null) {
      await prefs.setString('user_type', userType);
      _userType = userType;
    }
    notifyListeners();
  }

  // Clear token and user type (for logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_type');
    _token = null;
    _userType = null;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('${AppConfig.baseUrl}/auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "email": email.trim(),
      "password": password.trim(),
    });

    try {
      final request = http.Request('POST', url);
      request.body = body;
      request.headers.addAll(headers);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        // Store the token and user type
        if (data['token'] != null) {
          await saveToken(data['token'], userType: data['user']?['userType']);
        }
        _isLoading = false;
        notifyListeners();
        return null; // Success
      } else {
        final errorData = jsonDecode(responseBody);
        _isLoading = false;
        notifyListeners();
        return errorData['message'] ?? 'Login failed';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "An error occurred. Please try again.";
    }
  }
}
