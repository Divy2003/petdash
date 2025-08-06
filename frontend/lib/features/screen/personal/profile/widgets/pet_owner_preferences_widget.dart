import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../services/location_service.dart';
import '../../../business/widgets/custom_text_field.dart';


class PetOwnerPreferencesWidget extends StatefulWidget {
  final double? initialMaxDistance;
  final String? initialPreferredLocation;
  final Function(Map<String, dynamic>) onPreferencesChanged;

  const PetOwnerPreferencesWidget({
    super.key,
    this.initialMaxDistance,
    this.initialPreferredLocation,
    required this.onPreferencesChanged,
  });

  @override
  State<PetOwnerPreferencesWidget> createState() => _PetOwnerPreferencesWidgetState();
}

class _PetOwnerPreferencesWidgetState extends State<PetOwnerPreferencesWidget> {
  final TextEditingController _locationController = TextEditingController();
  double _maxDistance = 10.0; // Default 10 miles
  bool _useCurrentLocation = true;
  bool _isLoadingLocation = false;

  final List<double> _distanceOptions = [1, 2, 5, 10, 15, 20, 25, 50];

  @override
  void initState() {
    super.initState();
    _maxDistance = widget.initialMaxDistance ?? 10.0;
    _locationController.text = widget.initialPreferredLocation ?? '';
    _notifyChanges();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _notifyChanges() {
    widget.onPreferencesChanged({
      'maxDistance': _maxDistance,
      'preferredLocation': _locationController.text.trim(),
      'useCurrentLocation': _useCurrentLocation,
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        final address = await LocationService.getAddressFromCoordinates(
          lat: position.latitude,
          lng: position.longitude,
        );

        if (address != null) {
          setState(() {
            _locationController.text = address['formattedAddress'] ?? '';
            _useCurrentLocation = true;
          });
          _notifyChanges();

          Get.snackbar(
            'Success',
            'Current location loaded successfully',
            backgroundColor: AppColors.success,
            colorText: AppColors.white,
          );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Search Preferences',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          SizedBox(height: AppSizes.spaceBtwItems),

          // Maximum Distance Section
          Text(
            'Maximum Distance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
          ),
          SizedBox(height: AppSizes.xs),
          
          // Distance Slider
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _maxDistance,
                  min: 1.0,
                  max: 50.0,
                  divisions: 49,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.grey.withValues(alpha: 0.3),
                  onChanged: (value) {
                    setState(() {
                      _maxDistance = value;
                    });
                    _notifyChanges();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                ),
                child: Text(
                  '${_maxDistance.round()} mi',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),

          // Quick Distance Options
          Wrap(
            spacing: AppSizes.xs,
            children: _distanceOptions.map((distance) {
              final isSelected = _maxDistance == distance;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _maxDistance = distance;
                  });
                  _notifyChanges();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                  ),
                  child: Text(
                    '${distance.round()} mi',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? AppColors.white : AppColors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: AppSizes.spaceBtwItems),

          // Preferred Location Section
          Text(
            'Preferred Location',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
          ),
          SizedBox(height: AppSizes.xs),

          // Use Current Location Toggle
          Row(
            children: [
              Switch(
                value: _useCurrentLocation,
                onChanged: (value) {
                  setState(() {
                    _useCurrentLocation = value;
                  });
                  _notifyChanges();
                  
                  if (value) {
                    _getCurrentLocation();
                  }
                },
                activeColor: AppColors.primary,
              ),
              SizedBox(width: AppSizes.xs),
              Expanded(
                child: Text(
                  'Use my current location',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                      ),
                ),
              ),
              if (_isLoadingLocation)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          //  CustomTextField(
          //                   label: 'Search Location',
          //                   controller: _locationController,
          //                   hintText: 'Enter city, area, or address',
          //                   enabled: !_useCurrentLocation,
          //                   onChanged: (value) {
          //                     _notifyChanges();
          //                   },
          //                 ),
          // Manual Location Input
          Row(
            children: [
              Expanded(
                child:TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Search Location',
                    hintText: 'Enter city, area, or address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  enabled: !_useCurrentLocation,
                  onChanged: (value) {
                    _notifyChanges();
                  },
                )
              ),
              SizedBox(width: AppSizes.sm),
              IconButton(
                onPressed: _useCurrentLocation ? null : _getCurrentLocation,
                icon: Icon(
                  Icons.my_location,
                  color: _useCurrentLocation ? AppColors.grey : AppColors.primary,
                ),
                tooltip: 'Use current location',
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),

          // Info Text
          Container(
            padding: EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppSizes.xs),
                Expanded(
                  child: Text(
                    'We\'ll show businesses within ${_maxDistance.round()} miles of your ${_useCurrentLocation ? 'current location' : 'preferred location'}.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
