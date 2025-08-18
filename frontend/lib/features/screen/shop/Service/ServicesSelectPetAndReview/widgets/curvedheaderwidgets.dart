import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/utlis/constants/image_strings.dart';

import '../../../../../../models/business_model.dart';

class CurvedHeaderWidget extends StatelessWidget {
  final BusinessModel? businessProfile;


  const CurvedHeaderWidget({
    super.key,
    this.businessProfile,
  });

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
                  image: businessProfile?.profileImage != null
                      ? NetworkImage(businessProfile!.profileImage!)
                      : AssetImage(AppImages.store1) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // App bar items (back + title + rating)

          // Circular logo on bottom-left of white curve
          Positioned(
            top: 150,
            left: 20,
            child: Container(
              height: 64.w,
              width: 64.w,
              decoration: BoxDecoration(

                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: businessProfile?.shopImage != null
                    ? Image.network(
                        businessProfile!.shopImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.storeLogo1,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
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
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
