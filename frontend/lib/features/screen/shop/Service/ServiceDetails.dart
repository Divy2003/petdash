import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/constants/size.dart';
import 'ServicesSelectPetAndReview/ServiceSelectPetandReview.dart';
import 'ServicesSelectPetAndReview/widgets/curvedheaderwidgets.dart';
import 'ServicesSubDeatils.dart';

class ServiceDetails extends StatefulWidget {
  final String providerName;
  final String? businessId;

  const ServiceDetails({
    super.key,
    required this.providerName,
    this.businessId,
  });

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
      appBar: CustomAppBar(title: 'Pet Patch USA'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Get.to(() => ServiceSelectPetAndReview());
              },
              child: CurvedHeaderWidget(),
            ),
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
                ],
              ),
            ),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                ),
                child: Center(
                  child: Text(
                    'Save as Primary',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: AppColors.textprimaryColor,
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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Salon Menu',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: salonMenu.length,
              itemBuilder: (context, index) {
                final item = salonMenu[index];
                return GestureDetector(
                  onTap: () => Get.to(() => ServicesSubDetails()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      margin: EdgeInsets.only(bottom: AppSizes.md),
                      padding: EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
                        border: Border.all(color: AppColors.textprimaryColor),
                      ),
                      child: Row(
                        children: [
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  item['description'],
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.secondary,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Starting from ${item['price']}',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
        ),
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
