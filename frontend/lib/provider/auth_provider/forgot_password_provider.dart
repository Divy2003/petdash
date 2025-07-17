import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utlis/app_config/app_config.dart';

class ForgotPasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _email;
  String? get email => _email;

  bool _isOtpSent = false;
  bool get isOtpSent => _isOtpSent;

  bool _isOtpVerified = false;
  bool get isOtpVerified => _isOtpVerified;

  // Step 1: Request password reset (send OTP to email)
  Future<String?> requestPasswordReset(String email) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('${AppConfig.baseUrl}/auth/request-password-reset');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"email": email.trim()});

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _email = email.trim();
        _isOtpSent = true;
        _isLoading = false;
        notifyListeners();
        return null; // Success
      } else {
        _isLoading = false;
        notifyListeners();
        return responseBody['message'] ?? 'Failed to send reset code';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "An error occurred. Please try again.";
    }
  }

  // Step 2: Verify OTP (optional step for better UX)
  Future<String?> verifyOtp(String otp) async {
    if (_email == null) return "Email not found. Please start over.";

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('${AppConfig.baseUrl}/auth/verify-otp');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "email": _email,
      "otp": otp.trim(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isOtpVerified = true;
        _isLoading = false;
        notifyListeners();
        return null; // Success
      } else {
        _isLoading = false;
        notifyListeners();
        return responseBody['message'] ?? 'Invalid or expired OTP';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "An error occurred. Please try again.";
    }
  }

  // Step 3: Reset password with OTP and new password
  Future<String?> resetPassword(String otp, String newPassword) async {
    if (_email == null) return "Email not found. Please start over.";

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('${AppConfig.baseUrl}/auth/reset-password');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "email": _email,
      "otp": otp.trim(),
      "newPassword": newPassword.trim(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isLoading = false;
        // Reset all states after successful password reset
        _resetState();
        notifyListeners();
        return null; // Success
      } else {
        _isLoading = false;
        notifyListeners();
        return responseBody['message'] ?? 'Failed to reset password';
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "An error occurred. Please try again.";
    }
  }

  // Reset provider state
  void _resetState() {
    _email = null;
    _isOtpSent = false;
    _isOtpVerified = false;
  }

  // Public method to reset state (useful when user cancels the flow)
  void resetState() {
    _resetState();
    notifyListeners();
  }

  // Resend OTP
  Future<String?> resendOtp() async {
    if (_email == null) return "Email not found. Please start over.";
    
    _isOtpVerified = false; // Reset verification status
    return await requestPasswordReset(_email!);
  }
}
