import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/role_switching_service.dart';
import '../utlis/constants/colors.dart';

class RoleSwitchingProvider with ChangeNotifier {
  // State variables
  bool _isLoading = false;
  String? _currentRole;
  List<String> _availableRoles = [];
  String? _error;
  bool _hasMultipleRoles = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get currentRole => _currentRole;
  List<String> get availableRoles => _availableRoles;
  String? get error => _error;
  bool get hasMultipleRoles => _hasMultipleRoles;
  bool get canSwitchRoles => _hasMultipleRoles && !_isLoading;

  /// Initialize role information
  Future<void> initializeRoleInfo() async {
    try {
      _setLoading(true);
      _clearError();

      final roleInfo = await RoleSwitchingService.getCurrentRoleInfo();

      if (roleInfo != null) {
        _currentRole = roleInfo['currentRole'];
        _availableRoles = (roleInfo['availableRoles'] as List<dynamic>?)
                ?.map((role) => role.toString())
                .toList() ??
            [];
        _hasMultipleRoles = _availableRoles.length > 1;
      } else {
        _currentRole = null;
        _availableRoles = [];
        _hasMultipleRoles = false;
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to load role information: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Switch to a new role
  Future<bool> switchRole(String newRole) async {
    try {
      _setLoading(true);
      _clearError();

      // Validate the role switch first
      final validation = await RoleSwitchingService.validateRoleSwitch(newRole);

      if (!validation.isValid) {
        _setError(validation.errorMessage ?? 'Invalid role switch request');
        return false;
      }

      // Perform the role switch
      await RoleSwitchingService.switchRole(newRole);

      // Update local state
      _currentRole = newRole;

      // Show success message
      Get.snackbar(
        "Role Switched",
        'Successfully switched to $newRole role',
        backgroundColor: AppColors.textPrimaryColor,
        colorText: AppColors.white,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );

      notifyListeners();
      return true;
    } catch (e) {
      String errorMessage = 'Failed to switch role';

      if (e is RoleSwitchException) {
        errorMessage = e.message;

        // Show available roles if provided
        if (e.availableRoles != null && e.availableRoles!.isNotEmpty) {
          errorMessage += '\nAvailable roles: ${e.availableRoles!.join(', ')}';
        }
      } else {
        errorMessage = 'Failed to switch role: ${e.toString()}';
      }

      _setError(errorMessage);

      // Show error snackbar
      Get.snackbar(
        "Role Switch Failed",
        errorMessage,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      );

      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get the opposite role for quick switching
  String? getOppositeRole() {
    if (!_hasMultipleRoles || _currentRole == null) return null;

    final otherRoles =
        _availableRoles.where((role) => role != _currentRole).toList();
    return otherRoles.isNotEmpty ? otherRoles.first : null;
  }

  /// Quick switch to the opposite role (for users with 2 roles)
  Future<bool> quickSwitchRole() async {
    final oppositeRole = getOppositeRole();
    if (oppositeRole == null) return false;

    return await switchRole(oppositeRole);
  }

  /// Check if user can switch to a specific role
  Future<bool> canSwitchToRole(String targetRole) async {
    try {
      return await RoleSwitchingService.canSwitchToRole(targetRole);
    } catch (e) {
      return false;
    }
  }

  /// Refresh role information
  Future<void> refreshRoleInfo() async {
    await initializeRoleInfo();
  }

  /// Get role display name
  String getRoleDisplayName(String role) {
    switch (role) {
      case 'Pet Owner':
        return 'Pet Owner';
      case 'Business':
        return 'Business Account';
      case 'Admin':
        return 'Administrator';
      default:
        return role;
    }
  }

  /// Get role icon
  IconData getRoleIcon(String role) {
    switch (role) {
      case 'Pet Owner':
        return Icons.pets;
      case 'Business':
        return Icons.business;
      case 'Admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  /// Check if current role is Pet Owner
  bool get isPetOwner => _currentRole == 'Pet Owner';

  /// Check if current role is Business
  bool get isBusiness => _currentRole == 'Business';

  /// Check if current role is Admin
  bool get isAdmin => _currentRole == 'Admin';

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  /// Clear all role data (for logout)
  void clearRoleData() {
    _currentRole = null;
    _availableRoles = [];
    _hasMultipleRoles = false;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Get formatted role information for display
  Map<String, dynamic> getRoleDisplayInfo() {
    return {
      'currentRole': _currentRole,
      'currentRoleDisplay':
          _currentRole != null ? getRoleDisplayName(_currentRole!) : 'Unknown',
      'currentRoleIcon':
          _currentRole != null ? getRoleIcon(_currentRole!) : Icons.person,
      'availableRoles': _availableRoles
          .map((role) => {
                'role': role,
                'display': getRoleDisplayName(role),
                'icon': getRoleIcon(role),
                'isCurrent': role == _currentRole,
              })
          .toList(),
      'canSwitch': canSwitchRoles,
      'hasMultiple': _hasMultipleRoles,
    };
  }
}
