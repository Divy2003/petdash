import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utlis/app_config/app_config.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
        _isLoading = false;
        notifyListeners();
        // You can store token if needed using shared_preferences here
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
