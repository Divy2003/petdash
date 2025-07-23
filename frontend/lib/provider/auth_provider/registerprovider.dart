// lib/providers/register_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/screen/auth/model/usermodel.dart';

import '../../utlis/app_config/app_config.dart';

enum UserType { petOwner, business }

class RegisterProvider with ChangeNotifier {
  UserType? selectedType;
  UserModel? _registeredUser;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  UserModel? get registeredUser => _registeredUser;

  void setUserType(UserType type) {
    selectedType = type;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (selectedType == null) return "Please select a user type";

    print("Starting registration for user type: $selectedType");

    final url = Uri.parse('${AppConfig.baseUrl}/auth/signup');
    final headers = {'Content-Type': 'application/json'};
    final userTypeString = selectedType == UserType.petOwner ? "Pet Owner" : "Business";
    final body = json.encode({
      "name": name.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "userType": userTypeString,
    });

    print("Registration request body: $body");

    try {
      _setLoading(true);

      // For testing purposes, you can uncomment the lines below to bypass backend
      // and test the navigation flow directly:
      /*
      print("Mock registration successful for testing");
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      // Store user type in shared preferences for future use
      final prefs = await SharedPreferences.getInstance();
      final userTypeString = selectedType == UserType.petOwner ? "Pet Owner" : "Business";
      await prefs.setString('user_type', userTypeString);
      await prefs.setString('auth_token', 'mock_token_for_testing');

      _registeredUser = UserModel(
        name: name,
        email: email,
        password: password,
        userType: selectedType!,
      );

      notifyListeners();
      return null; // Success
      */

      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      print("Registration response status: ${response.statusCode}");
      print("Registration response body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save user for reuse (Edit Profile, etc.)
        _registeredUser = UserModel(
          name: name,
          email: email,
          password: password,
          userType: selectedType!,
        );

        // Store user type and token in shared preferences for future use
        final prefs = await SharedPreferences.getInstance();
        final userTypeString = selectedType == UserType.petOwner ? "Pet Owner" : "Business";
        await prefs.setString('user_type', userTypeString);

        // If backend returns a token during registration, store it
        if (responseBody['token'] != null) {
          await prefs.setString('auth_token', responseBody['token']);
        }

        notifyListeners();
        return null;
      } else {
        return responseBody['message'] ?? 'Signup failed';
      }
    } catch (e) {
      return "An error occurred. Please try again.";
    } finally {
      _setLoading(false);
    }
  }
}
