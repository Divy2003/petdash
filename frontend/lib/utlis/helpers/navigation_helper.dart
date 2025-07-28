import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/screen/Navigation.dart';
import '../../features/screen/auth/welcomeScreen.dart';

import '../../features/screen/business/BusinessProfileScreen.dart';

class NavigationHelper {
  static Future<Widget> getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userType = prefs.getString('user_type');

    // If no token, show welcome screen
    if (token == null) {
      return const WelcomeScreen();
    }

    // If token exists, navigate based on user type
    if (userType == "Business") {
      return const BusinessProfileScreen();
    } else {
      return const CurvedNavScreen();
    }
  }

  static Widget getHomeScreenForUserType(String? userType) {
    if (userType == "Business") {
      return const BusinessProfileScreen();
    } else {
      return const CurvedNavScreen();
    }
  }
}
