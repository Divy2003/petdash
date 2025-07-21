// lib/providers/register_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

    final url = Uri.parse('${AppConfig.baseUrl}/auth/signup');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "name": name.trim(),
      "email": email.trim(),
      "password": password.trim(),
      "userType": selectedType == UserType.petOwner ? "Pet Owner" : "Business",
    });

    try {
      _setLoading(true);

      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save user for reuse (Edit Profile, etc.)
        _registeredUser = UserModel(
          name: name,
          email: email,
          password: password,
          userType: selectedType!,
        );

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
