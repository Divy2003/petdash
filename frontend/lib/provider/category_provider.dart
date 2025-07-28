import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCategories => _categories.isNotEmpty;

  // Load categories from API
  Future<void> loadCategories() async {
    if (_isLoading) return; // Prevent multiple simultaneous calls

    _setLoading(true);
    _setError(null);

    try {
      final categories = await CategoryService.getPublicCategories();
      _categories = categories;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Refresh categories
  Future<void> refreshCategories() async {
    _categories.clear();
    await loadCategories();
  }

  // Get category by ID
  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get category by name
  CategoryModel? getCategoryByName(String name) {
    try {
      return _categories.firstWhere(
        (category) => category.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
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

  // Get fallback categories if API fails
  List<Map<String, dynamic>> getFallbackCategories() {
    return [
      {
        'title': 'Sitting',
        'color': const Color(0x807DC1CF),
        'icon': 'assets/homeimage/sitting.png',
      },
      {
        'title': 'Health',
        'color': const Color(0xA31976D2),
        'icon': 'assets/homeimage/health.png',
      },
      {
        'title': 'Boarding',
        'color': const Color(0x80F0546C),
        'icon': 'assets/homeimage/boarding.png',
      },
      {
        'title': 'Training',
        'color': const Color(0x80FFC107),
        'icon': 'assets/homeimage/traning.png',
      },
      {
        'title': 'Grooming',
        'color': const Color(0x99FFC107),
        'icon': 'assets/homeimage/groming.png',
      },
      {
        'title': 'Walking',
        'color': const Color(0x804CD964),
        'icon': 'assets/homeimage/walking.png',
      },
    ];
  }
}
