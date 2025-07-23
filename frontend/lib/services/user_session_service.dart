import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare/features/screen/business/profile/BusinessProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/screen/Navigation.dart';

class UserSessionService {
  static const String _userTypeKey = 'user_type';
  static const String _tokenKey = 'auth_token';

  // Switch between Pet Owner and Business account
  static Future<void> switchAccountType(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserType = prefs.getString(_userTypeKey);
      
      // Toggle user type
      String newUserType;
      Widget targetScreen;
      
      if (currentUserType == "Business") {
        newUserType = "Pet Owner";
        targetScreen = const CurvedNavScreen();
      } else {
        newUserType = "Business";
        targetScreen =  BusinessProfileScreen();
      }
      
      // Update stored user type
      await prefs.setString(_userTypeKey, newUserType);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${newUserType} account'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navigate to appropriate screen
      Get.offAll(() => targetScreen);
      
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to switch account: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Get current user type
  static Future<String?> getCurrentUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  // Check if user is business
  static Future<bool> isBusinessUser() async {
    final userType = await getCurrentUserType();
    return userType == "Business";
  }

  // Check if user is pet owner
  static Future<bool> isPetOwner() async {
    final userType = await getCurrentUserType();
    return userType == "Pet Owner";
  }

  // Logout user
  static Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userTypeKey);
      await prefs.remove(_tokenKey);
      
      // Navigate to welcome screen or login
      // You can import and navigate to your welcome screen here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Show account switch confirmation dialog
  static void showAccountSwitchDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return FutureBuilder<String?>(
          future: getCurrentUserType(),
          builder: (context, snapshot) {
            final currentType = snapshot.data ?? "Pet Owner";
            final targetType = currentType == "Business" ? "Pet Owner" : "Business";
            
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Switch Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Text(
                'Switch from $currentType to $targetType account?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    switchAccountType(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Switch',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
