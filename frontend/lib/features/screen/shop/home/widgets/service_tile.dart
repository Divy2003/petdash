import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';

class ServiceTile extends StatelessWidget {
  final String title;
  final Color color;
  final String iconPath;
  final bool isNetwork;

  const ServiceTile({
    super.key,
    required this.title,
    required this.color,
    required this.iconPath,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isNetwork
              ? Image.network(
            iconPath,
            height: 60.h,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 60.h),
          )
              : Image.asset(
            iconPath,
            height: 60.h,
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
