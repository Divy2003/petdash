import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare/features/screen/business/BusinessProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/screen/Navigation.dart';
import '../utlis/constants/colors.dart';
import '../utlis/constants/size.dart';

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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Switched to ${newUserType} account'),
      //     backgroundColor: AppColors.textPrimaryColor,
      //     duration: Duration(seconds: 2),
      //   ),
      // );
      
      // Navigate to appropriate screen
      Get.offAll(() => targetScreen);
      
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to switch account: ${e.toString()}'),
          backgroundColor: AppColors.error,
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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Logged out successfully'),
      //     backgroundColor: AppColors.white,
      //   ),
      // );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
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
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
              ),
              title: Text(
                'Switch Account',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              content: Text(
                'Switch from $currentType to $targetType account?',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    switchAccountType(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    'Switch',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.white,
                    ),
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
