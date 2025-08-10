import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../utlis/helpers/image_helper.dart';

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

  Widget _buildProfileImage(String imagePath) {
    // Check if it's already a full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImages.person,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.white.withValues(alpha: 0.8),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          );
        },
      );
    }
    // Check if it's a valid asset path
    else if (imagePath.startsWith('assets/') || imagePath.contains('assets')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImages.person,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      );
    }
    // If it looks like an upload path, construct the full URL using ImageHelper
    else if (imagePath.contains('uploads/') ||
        imagePath.contains('.jpg') ||
        imagePath.contains('.png') ||
        imagePath.contains('.jpeg')) {
      final fullUrl = ImageHelper.getImageUrl(imagePath);
      if (fullUrl.isNotEmpty) {
        return Image.network(
          fullUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              AppImages.person,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.white.withValues(alpha: 0.8),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        );
      } else {
        return Image.asset(
          AppImages.person,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }
    // Default fallback
    else {
      return Image.asset(
        imagePath.isNotEmpty ? imagePath : AppImages.person,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            AppImages.person,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      );
    }
  }

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
            ),
            child: ClipOval(
              child: _buildProfileImage(imagePath),
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
              if (location.trim().isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: AppSizes.iconSm, color: AppColors.white),
                    SizedBox(width: 5.w),
                    Text(
                      location,
                      overflow: TextOverflow.ellipsis,
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
