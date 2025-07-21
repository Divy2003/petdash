import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/constants/size.dart';

class ServiceDetails extends StatefulWidget {
  final String providerName;
  
  const ServiceDetails({super.key, required this.providerName});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final List<Map<String, dynamic>> salonMenu = [
    {
      'title': 'Bath & Full haircut',
      'description': 'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
      'price': '\$45',
      'image': AppImages.store1,
    },
    {
      'title': 'Bath & haircut with Furminator',
      'description': 'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
      'price': '\$55',
      'image': AppImages.store2,
    },
    {
      'title': 'Bath & Brush with Furminator',
      'description': 'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
      'price': '\$65',
      'image': AppImages.store1,
    },
    {
      'title': 'Bath & Brush',
      'description': 'For dogs who need a bath & brush to maintain their coat',
      'price': '\$35',
      'image': AppImages.store2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Container(
              margin: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.favorite_border, color: AppColors.black),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                AppImages.store1,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Provider Info
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: AssetImage(AppImages.storeLogo1),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.providerName,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Open at 8 AM-10PM',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  
                  // Save as Primary Button
                  Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                    child: Center(
                      child: Text(
                        'Save as Primary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  
                  // Select Pet Section
                  Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.pets,
                          color: Colors.grey[600],
                          size: 30.r,
                        ),
                      ),
                      SizedBox(width: AppSizes.sm),
                      Text(
                        'Select Pet',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  
                  // Salon Menu
                  Text(
                    'Salon Menu',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceBtwItems),
                  
                  // Menu Items
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: salonMenu.length,
                    itemBuilder: (context, index) {
                      final item = salonMenu[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: AppSizes.md),
                        padding: EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            // Service Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                item['image'],
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: AppSizes.sm),
                            // Service Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item['description'],
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Starting from ${item['price']}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
