import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/size.dart';
import '../../../provider/location_provider.dart';
import 'google_map_screen.dart';

class AddressTypeSelectionScreen extends StatefulWidget {
  final String? selectedAddress;
  final double? latitude;
  final double? longitude;

  const AddressTypeSelectionScreen({
    super.key,
    this.selectedAddress,
    this.latitude,
    this.longitude,
  });

  @override
  State<AddressTypeSelectionScreen> createState() =>
      _AddressTypeSelectionScreenState();
}

class _AddressTypeSelectionScreenState
    extends State<AddressTypeSelectionScreen> {
  String? selectedType;
  final TextEditingController _nameController = TextEditingController();

  final List<Map<String, dynamic>> addressTypes = [
    {
      'type': 'Home',
      'icon': Icons.home_outlined,
    },
    {
      'type': 'Work',
      'icon': Icons.work_outline,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          'Select Address Type',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Address Display
            if (widget.selectedAddress != null) ...[
              Container(
                padding: EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 20.sp,
                    ),
                    SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        widget.selectedAddress!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.black,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.lg),
            ],

            // Address Type Selection
            Text(
              'Choose address type:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
            ),
            SizedBox(height: AppSizes.md),

            // Address Type Options
            ...addressTypes.map((type) {
              final isSelected = selectedType == type['type'];
              return Container(
                margin: EdgeInsets.only(bottom: AppSizes.sm),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = type['type'];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          type['icon'],
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimaryColor,
                          size: 24.sp,
                        ),
                        SizedBox(width: AppSizes.md),
                        Text(
                          type['type'],
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            SizedBox(height: AppSizes.lg),

            // Name Field (Optional)
            Text(
              'Name (Optional):',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
            ),
            SizedBox(height: AppSizes.sm),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'e.g., Cameron Williamson',
                hintStyle: TextStyle(color: AppColors.textPrimaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                contentPadding: EdgeInsets.all(AppSizes.md),
              ),
            ),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedType != null ? _saveAddress : null,
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
                  'Save Address',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }

  void _saveAddress() {
    if (selectedType == null ||
        widget.selectedAddress == null ||
        widget.latitude == null ||
        widget.longitude == null) {
      return;
    }

    // Save address using LocationProvider
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    locationProvider.addSavedAddress(
      type: selectedType!,
      address: widget.selectedAddress!,
      latitude: widget.latitude!,
      longitude: widget.longitude!,
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      isDefault: true, // First address of this type becomes default
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$selectedType address saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back to the previous screens
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
