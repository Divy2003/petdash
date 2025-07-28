import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/Button/secondarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import 'ordercancle.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Order ID: 45ADS3456'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric( horizontal: AppSizes.defaultPaddingHorizontal,
          vertical: AppSizes.defaultPaddingVertical,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Product Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                border: Border.all(color: AppColors.textPrimaryColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImages.products,
                    width: 70.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Royal Canin Medium Breed Adult Dry Dog Food.',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '\$69.74  *  2',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Total: \$138.74',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: 16.h),

            /// Payment Status
            Text(
              'Payment status: Paid',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D9031),
              ),
            ),

            SizedBox(height: 16.h),

            /// Address & Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                border: Border.all(color: AppColors.textPrimaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          '2464 Royal Ln. Mesa, New Jersey 45463',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  _infoRow('Customer Name:', 'Maria Lee'),
                  _infoRow('Contact Number:', '+01 2345679034'),
                  const Divider(height: 20),
                  _infoRow('Seller Details:', 'Dogs and Care'),
                  _infoRow('Contact Number:', '+01 2345679034'),
                  _infoRow('Email Address:', 'Dogsandcare@info.com'),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            /// Action Buttons
            SecondaryButton(
              title: 'Cancel Order',
              onPressed: () {
                Get.to(() => const CancelledOrderDetails());
              },
            ),
            SizedBox(height: 12.h),
            PrimaryButton(
              title: 'Track Order',
              onPressed: () {
                // Add your tracking logic here
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Info Row Widget
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: RichText(
        text: TextSpan(
          text: '$title ',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
