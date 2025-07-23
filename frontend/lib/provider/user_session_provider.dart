import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionProvider with ChangeNotifier {
  String? _userType;
  String? _token;
  bool _isLoggedIn = false;

  String? get userType => _userType;
  String? get token => _token;
  bool get isLoggedIn => _isLoggedIn;
  bool get isBusinessUser => _userType == "Business";
  bool get isPetOwner => _userType == "Pet Owner";

  // Initialize session from stored preferences
  Future<void> initSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userType = prefs.getString('user_type');
    _isLoggedIn = _token != null;
    notifyListeners();
  }

  // Set user session after login/registration
  Future<void> setUserSession({
    required String token,
    required String userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_type', userType);
    
    _token = token;
    _userType = userType;
    _isLoggedIn = true;
    notifyListeners();
  }

  // Clear session on logout
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_type');
    
    _token = null;
    _userType = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Get appropriate home screen widget based on user type
  Widget getHomeScreen() {
    if (!_isLoggedIn) {
      // Return welcome/login screen
      return Container(); // This will be handled by splash screen
    }
    
    if (isBusinessUser) {
      // Return business navigation
      return Container(); // Will be imported when needed
    } else {
      // Return pet owner navigation
      return Container(); // Will be imported when needed
    }
  }
}
