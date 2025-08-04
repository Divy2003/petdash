import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/size.dart';
import '../../../../../../provider/location_provider.dart';
import '../../../../location/google_map_screen.dart';
import '../../../../location/address_type_selection_screen.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final savedAddresses = locationProvider.savedAddresses;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.black,
                size: AppSizes.iconMd,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Manage address',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: EdgeInsets.all(AppSizes.md),
            child: Column(
              children: [
                // Add New Address Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GoogleMapScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add New Address',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),

                SizedBox(height: AppSizes.lg),

                // Saved Addresses List
                Expanded(
                  child: savedAddresses.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: savedAddresses.length,
                          itemBuilder: (context, index) {
                            final address = savedAddresses[index];
                            return _buildAddressCard(address, index);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    return GestureDetector(
      onTap: () {
        // Handle address selection
        Get.snackbar(
          "Success",
          'Selected ${address['type']} address',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.md),
        padding: EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Type and Default Badge
            Row(
              children: [
                Icon(
                  address['type'] == 'Home'
                      ? Icons.home_outlined
                      : Icons.work_outline,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  address['type'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                ),
                if (address['isDefault']) ...[
                  SizedBox(width: AppSizes.sm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'Default',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ],
            ),

            SizedBox(height: AppSizes.sm),

            // Name
            Text(
              address['name'],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
            ),

            SizedBox(height: 4.h),

            // Address
            Text(
              address['address'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimaryColor,
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 64.sp,
            color: AppColors.textPrimaryColor,
          ),
          SizedBox(height: AppSizes.lg),
          Text(
            'No saved addresses',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            'Add your first address by tapping\n"Add New Address" above',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.xl),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GoogleMapScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.add_location_outlined,
              color: AppColors.primary,
            ),
            label: Text(
              'Add Address',
              style: TextStyle(color: AppColors.primary),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
                vertical: AppSizes.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
