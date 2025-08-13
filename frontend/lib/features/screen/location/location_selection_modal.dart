import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/size.dart';
import '../../../provider/location_provider.dart';
import 'google_map_screen.dart';

class LocationSelectionModal extends StatefulWidget {
  const LocationSelectionModal({super.key});

  @override
  State<LocationSelectionModal> createState() => _LocationSelectionModalState();
}

class _LocationSelectionModalState extends State<LocationSelectionModal> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final savedAddresses = locationProvider.savedAddresses;

        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.md),
                    Text(
                      'Choose Your Location',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      'Select a delivery location to see product availability and delivery options',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimaryColor,
                          ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSizes.sm),

              // Address List
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // // Show saved addresses only if they exist
                      // if (savedAddresses.isNotEmpty)
                      //   _buildAddressList(savedAddresses),

                      // // Show empty state if no addresses
                      // if (savedAddresses.isEmpty)
                      //   Container(
                      //     padding: EdgeInsets.all(AppSizes.lg),
                      //     child: Column(
                      //       children: [
                      //         Icon(
                      //           Icons.location_off_outlined,
                      //           size: 48.sp,
                      //           color: AppColors.textPrimaryColor,
                      //         ),
                      //         SizedBox(height: AppSizes.md),
                      //         Text(
                      //           'No saved addresses',
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .titleMedium
                      //               ?.copyWith(
                      //                 color: AppColors.textPrimaryColor,
                      //                 fontWeight: FontWeight.w500,
                      //               ),
                      //         ),
                      //         SizedBox(height: AppSizes.sm),
                      //         Text(
                      //           'Add your first address to get started',
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .bodyMedium
                      //               ?.copyWith(
                      //                 color: AppColors.textPrimaryColor,
                      //               ),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       ],
                      //     ),
                      //   ),

                      // Use my current location
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: AppSizes.md),
                        child: ListTile(
                          leading: Icon(
                            Icons.my_location,
                            color: AppColors.primary,
                            size: AppSizes.iconMd,
                          ),
                          title: Text(
                            'Use my current location',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: AppColors.textPrimaryColor,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const GoogleMapScreen(),
                              ),
                            );
                          },
                        ),
                      ),

                      // Add New Address
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: AppSizes.md),
                        child: ListTile(
                          leading: Icon(
                            Icons.add,
                            color: Colors.red,
                            size: AppSizes.iconMd,
                          ),
                          title: Text(
                            'Add New Address',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: AppColors.textPrimaryColor,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const GoogleMapScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressList(List<Map<String, dynamic>> savedAddresses) {
    return Column(
      children: savedAddresses.map((address) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 4.h),
          child: ListTile(
            leading: Icon(
              address['type'] == 'Home'
                  ? Icons.home_outlined
                  : Icons.work_outline,
              color: AppColors.primary,
              size: 20.sp,
            ),
            title: Row(
              children: [
                Text(
                  address['type'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                ),
                if (address['isDefault']) ...[
                  SizedBox(width: AppSizes.sm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'Default',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(
              address['subtitle']!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimaryColor,
                  ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.textPrimaryColor,
            ),
            onTap: () async {
              // Persist selected address text and close modal
              await Provider.of<LocationProvider>(context, listen: false)
                  .setSelectedAddressText(address['subtitle'] ?? address['title'] ?? '');
              Navigator.of(context).pop();
              Get.snackbar(
                "Success",
                'Selected: ${address['type']} - ${address['title']}',
                backgroundColor: AppColors.success,
                colorText: AppColors.white,
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
