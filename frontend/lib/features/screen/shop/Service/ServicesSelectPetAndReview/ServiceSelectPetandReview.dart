import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/features/screen/shop/Service/ServicesSelectPetAndReview/widgets/curvedheaderwidgets.dart';
import 'package:petcare/features/screen/shop/Service/ServicesSelectPetAndReview/widgets/gallerywidgets.dart';
import 'package:petcare/features/screen/shop/Service/ServicesSelectPetAndReview/widgets/reviews.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
class ServiceSelectPetAndReview extends StatefulWidget {
  const ServiceSelectPetAndReview({super.key});

  @override
  State<ServiceSelectPetAndReview> createState() => _ServiceSelectPetAndReviewState();
}

class _ServiceSelectPetAndReviewState extends State<ServiceSelectPetAndReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Pet Patch USA'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurvedHeaderWidget(),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Partner Details
                  Text(
                    'Service Partner Details',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: AppSizes.fontSizeMd,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),

                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.primary),
                      SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "4140 Parker Rd. Allentown, Hawaii 81063",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "(20 miles away from your location)",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith( color: Color(0xFF4552CB),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.sm),

                  // Store Time
                  Row(
                    children: [
                      Icon(Icons.storefront_outlined, color: AppColors.primary),
                      SizedBox(width: AppSizes.sm),
                      Text(
                        "Open at 10 AM - 7PM (Closed on sat-sun)",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.sm),

                  // Phone
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: AppColors.primary),
                      SizedBox(width: AppSizes.sm),
                      Text(
                        "(406) 555-0120",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections),

                  PrimaryButton(
                    onPressed: (){
                    },
                    title: 'Save as Primary',
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  GalleryWidget(),
                ],
              ),
            ),
            ReviewSection(
            ),
          ],
        ),
      ),
    );
  }
}



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
