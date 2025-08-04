import 'dart:io';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/BusinessServices/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  // Getters
  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Get user profile
  Future<void> getProfile() async {
    _setLoading(true);
    _setError(null);

    try {
      final profile = await ProfileService.getProfile();
      _profile = profile;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    String? shopOpenTime,
    String? shopCloseTime,
    File? profileImageFile,
    File? shopImageFile,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedProfile = await ProfileService.updateProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        shopOpenTime: shopOpenTime,
        shopCloseTime: shopCloseTime,
        profileImageFile: profileImageFile,
        shopImageFile: shopImageFile,
      );

      _profile = updatedProfile;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Clear profile data
  void clearProfile() {
    _profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
