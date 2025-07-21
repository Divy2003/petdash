import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/cart/servicescart.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Receipt'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ServiceCard(
                title: 'Pet Patch USA',
                subtitle: 'Bath & Haircut with FURminator',
                imagePath: AppImages.storeLogo1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              // Date and Time
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: AppSizes.iconSm, color: AppColors.primary),
                  SizedBox(width: AppSizes.sm),
                  Text(
                    '20 May 2021,\nMonday',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time,
                      size: AppSizes.iconSm, color: Colors.black54),
                  SizedBox(width: AppSizes.xs),
                  Text(
                    '11:00 AM',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              // Cancel Booking
              Row(
                children: [
                  Text(
                    'Want to Cancel Booking?',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Cancel booking action
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50.w, 20.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Cancel Booking',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFFB2828),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spaceBtwSections),

              // Booking Details
              Text(
                'Booking Details',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: AppSizes.fontSizeMd,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSizes.sm),

              Padding(
                padding: EdgeInsets.only(left: AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary)),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Bath & Haircut with FURminator ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.primary),
                                children: [
                                  TextSpan(
                                    text: '(View details)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: const Color(0xFF4552CB)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary)),
                          Expanded(
                            child: Text(
                              'Add on services - None',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• "),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Tax and service charges - ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary),
                              children: [
                                TextSpan(
                                  text: '\$20',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwSections),

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
              SizedBox(height: AppSizes.spaceBtwItems),

              // Google Maps button
              SizedBox(
                height: 48.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url =
                        'https://www.google.com/maps/search/?api=1&query=4140+Parker+Rd,+Allentown,+Hawaii+81063';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                  icon: Icon(Icons.navigation, color: AppColors.primary),
                  label: Text(
                    "Check location on Google Maps",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF383E56).withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              // Download Invoice button
              SizedBox(
                height: 48.h,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add your download logic
                  },
                  icon: const Icon(Icons.download, color: AppColors.white),
                  label: Text(
                    "Download invoice",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
