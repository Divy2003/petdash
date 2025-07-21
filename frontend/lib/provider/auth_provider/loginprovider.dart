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

  // Initialize token from shared preferences
  Future<void> initToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  // Save token to shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
    notifyListeners();
  }

  // Clear token (for logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
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
        // Store the token
        if (data['token'] != null) {
          await saveToken(data['token']);
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
