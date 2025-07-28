import 'package:flutter/material.dart';

import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/image_strings.dart';
import '../../../../../../utlis/constants/size.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Order Details'),
      body: Padding(
        padding:  EdgeInsets.symmetric(
          horizontal: AppSizes.defaultPaddingHorizontal,
          vertical: AppSizes.defaultPaddingVertical,
       ),
        child: ListView(
          children: [
            Container(
              padding:  EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
              ),
              child:  Center(
                child: Text("Order Delivered May 25, 2021",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.cart,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("Order Number",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("PSW-2340905940-232",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.primary,
                  ),
                  ),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text("Order Date",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),),
                  Text("May 25th, 2021",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ])
              ],
            ),
             SizedBox(height: AppSizes.spaceBtwItems),
             Text("Receipt",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(),
            ReceiptItem(
              title: "Merrick Grain Free with Real Meat + Sweet Potato Dry Dog Food",
              subtitle: "Qty: 2 (Delivers Monthly)",
              price: "\$80.00",
              image: AppImages.products1,
            ),
            ReceiptItem(
              title: "Glucosamine Chondroitin for Joint Support",
              subtitle: "Qty: 1",
              price: "\$30.00",
              image: AppImages.products2,
            ),
            ReceiptItem(
              title: "Petrodex Advanced Dental Care Enzymatic Dog Toothpaste",
              subtitle: "Qty: 1",
              price: "\$10.00",
              image: AppImages.products3,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text("Subtotal",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("\$120",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text("Shipping",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("\$20",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.primary,

                ),)],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text("Total",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("\$140",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.cart,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiptItem extends StatelessWidget {
  final String title, subtitle, price, image;

  const ReceiptItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 50),
      title: Text(title,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.primary,
          ),
      ),
      subtitle: Text(subtitle,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: AppColors.success,
        ),
      ),
      trailing: Text(price,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.cart,
        ),
      ),
    );
  }
}
