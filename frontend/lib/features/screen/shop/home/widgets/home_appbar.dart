import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../provider/location_provider.dart';
import '../../../location/location_selection_modal.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppSizes.xl,
        left: AppSizes.md,
        right: AppSizes.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_pin,
                  size: AppSizes.iconMd, color: Colors.black),
              SizedBox(width: AppSizes.sm),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LocationSelectionModal(),
                  );
                },
                child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                    return Text(
                      locationProvider.selectedAddress ??
                          locationProvider.currentAddress ??
                          "My Location",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    );
                  },
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Icon(Icons.notifications_none, size: AppSizes.iconMd),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
