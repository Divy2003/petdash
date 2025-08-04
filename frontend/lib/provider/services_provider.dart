import 'dart:io';
import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/BusinessServices/service_api_service.dart';

class ServicesProvider with ChangeNotifier {
  List<ServiceModel> _services = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  String? _error;
  ServiceModel? _selectedService;

  // Additional state for better UX
  bool _hasInitialized = false;
  String? _lastRefreshTime;
  Map<String, bool> _deletingServices = {}; // Track individual service deletion states

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  String? get error => _error;
  bool get hasServices => _services.isNotEmpty;
  ServiceModel? get selectedService => _selectedService;
  bool get hasInitialized => _hasInitialized;
  String? get lastRefreshTime => _lastRefreshTime;

  // Check if a specific service is being deleted
  bool isServiceDeleting(String serviceId) => _deletingServices[serviceId] ?? false;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setCreating(bool value) {
    _isCreating = value;
    notifyListeners();
  }

  void _setUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }

  void _setDeleting(bool value) {
    _isDeleting = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setServiceDeleting(String serviceId, bool value) {
    _deletingServices[serviceId] = value;
    notifyListeners();
  }

  void _updateLastRefreshTime() {
    _lastRefreshTime = DateTime.now().toString();
  }

  // Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reset all state
  void reset() {
    _services.clear();
    _isLoading = false;
    _isCreating = false;
    _isUpdating = false;
    _isDeleting = false;
    _error = null;
    _selectedService = null;
    _hasInitialized = false;
    _lastRefreshTime = null;
    _deletingServices.clear();
    notifyListeners();
  }

  Future<void> loadBusinessServices({int page = 1, int limit = 10, String? category, bool refresh = false}) async {
    if (_isLoading && !refresh) return;
    _setLoading(true);
    _setError(null);
    try {
      final services = await ServiceApiService.getBusinessServices(
        page: page,
        limit: limit,
        category: category,
      );
      if (refresh || page == 1) {
        _services = services;
      } else {
        _services.addAll(services);
      }
      _hasInitialized = true;
      _updateLastRefreshTime();
      notifyListeners();
    } catch (e) {
      String errorMessage = e.toString();

      // Handle authentication errors specifically
      if (errorMessage.contains('401') ||
          errorMessage.contains('Authentication failed') ||
          errorMessage.contains('Invalid token')) {
        errorMessage = 'Authentication failed. Please log in again.';
      }

      _setError(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  // Initialize services if not already loaded
  Future<void> initializeIfNeeded() async {
    if (!_hasInitialized && !_isLoading) {
      await loadBusinessServices();
    }
  }

  // Refresh services
  Future<void> refreshServices() async {
    await loadBusinessServices(refresh: true);
  }

  Future<void> getServiceById(String serviceId) async {
    try {
      _setLoading(true);
      _setError(null);
      final service = await ServiceApiService.getServiceById(serviceId);
      _selectedService = service;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createService(ServiceRequest serviceRequest, {List<File>? imageFiles}) async {
    try {
      _setCreating(true);
      _setError(null);
      final newService = await ServiceApiService.createService(serviceRequest, imageFiles: imageFiles);
      _services.insert(0, newService);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setCreating(false);
    }
  }

  Future<bool> updateService(String serviceId, ServiceRequest serviceRequest, {List<File>? imageFiles}) async {
    try {
      _setUpdating(true);
      _setError(null);
      final updatedService = await ServiceApiService.updateService(serviceId, serviceRequest, imageFiles: imageFiles);
      final index = _services.indexWhere((service) => service.id == serviceId);
      if (index != -1) {
        _services[index] = updatedService;
        notifyListeners();
      }
      if (_selectedService?.id == serviceId) {
        _selectedService = updatedService;
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  Future<bool> deleteService(String serviceId) async {
    try {
      _setServiceDeleting(serviceId, true);
      _setError(null);
      final success = await ServiceApiService.deleteService(serviceId);
      if (success) {
        _services.removeWhere((service) => service.id == serviceId);
        if (_selectedService?.id == serviceId) {
          _selectedService = null;
        }
        _deletingServices.remove(serviceId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setServiceDeleting(serviceId, false);
    }
  }

  void clearSelectedService() {
    _selectedService = null;
    notifyListeners();
  }

  ServiceModel? getServiceByIndex(int index) {
    if (index >= 0 && index < _services.length) return _services[index];
    return null;
  }

  List<ServiceModel> searchServices(String query) {
    if (query.isEmpty) return _services;
    final lowercaseQuery = query.toLowerCase();
    return _services.where((service) {
      return service.title.toLowerCase().contains(lowercaseQuery) ||
          (service.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (service.category?.name.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  List<ServiceModel> filterByCategory(String categoryId) {
    return _services.where((service) => service.categoryId == categoryId).toList();
  }

  List<ServiceModel> get activeServices {
    return _services.where((service) => service.isActive).toList();
  }
}
