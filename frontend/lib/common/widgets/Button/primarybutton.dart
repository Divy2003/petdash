import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/colors.dart';

import '../../../utlis/constants/size.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, this.title, this.onPressed});

  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50, // responsive height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title ?? '',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
