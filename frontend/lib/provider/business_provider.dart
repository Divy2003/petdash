import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../models/category_model.dart';
import '../services/business_service.dart';

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
      final businesses = await BusinessService.getBusinessesByCategory(
        category.id,
        page: page,
        limit: limit,
        city: city,
        state: state,
        zipCode: zipCode,
      );
      _businesses = businesses;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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

  // Get fallback businesses if API fails
  List<Map<String, dynamic>> getFallbackBusinesses() {
    return [
      {
        'name': 'Plush Paws',
        'distance': '.03 miles away',
        'rating': 5.0,
        'image': 'assets/images/stores/store1.png',
        'logo': 'assets/images/stores/logo1.png',
        'openTime': 'Open at 8 AM–10PM',
      },
      {
        'name': 'Mr.aladyn',
        'distance': '25 miles away',
        'rating': 4.9,
        'image': 'assets/images/stores/store2.png',
        'logo': 'assets/images/stores/logo2.png',
        'openTime': 'Open at 9 AM–9PM',
      },
      {
        'name': 'Pet Patch USA',
        'distance': '1 mile away',
        'rating': 4.7,
        'image': 'assets/images/stores/store1.png',
        'logo': 'assets/images/stores/logo1.png',
        'openTime': 'Open at 10 AM–8PM',
      },
      {
        'name': 'Petido',
        'distance': '1.5 miles away',
        'rating': 4.6,
        'image': 'assets/images/stores/store2.png',
        'logo': 'assets/images/stores/logo2.png',
        'openTime': 'Open at 8 AM–10PM',
      },
    ];
  }
}
