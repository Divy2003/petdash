import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/utlis/constants/size.dart';
import '../../../utlis/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions; // <-- Optional actions

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 7, bottom: 7),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: AppColors.black),
          onPressed: onBack ?? () => Get.back(),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: AppColors.primary,
        ),
      ),
      actions: actions, // <-- Set optional actions here
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
