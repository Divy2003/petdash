import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/size.dart';
import '../allreview.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'name': 'Kristin Watson',
        'avatar': 'assets/images/user1.png',
        'rating': 5,
        'comment': 'Best service in the USA.'
      },
      {
        'name': 'Esther Howard',
        'avatar': 'assets/images/user2.png',
        'rating': 5,
        'comment': 'Thanks!'
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => AllReview());
                  // TODO: Navigate to full review screen
                },
                child: Text(
                  'View all',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Review List
          ...reviews.map((review) {
            final Map<String, dynamic> item = review;

            return Column(
              children: [
                Row(
                  children: [
                    /// Avatar
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: AssetImage(item['avatar']),
                    ),
                    SizedBox(width: 10.w),

                    /// Name, Rating, Comment
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name + Rating
                          Row(
                            children: [
                              Text(
                                item['name'],
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(Icons.star, color: Colors.orange, size: 16.sp),
                              Text(
                                item['rating'].toString(),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),

                          /// Comment
                          Text(
                            item['comment'],
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
               SizedBox(height: 20,),
              ],
            );
          }).toList(),

        ],
      ),
    );
  }
}
