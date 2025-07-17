// lib/providers/register_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utlis/app_config/app_config.dart';

enum UserType {petOwner, business }

class RegisterProvider with ChangeNotifier {
  UserType? selectedType;

  void setUserType(UserType type) {
    selectedType = type;
    notifyListeners();
  }

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (selectedType == null) return "Please select a user type";

    final url = Uri.parse('${AppConfig.baseUrl}/auth/signup');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "name": name.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "userType": selectedType == UserType.petOwner ? "Pet Owner" : "Business",
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return null; // success
      } else {
        return responseBody['message'] ?? 'Signup failed';
      }
    } catch (e) {
      return "An error occurred. Please try again.";
    }
  }
}
