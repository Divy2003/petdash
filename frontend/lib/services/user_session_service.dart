import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare/features/screen/business/BusinessProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/screen/Navigation.dart';
import '../utlis/constants/colors.dart';
import '../utlis/constants/size.dart';
import '../provider/role_switching_provider.dart';
import '../services/role_switching_service.dart';
import 'package:provider/provider.dart';

class UserSessionService {
  static const String _userTypeKey = 'user_type';
  static const String _tokenKey = 'auth_token';

  // Switch between Pet Owner and Business account using proper role switching
  static Future<void> switchAccountType(BuildContext context) async {
    try {
      // Try to get role switching provider if available
      RoleSwitchingProvider? roleSwitchingProvider;
      try {
        roleSwitchingProvider =
            Provider.of<RoleSwitchingProvider>(context, listen: false);
      } catch (e) {
        // Provider not available, fall back to legacy method
        await switchAccountTypeLegacy(context);
        return;
      }

      // Get current role information
      await roleSwitchingProvider.initializeRoleInfo();

      // If user doesn't have multiple roles configured in backend,
      // try the API call anyway or fall back to legacy method
      if (!roleSwitchingProvider.hasMultipleRoles) {
        // Try to determine target role from current stored user type
        final prefs = await SharedPreferences.getInstance();
        final currentUserType = prefs.getString(_userTypeKey);

        String targetRole;
        Widget targetScreen;

        if (currentUserType == "Business") {
          targetRole = "Pet Owner";
          targetScreen = const CurvedNavScreen();
        } else {
          targetRole = "Business";
          targetScreen = BusinessProfileScreen();
        }

        // Try the API call first
        try {
          await RoleSwitchingService.switchRole(targetRole);

          // If API call succeeds, navigate to target screen
          Get.snackbar(
            "Role Switched",
            'Successfully switched to $targetRole account',
            backgroundColor: AppColors.primaryColor,
            colorText: AppColors.white,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
          );

          Get.offAll(() => targetScreen);
          return;
        } catch (e) {
          // API call failed, fall back to legacy method
          print('API role switch failed, using legacy method: $e');
          await switchAccountTypeLegacy(context);
          return;
        }
      }

      // User has multiple roles, use the provider method
      String? targetRole;
      Widget targetScreen;

      if (roleSwitchingProvider.currentRole == "Business") {
        targetRole = "Pet Owner";
        targetScreen = const CurvedNavScreen();
      } else if (roleSwitchingProvider.currentRole == "Pet Owner") {
        targetRole = "Business";
        targetScreen = BusinessProfileScreen();
      } else {
        // Use quick switch for other cases
        targetRole = roleSwitchingProvider.getOppositeRole();
        if (targetRole == null) {
          Get.snackbar(
            "Role Switch Error",
            'Unable to determine target role',
            backgroundColor: AppColors.error,
            colorText: AppColors.white,
            duration: Duration(seconds: 3),
          );
          return;
        }
        targetScreen = targetRole == "Pet Owner"
            ? const CurvedNavScreen()
            : BusinessProfileScreen();
      }

      // Perform role switch
      final success = await roleSwitchingProvider.switchRole(targetRole);

      if (success) {
        // Navigate to appropriate screen
        Get.offAll(() => targetScreen);
      }
    } catch (e) {
      // Show error message
      Get.snackbar(
        "Error",
        'Failed to switch account: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // Legacy method for backward compatibility - now uses simple local switching
  static Future<void> switchAccountTypeLegacy(BuildContext context) async {
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
        targetScreen = BusinessProfileScreen();
      }

      // Update stored user type
      await prefs.setString(_userTypeKey, newUserType);

      // Navigate to appropriate screen
      Get.offAll(() => targetScreen);
    } catch (e) {
      // Show error message
      Get.snackbar(
        "Error",
        'Failed to switch account: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: Duration(seconds: 3),
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
      Get.snackbar(
        "Error",
        'Logout failed: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
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
            final targetType =
                currentType == "Business" ? "Pet Owner" : "Business";

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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Switch from $currentType to $targetType account?',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will change your account type and navigate you to the appropriate screen.',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.grey,
                        ),
                  ),
                ],
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
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    'Switch to $targetType',
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
