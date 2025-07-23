import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petcare/utlis/constants/image_strings.dart';
import 'package:petcare/utlis/constants/size.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/Button/secondarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
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
      appBar: CustomAppBar(
          title: 'Order ID: 45ADS3456',
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Product Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                border: Border.all(color: AppColors.textPrimaryColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppImages.products,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 12),
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
                        SizedBox(height: 8),
                        Text(
                          '\$69.74  *  2',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 6),
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

            SizedBox(height: 16),

            /// Payment status
            Text(
              'Payment status: Paid',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D9031),
              ),
            ),

            SizedBox(height: 16),

            /// Address & Info box
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.textPrimaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary
                      ),
                      SizedBox(width: 6),
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
                  Divider(height: 20),
                  _infoRow('Customer Name:', 'Maria Lee'),
                  _infoRow('Contact Number:', '+01 2345679034'),
                  Divider(height: 20),
                  _infoRow('Seller Details:', 'Dogs and Care'),
                  _infoRow('Contact Number:', '+01 2345679034'),
                  _infoRow('Email Address:', 'Dogsandcare@info.com'),
                ],
              ),
            ),

            SizedBox(height: 24),

            /// Buttons
            SecondaryButton(title: 'Cancel Order',onPressed: (){
              Get.to(() => CancelledOrderDetails());
            },),
            SizedBox(height: 12),
            PrimaryButton(title: 'Track Order',onPressed: (){},),
          ],
        ),
      ),
    );
  }

  /// Helper: Info rows inside the card
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          text: title + ' ',
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
