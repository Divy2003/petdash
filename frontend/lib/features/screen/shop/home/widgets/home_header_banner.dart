import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../personal/profile/Screen/MyPet/AddAnotherPet.dart';


class HomeHeaderBanner extends StatelessWidget {
  const HomeHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Image.asset(
              AppImages.letStart,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: AppSizes.spaceBtwSections),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.md),
          child: Center(
            child: Text(
              "Lets Get Started!",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.white,
                fontSize: AppSizes.fontSizeXl,
                fontFamily: 'EncodeSansExpanded',
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.h,
          left: 100.w,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => const AddOrEditPetScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:  AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.xl,
                vertical: AppSizes.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              ),
            ),
            child: Text(
              'Create Profile',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
