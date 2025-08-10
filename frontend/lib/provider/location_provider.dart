import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../utlis/app_config/app_config.dart';

import 'package:shared_preferences/shared_preferences.dart';
class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;
  String? _errorMessage;
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedAddress;
  static const _prefsSavedAddressesKey = 'saved_addresses_v1';
  final Set<Marker> _markers = {};
  final List<Map<String, dynamic>> _savedAddresses = [];

  // Getters
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GoogleMapController? get mapController => _mapController;
  LatLng? get selectedLocation => _selectedLocation;
  String? get selectedAddress => _selectedAddress;
  Set<Marker> get markers => _markers;
  List<Map<String, dynamic>> get savedAddresses => _savedAddresses;

  LocationProvider() {
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsSavedAddressesKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> list = json.decode(jsonStr);
        _savedAddresses
          ..clear()
          ..addAll(list.cast<Map<String, dynamic>>());
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _persistSavedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsSavedAddressesKey, json.encode(_savedAddresses));
    } catch (_) {}
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Check and request location permissions
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setError('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setError('Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      _setLoading(true);
      _setError(null);

      if (!await _checkLocationPermission()) {
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _getAddressFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to get current location: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Get address from coordinates
  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentAddress =
            '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
      }
    } catch (e) {
      _setError('Failed to get address: ${e.toString()}');
    }
  }

  // Set selected location on map
  void setSelectedLocation(LatLng location) async {
    _selectedLocation = location;

    // Update marker
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: location,
        infoWindow: const InfoWindow(title: 'Selected Location'),
      ),
    );

    // Get address for selected location
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _selectedAddress =
            '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
      }
    } catch (e) {
      _selectedAddress = 'Address not found';
    }

    notifyListeners();
  }

  // Save business location to backend
  Future<bool> saveBusinessLocation(String token) async {
    if (_selectedLocation == null) {
      _setError('Please select a location first');
      return false;
    }

    try {
      _setLoading(true);
      _setError(null);

      final url = Uri.parse('${AppConfig.baseUrl}/profile/update-location');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = json.encode({
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
        'formattedAddress': _selectedAddress,
      });

      final response = await http.put(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        _setError(responseBody['message'] ?? 'Failed to save location');
        return false;
      }
    } catch (e) {
      _setError('Error saving location: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get nearby businesses
  Future<List<Map<String, dynamic>>> getNearbyBusinesses(String token,
      {double radiusKm = 10}) async {
    if (_currentPosition == null) {
      await getCurrentLocation();
      if (_currentPosition == null) {
        return [];
      }
    }

    try {
      _setLoading(true);
      _setError(null);

      final url = Uri.parse('${AppConfig.baseUrl}/location/nearby-businesses');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = json.encode({
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
        'radius': radiusKm,
      });

      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
            responseBody['businesses'] ?? []);
      } else {
        _setError(responseBody['message'] ?? 'Failed to get nearby businesses');
        return [];
      }
    } catch (e) {
      _setError('Error getting nearby businesses: ${e.toString()}');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Clear selected location
  void clearSelectedLocation() {
    _selectedLocation = null;
    _selectedAddress = null;
    _markers.clear();
    notifyListeners();
  }

  // Reset error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Add new address
  void addSavedAddress({
    required String type,
    required String address,
    required double latitude,
    required double longitude,
    String? name,
    bool isDefault = false,
  }) {
    // If this is set as default, remove default from other addresses of same type
    if (isDefault) {
      for (var addr in _savedAddresses) {
        if (addr['type'] == type) {
          addr['isDefault'] = false;
        }
      }
    }

    _savedAddresses.add({
      'type': type,
      'name': name ?? type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'title': address.split(',').first, // First part of address as title
      'subtitle': address, // Full address as subtitle
    });

    _persistSavedAddresses();

    notifyListeners();
    _persistSavedAddresses();
  }

  // Remove saved address
  void removeSavedAddress(int index) {
    if (index >= 0 && index < _savedAddresses.length) {
      _savedAddresses.removeAt(index);
      notifyListeners();
      _persistSavedAddresses();
    }
  }

  // Set address as default
  void setAddressAsDefault(int index) {
    if (index >= 0 && index < _savedAddresses.length) {
      final selectedAddress = _savedAddresses[index];
      final type = selectedAddress['type'];

      // Remove default from other addresses of same type
      for (var addr in _savedAddresses) {
        if (addr['type'] == type) {
          addr['isDefault'] = false;
        }
      }

      // Set selected address as default
      _savedAddresses[index]['isDefault'] = true;
      notifyListeners();
    }
  }
}
