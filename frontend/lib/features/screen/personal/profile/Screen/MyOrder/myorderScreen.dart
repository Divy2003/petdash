import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/image_strings.dart';
import '../../../../../../utlis/constants/size.dart';
import 'orderDetailsScreen.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(title: 'My Orders'),

      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: AppSizes.defaultPaddingHorizontal,
          vertical: AppSizes.defaultPaddingVertical,
        ),
        child: ListView(
          children: [
             Text(
              "This Month",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.primary,
              ),
            ),
             SizedBox(height: AppSizes.spaceBtwItems/2),
            OrderCard(
              orderNumber: "PSW-2340905940-232",
              status: "All Items Delivered.",
              statusColor: AppColors.primary,
              products: [
                AppImages.products1,
                AppImages.products2,
                AppImages.products3,
              ],
            ),
             SizedBox(height: AppSizes.spaceBtwItems),
             Text(
              "Last Month",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            OrderCard(
              orderNumber: "PSW-2340905930-234",
              status: "Cancelled Order",
              statusColor: Colors.red,
              products: [
               AppImages.products4
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String status;
  final Color statusColor;
  final List<String> products;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.statusColor,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FB),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Order Number\n$orderNumber",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(() =>  OrderDetailScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  ),
                ),
                child:  Text(
                    "View Details",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: products
                .map(
                  (imgPath) => Padding(
                    padding:  EdgeInsets.all(AppSizes.sm),
                    child: Container(
                      padding:  EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(

                        border: Border.all(
                            color: AppColors.textPrimaryColor, width: 1),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                      ),
                      child: ClipRRect(
                        child: Image.asset(
                      imgPath,
                      width: 60,
                      height: 60,

                        ),
                                    ),
                    ),
                  ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
