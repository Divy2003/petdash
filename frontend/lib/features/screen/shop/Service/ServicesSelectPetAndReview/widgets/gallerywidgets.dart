import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/utlis/constants/image_strings.dart';

class GalleryWidget extends StatelessWidget {
  const GalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample image list (replace with your actual image paths or URLs)
    final List<String> galleryImages = [

      AppImages.dog1,
      AppImages.dog2,
      AppImages.dog3,
      AppImages.dog4,
      AppImages.dog5,
      AppImages.dog1,
      AppImages.dog2,
      AppImages.dog3,
      AppImages.dog4,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: galleryImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return SizedBox(
              width: double.infinity,
              height: 50.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  galleryImages[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
