import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/colors.dart';

import '../../../utlis/constants/size.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, this.title, this.onPressed});

  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50, // responsive height
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          color: AppColors.white,
          border: Border.all(color: AppColors.textprimaryColor),
        ),
        child: Text(
          title ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
