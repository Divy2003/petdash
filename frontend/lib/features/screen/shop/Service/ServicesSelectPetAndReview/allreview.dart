import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/common/widgets/appbar/appbar.dart';


class AllReview extends StatefulWidget {
  const AllReview({super.key});

  @override
  State<AllReview> createState() => _AllReviewState();
}

class _AllReviewState extends State<AllReview> {
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
    {
      'name': 'Esther Howard',
      'avatar': 'assets/images/user2.png',
      'rating': 5,
      'comment': 'Thanks!'
    },
    {
      'name': 'Esther Howard',
      'avatar': 'assets/images/user2.png',
      'rating': 5,
      'comment': 'Thanks!'
    },
    {
      'name': 'Esther Howard',
      'avatar': 'assets/images/user2.png',
      'rating': 5,
      'comment': 'Thanks!'
    },
    {
      'name': 'Esther Howard',
      'avatar': 'assets/images/user2.png',
      'rating': 5,
      'comment': 'Thanks!'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "All Review"),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Icon(Icons.star, color: Colors.orange, size: 16.sp),
                                  Text(
                                    item['rating'].toString(),
                                    style: TextStyle(fontSize: 12.sp),
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
        ),
      ),
    );
  }
}
