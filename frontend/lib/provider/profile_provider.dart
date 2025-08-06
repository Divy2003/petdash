import 'dart:io';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/BusinessServices/profile_service.dart';
import '../services/BusinessServices/address_service.dart';
import '../services/BusinessServices/review_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;
  List<AddressModel> _addresses = [];
  Map<String, dynamic> _businessRating = {
    'averageRating': 0.0,
    'totalReviews': 0,
  };

  // Getters
  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AddressModel> get addresses => _addresses;
  Map<String, dynamic> get businessRating => _businessRating;

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
    String? addressLabel,
    String? streetName,
    String? city,
    String? state,
    String? zipCode,
    String? country,
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
        addressLabel: addressLabel,
        streetName: streetName,
        city: city,
        state: state,
        zipCode: zipCode,
        country: country,
      );

      _profile = updatedProfile;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get user addresses
  Future<void> getUserAddresses() async {
    _setLoading(true);
    _setError(null);

    try {
      final addresses = await AddressService.getUserAddresses();
      _addresses = addresses;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add new address
  Future<void> addAddress({
    required String label,
    required String streetName,
    required String city,
    required String state,
    required String zipCode,
    String? country,
    bool isPrimary = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final newAddress = await AddressService.addAddress(
        label: label,
        streetName: streetName,
        city: city,
        state: state,
        zipCode: zipCode,
        country: country,
        isPrimary: isPrimary,
      );

      if (newAddress != null) {
        _addresses.add(newAddress);
        // Refresh profile to get updated primary address
        await getProfile();
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Set address as primary
  Future<void> setPrimaryAddress(String addressId) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await AddressService.setPrimaryAddress(addressId);
      if (success) {
        // Refresh addresses and profile
        await getUserAddresses();
        await getProfile();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get business rating
  Future<void> getBusinessRating() async {
    try {
      final ratingData = await ReviewService.getMyBusinessRating();
      _businessRating = ratingData['ratingStats'] ?? {
        'averageRating': 0.0,
        'totalReviews': 0,
      };
      notifyListeners();
    } catch (e) {
      print('Failed to fetch business rating: $e');
      // Don't set error for rating fetch failure as it's not critical
    }
  }

  // Clear profile data
  void clearProfile() {
    _profile = null;
    _error = null;
    _isLoading = false;
    _addresses = [];
    _businessRating = {
      'averageRating': 0.0,
      'totalReviews': 0,
    };
    notifyListeners();
  }
}
