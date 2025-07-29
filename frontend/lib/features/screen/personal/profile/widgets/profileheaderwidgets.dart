import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String location;
  final String imagePath;
  final VoidCallback? onEdit;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.location,
    required this.imagePath,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background
        Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cart,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
        ),

        // Background Foot Images
        Positioned(child: Image.asset(AppImages.foot1)),
        Positioned(top: 5.h, right: 60.w, child: Image.asset(AppImages.foot2)),
        Positioned(top: 0.h, right: 0.w, child: Image.asset(AppImages.foot3)),

        // Profile Image
        Positioned(
          left: 20.w,
          top: 80.h,
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 5.w),
              image: DecorationImage(
                image: imagePath.startsWith('http')
                    ? NetworkImage(imagePath) as ImageProvider
                    : AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Name & Location
        Positioned(
          top: 80.h,
          left: 135.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit,
                          size: AppSizes.iconSm, color: AppColors.white),
                    ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: AppSizes.iconSm, color: AppColors.white),
                  SizedBox(width: 5.w),
                  Text(
                    location,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
