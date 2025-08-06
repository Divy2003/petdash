import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/Button/primarybutton.dart';
import '../../common/widgets/progessIndicator/threedotindicator.dart';
import '../../utlis/constants/size.dart';
import '../../utlis/constants/colors.dart';
import '../../utlis/app_config/app_config.dart';
import '../screen/business/widgets/custom_text_field.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isLoading = false;
  bool _isSearching = false;
  GoogleMapController? _mapController;
  LatLng _currentLocation = const LatLng(20.5937, 78.9629); // Default to India center
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _countryController.text = 'USA';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required',
            backgroundColor: AppColors.error,
            colorText: AppColors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Location permission is permanently denied',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _streetController.text = '${place.street ?? ''} ${place.subThoroughfare ?? ''}'.trim();
          _cityController.text = place.locality ?? '';
          _stateController.text = place.administrativeArea ?? '';
          _zipController.text = place.postalCode ?? '';
          _countryController.text = place.country ?? 'India';

          _currentLocation = LatLng(position.latitude, position.longitude);
          _markers = {
            Marker(
              markerId: const MarkerId('current_location'),
              position: _currentLocation,
              infoWindow: const InfoWindow(title: 'Current Location'),
            ),
          };
        });

        // Move map to current location
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_currentLocation, 15),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get current location: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      // Use Google Places API for better search results
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(_searchController.text)}&key=${AppConfig.googleMapsApiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          final result = data['results'][0];
          final geometry = result['geometry']['location'];
          final lat = geometry['lat'];
          final lng = geometry['lng'];

          // Update map location
          setState(() {
            _currentLocation = LatLng(lat, lng);
            _markers = {
              Marker(
                markerId: const MarkerId('searched_location'),
                position: _currentLocation,
                infoWindow: InfoWindow(title: _searchController.text),
              ),
            };
          });

          // Move map camera
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(_currentLocation, 15),
            );
          }

          // Parse address components
          await _parseAddressComponents(result['address_components']);
        } else {
          Get.snackbar(
            'Not Found',
            'Location not found. Please try a different search term.',
            backgroundColor: AppColors.warning,
            colorText: AppColors.white,
          );
        }
      } else {
        throw Exception('Failed to search location');
      }
    } catch (e) {
      // Fallback to geocoding
      try {
        List<Location> locations = await locationFromAddress(_searchController.text);

        if (locations.isNotEmpty) {
          Location location = locations.first;

          setState(() {
            _currentLocation = LatLng(location.latitude, location.longitude);
            _markers = {
              Marker(
                markerId: const MarkerId('searched_location'),
                position: _currentLocation,
                infoWindow: InfoWindow(title: _searchController.text),
              ),
            };
          });

          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(_currentLocation, 15),
            );
          }

          // Get address details from coordinates
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            setState(() {
              _streetController.text = '${place.street ?? ''} ${place.subThoroughfare ?? ''}'.trim();
              _cityController.text = place.locality ?? '';
              _stateController.text = place.administrativeArea ?? '';
              _zipController.text = place.postalCode ?? '';
              _countryController.text = place.country ?? 'India';
            });
          }
        } else {
          Get.snackbar(
            'Not Found',
            'Location not found. Please try a different search term.',
            backgroundColor: AppColors.warning,
            colorText: AppColors.white,
          );
        }
      } catch (fallbackError) {
        Get.snackbar(
          'Error',
          'Failed to search location: ${fallbackError.toString()}',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
      }
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _parseAddressComponents(List<dynamic> components) async {
    String street = '';
    String city = '';
    String state = '';
    String zipCode = '';
    String country = '';

    for (var component in components) {
      final types = List<String>.from(component['types']);
      final longName = component['long_name'];

      if (types.contains('street_number') || types.contains('route')) {
        street += '$longName ';
      } else if (types.contains('locality') || types.contains('administrative_area_level_2')) {
        city = longName;
      } else if (types.contains('administrative_area_level_1')) {
        state = longName;
      } else if (types.contains('postal_code')) {
        zipCode = longName;
      } else if (types.contains('country')) {
        country = longName;
      }
    }

    setState(() {
      _streetController.text = street.trim();
      _cityController.text = city;
      _stateController.text = state;
      _zipController.text = zipCode;
      _countryController.text = country.isNotEmpty ? country : 'India';
    });
  }

  void _onMapTapped(LatLng location) async {
    setState(() {
      _currentLocation = location;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: location,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      };
    });

    // Get address from coordinates
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _streetController.text = '${place.street ?? ''} ${place.subThoroughfare ?? ''}'.trim();
          _cityController.text = place.locality ?? '';
          _stateController.text = place.administrativeArea ?? '';
          _zipController.text = place.postalCode ?? '';
          _countryController.text = place.country ?? 'India';
        });
      }
    } catch (e) {
      print('Error getting address from coordinates: $e');
    }
  }

  void _confirmLocation() {
    if (_streetController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _stateController.text.trim().isEmpty ||
        _zipController.text.trim().isEmpty) {
      Get.snackbar(
        'Incomplete Address',
        'Please fill in all address fields',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return;
    }

    // Return the address data
    Get.back(result: {
      'streetName': _streetController.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'zipCode': _zipController.text.trim(),
      'country': _countryController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pick Location'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Text(
              'Search Location',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Address',
                      hintText: 'Enter address, city, or landmark',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                ),
                SizedBox(width: AppSizes.sm),
                IconButton(
                  onPressed: _isSearching ? null : _searchLocation,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: ThreeDotIndicator(),
                        )
                      : Icon(
                          Icons.search,
                          color: AppColors.primary,
                        ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            // Current Location Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _getCurrentLocation,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: ThreeDotIndicator(),
                      )
                    : Icon(Icons.my_location, color: AppColors.primary),
                label: Text(
                  _isLoading ? 'Getting Location...' : 'Use Current Location',
                  style: TextStyle(color: AppColors.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceBtwSections),

            // Google Map Section
            Text(
              'Select Location on Map',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation,
                    zoom: 10,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  onTap: _onMapTapped,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceBtwSections),

            // Address Details Section
            Text(
              'Address Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            // Street Address
            CustomTextField(
              label: 'Street Address',
              controller: _streetController,
              hintText: 'Enter street address',
            ),
            SizedBox(height: AppSizes.spaceBtwInputFields),

            // City and State
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    label: 'City',
                    controller: _cityController,
                    hintText: 'Enter city',
                  ),
                ),
                SizedBox(width: AppSizes.spaceBtwInputFields),
                Expanded(
                  child: CustomTextField(
                    label: 'State',
                    controller: _stateController,
                    hintText: 'State',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceBtwInputFields),

            // ZIP and Country
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'ZIP Code',
                    controller: _zipController,
                    hintText: 'ZIP Code',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: AppSizes.spaceBtwInputFields),
                Expanded(
                  child: CustomTextField(
                    label: 'Country',
                    controller: _countryController,
                    hintText: 'Country',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.spaceBtwSections),

            // Confirm Button
            PrimaryButton(
              title: 'Confirm Location',
              onPressed: _confirmLocation,
            ),
          ],
        ),
      ),
    );
  }
}
