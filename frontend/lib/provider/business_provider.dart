import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business_model.dart';
import '../models/category_model.dart';
import '../services/BusinessServices/business_service.dart';
import '../utlis/constants/image_strings.dart';

class BusinessProvider with ChangeNotifier {
  List<BusinessModel> _businesses = [];
  bool _isLoading = false;
  String? _error;
  CategoryModel? _selectedCategory;

  // Getters
  List<BusinessModel> get businesses => _businesses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasBusinesses => _businesses.isNotEmpty;
  CategoryModel? get selectedCategory => _selectedCategory;

  // Load businesses by category
  Future<void> loadBusinessesByCategory(
    CategoryModel category, {
    int page = 1,
    int limit = 10,
    String? city,
    String? state,
    String? zipCode,
  }) async {
    if (_isLoading) return; // Prevent multiple simultaneous calls

    _setLoading(true);
    _setError(null);
    _selectedCategory = category;

    try {
      print(
          '🔍 BusinessProvider: Calling API for category ${category.name} (${category.id})');
      print(
          '📊 BusinessProvider: Parameters - page: $page, limit: $limit, city: $city, state: $state, zipCode: $zipCode');

      final businesses = await BusinessService.getBusinessesByCategory(
        category.id,
        page: page,
        limit: limit,
        city: city,
        state: state,
        zipCode: zipCode,
      );

      print(
          '📥 BusinessProvider: API returned ${businesses.length} businesses');
      _businesses = businesses;

      // If no businesses found, provide helpful context
      if (_businesses.isEmpty) {
        print(
            '⚠️ BusinessProvider: No businesses found for category: ${category.name}');
        print('💡 BusinessProvider: This could mean:');
        print('   - No businesses have registered for this category yet');
        print('   - Business profiles are still being processed');
        print('   - There might be a data synchronization issue');
        // Don't set this as an error, just log it
      } else {
        print(
            '✅ BusinessProvider: Successfully loaded ${_businesses.length} businesses');
        for (int i = 0; i < _businesses.length; i++) {
          final business = _businesses[i];
          print('   ${i + 1}. ${business.name} - Active: ${business.isActive}');
        }
      }

      notifyListeners();
    } catch (e) {
      String errorMessage = e.toString();

      // Provide more specific error messages
      if (errorMessage.contains('401') ||
          errorMessage.contains('Authentication')) {
        _setError(
            'Authentication failed. Please log in again to view businesses.');
      } else if (errorMessage.contains('Network') ||
          errorMessage.contains('Connection')) {
        _setError(
            'Network connection error. Please check your internet connection.');
      } else if (errorMessage.contains('timeout')) {
        _setError('Request timed out. Please try again.');
      } else {
        _setError(
            'Unable to load businesses at this time. Please try again later.');
      }
    } finally {
      _setLoading(false);
    }
  }

  // Search businesses
  Future<void> searchBusinesses({
    String? query,
    String? category,
    String? city,
    String? state,
    String? zipCode,
    int page = 1,
    int limit = 10,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    _setError(null);

    try {
      final businesses = await BusinessService.searchBusinesses(
        query: query,
        category: category,
        city: city,
        state: state,
        zipCode: zipCode,
        page: page,
        limit: limit,
      );
      _businesses = businesses;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Get business profile
  Future<BusinessModel?> getBusinessProfile(String businessId) async {
    try {
      return await BusinessService.getBusinessProfile(businessId);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  // Refresh businesses
  Future<void> refreshBusinesses() async {
    if (_selectedCategory != null) {
      await loadBusinessesByCategory(_selectedCategory!);
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Clear businesses
  void clearBusinesses() {
    _businesses.clear();
    _selectedCategory = null;
    notifyListeners();
  }

  // Load all businesses with complete profiles (for testing/debugging)
  Future<void> loadAllBusinessesWithProfiles({
    int page = 1,
    int limit = 10,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    _setError(null);
    _selectedCategory = null;

    try {
      final businesses = await BusinessService.getAllBusinessesWithProfiles(
        page: page,
        limit: limit,
      );
      _businesses = businesses;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Check if current user is a business owner
  Future<bool> isCurrentUserBusiness() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('user_type');
      return userType?.toLowerCase() == 'business';
    } catch (e) {
      return false;
    }
  }

  // Get fallback businesses if API fails
  List<Map<String, dynamic>> getFallbackBusinesses() {
    return [
      {
        'name': 'Plush Paws',
        'distance': '.03 miles away',
        'rating': 5.0,
        'image': AppImages.store1,
        'logo': AppImages.storeLogo1,
        'openTime': 'Open at 8 AM–10PM',
      },
      {
        'name': 'Mr.aladyn',
        'distance': '25 miles away',
        'rating': 4.9,
        'image': AppImages.store1,
        'logo': AppImages.storeLogo1,
        'openTime': 'Open at 9 AM–9PM',
      },
      {
        'name': 'Pet Patch USA',
        'distance': '1 mile away',
        'rating': 4.7,
        'image': AppImages.store1,
        'logo': AppImages.storeLogo1,
        'openTime': 'Open at 10 AM–8PM',
      },
      {
        'name': 'Petido',
        'distance': '1.5 miles away',
        'rating': 4.6,
        'image': AppImages.store1,
        'logo': AppImages.storeLogo1,
        'openTime': 'Open at 8 AM–10PM',
      },
    ];
  }

  // Force refresh with cache bypass
  Future<void> forceRefreshBusinesses() async {
    _businesses.clear();
    if (_selectedCategory != null) {
      await loadBusinessesByCategory(_selectedCategory!);
    }
  }
}
