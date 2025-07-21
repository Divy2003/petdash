import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/utlis/constants/image_strings.dart';

import '../../../../../../utlis/constants/colors.dart';

class CurvedHeaderWidget extends StatelessWidget {
  const CurvedHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top curve with image background
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.store1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // App bar items (back + title + rating)
          Positioned(
            top: 50.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_outlined, color: AppColors.secondary),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Pet Patch USA",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                          color: AppColors.secondary),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        "4.5",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // Circular logo on bottom-left of white curve
          Positioned(
            top: 150,
            left: 20,
            child: Container(
              height: 64.w,
              width: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Image.asset(
                  AppImages.storeLogo1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for top curve
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
