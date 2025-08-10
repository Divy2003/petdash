import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/screen/Navigation.dart';
import '../../features/screen/auth/login/loginscreen.dart';

import '../../features/screen/business/BusinessProfileScreen.dart';

class NavigationHelper {
  static Future<Widget> getInitialScreen() async {
    // Always show Login screen on app launch
    return const LoginScreen();
  }

  static Widget getHomeScreenForUserType(String? userType) {
    if (userType == "Business") {
      return const BusinessProfileScreen();
    } else {
      return const CurvedNavScreen();
    }
  }

  // Helper method to clear all stored authentication data
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_type');
  }

  // Helper method to check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
}
