import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../utlis/constants/size.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../common/widgets/progessIndicator/threedotindicator.dart';
import '../../../../services/location_service.dart';
import '../../../location/location_picker_screen.dart';
import 'custom_text_field.dart';

class AddressSelectionWidget extends StatefulWidget {
  final String? initialStreetName;
  final String? initialCity;
  final String? initialState;
  final String? initialZipCode;
  final String? initialCountry;
  final Function(Map<String, String>) onAddressChanged;

  const AddressSelectionWidget({
    super.key,
    this.initialStreetName,
    this.initialCity,
    this.initialState,
    this.initialZipCode,
    this.initialCountry,
    required this.onAddressChanged,
  });

  @override
  State<AddressSelectionWidget> createState() => _AddressSelectionWidgetState();
}

class _AddressSelectionWidgetState extends State<AddressSelectionWidget> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _streetController.text = widget.initialStreetName ?? '';
    _cityController.text = widget.initialCity ?? '';
    _stateController.text = widget.initialState ?? '';
    _zipController.text = widget.initialZipCode ?? '';
    _countryController.text = widget.initialCountry ?? 'USA';

    // Add listeners to notify parent of changes
    _streetController.addListener(_notifyAddressChange);
    _cityController.addListener(_notifyAddressChange);
    _stateController.addListener(_notifyAddressChange);
    _zipController.addListener(_notifyAddressChange);
    _countryController.addListener(_notifyAddressChange);
  }

  void _notifyAddressChange() {
    widget.onAddressChanged({
      'streetName': _streetController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zipCode': _zipController.text,
      'country': _countryController.text,
    });
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to get current address',
            backgroundColor: AppColors.error,
            colorText: AppColors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Location permission is permanently denied. Please enable it in settings.',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      // Get current position using LocationService
      Position? position = await LocationService.getCurrentLocation();

      if (position != null) {
        // Get address from coordinates using Google API
        Map<String, String>? address = await LocationService.getAddressFromCoordinates(
          lat: position.latitude,
          lng: position.longitude,
        );

        if (address != null) {
          setState(() {
            _streetController.text = address['streetName'] ?? '';
            _cityController.text = address['city'] ?? '';
            _stateController.text = address['state'] ?? '';
            _zipController.text = address['zipCode'] ?? '';
            _countryController.text = address['country'] ?? 'India';
          });

          _notifyAddressChange();

          Get.snackbar(
            'Success',
            'Current location address loaded successfully',
            backgroundColor: AppColors.success,
            colorText: AppColors.white,
          );
        } else {
          // Fallback to geocoding
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
            });

            _notifyAddressChange();

            Get.snackbar(
              'Success',
              'Current location address loaded successfully',
              backgroundColor: AppColors.success,
              colorText: AppColors.white,
            );
          }
        }
      } else {
        Get.snackbar(
          'Error',
          'Unable to get current location. Please check permissions.',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
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
        _isLoadingLocation = false;
      });
    }
  }

  void _openLocationPicker() {
    Get.to(() => const LocationPickerScreen())?.then((result) {
      if (result != null && result is Map<String, dynamic>) {
        setState(() {
          _streetController.text = result['streetName'] ?? '';
          _cityController.text = result['city'] ?? '';
          _stateController.text = result['state'] ?? '';
          _zipController.text = result['zipCode'] ?? '';
          _countryController.text = result['country'] ?? 'USA';
        });
        _notifyAddressChange();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Section Header
        Row(
          children: [
            Expanded(
              child: Text(
                'Business Address',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
            ),
            IconButton(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              icon: _isLoadingLocation
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: ThreeDotIndicator(),
                    )
                  : Icon(
                      Icons.my_location,
                      color: AppColors.primary,
                    ),
              tooltip: 'Use current location',
            ),
            IconButton(
              onPressed: _openLocationPicker,
              icon: Icon(
                Icons.map,
                color: AppColors.primary,
              ),
              tooltip: 'Pick from map',
            ),
          ],
        ),
        SizedBox(height: AppSizes.spaceBtwItems),

        // Street Address
        CustomTextField(
          label: 'Street Address',
          controller: _streetController,
          hintText: 'Enter street address',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Street address is required';
            }
            return null;
          },
        ),
        SizedBox(height: AppSizes.spaceBtwInputFields),

        // City and State Row
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'City',
                controller: _cityController,
                hintText: 'Enter city',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: AppSizes.spaceBtwInputFields),
            Expanded(
              child: CustomTextField(
                label: 'State',
                controller: _stateController,
                hintText: 'State',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'State is required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spaceBtwInputFields),

        // ZIP Code and Country Row
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'ZIP Code',
                controller: _zipController,
                hintText: 'ZIP Code',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'ZIP code is required';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: AppSizes.spaceBtwInputFields),
            Expanded(
              child: CustomTextField(
                label: 'Country',
                controller: _countryController,
                hintText: 'Country',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Country is required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
