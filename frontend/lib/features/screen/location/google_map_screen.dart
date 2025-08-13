import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../provider/location_provider.dart';
import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/size.dart';
import 'address_type_selection_screen.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key, this.baseUrlOverride});

  final String? baseUrlOverride;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController;
  final LatLng _defaultLocation =
      const LatLng(37.7749, -122.4194); // San Francisco

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  void _getCurrentLocation() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Stack(
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  locationProvider.setMapController(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: locationProvider.currentPosition != null
                      ? LatLng(
                          locationProvider.currentPosition!.latitude,
                          locationProvider.currentPosition!.longitude,
                        )
                      : _defaultLocation,
                  zoom: 15.0,
                ),
                onTap: (LatLng location) {
                  locationProvider.setSelectedLocation(location);
                },
                markers: locationProvider.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),

              // Top App Bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 10.h,
                left: AppSizes.md,
                right: AppSizes.md,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.black,
                          size: AppSizes.iconMd,
                        ),
                      ),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: Text(
                          'Set live location',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // My Location Button
              Positioned(
                right: AppSizes.md,
                bottom: 200.h,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    _getCurrentLocation();
                    if (locationProvider.currentPosition != null) {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(
                            locationProvider.currentPosition!.latitude,
                            locationProvider.currentPosition!.longitude,
                          ),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.my_location,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),

              // Bottom Sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 4.h),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  locationProvider.selectedAddress ??
                                      locationProvider.currentAddress ??
                                      'Select location on map',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.lg),

                      // Add Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: locationProvider.selectedLocation !=
                                      null ||
                                  locationProvider.currentPosition != null
                              ? () {
                                  // Navigate to address type selection
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddressTypeSelectionScreen(
                                        selectedAddress:
                                            locationProvider.selectedAddress ??
                                                locationProvider.currentAddress,
                                        latitude: locationProvider
                                                .selectedLocation?.latitude ??
                                            locationProvider
                                                .currentPosition?.latitude,
                                        longitude: locationProvider
                                                .selectedLocation?.longitude ??
                                            locationProvider
                                                .currentPosition?.longitude,
                                        baseUrlOverride: widget.baseUrlOverride,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding:
                                EdgeInsets.symmetric(vertical: AppSizes.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Add',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),

              // Loading Indicator
              if (locationProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
