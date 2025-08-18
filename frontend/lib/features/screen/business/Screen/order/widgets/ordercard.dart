import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/size.dart';
import '../../../model/ordermodel.dart';
import '../ordercancle.dart';
import '../orderdetails.dart';
// or define in the same file

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          color: Colors.white,
          border: Border.all(
              color: AppColors.textPrimaryColor,
              width: 1
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and quantity badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    order.imageUrl,
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.green,
                    child: Text(
                      '${order.quantity}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${order.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.primary,

                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: (){
                          if (order.status == 'cancelled') {
                            Get.to(() => CancelledOrderDetails());
                          } else {
                            Get.to(() => OrderDetails());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                            color: AppColors.primary,
                          ),
                          child: Text(
                            'View',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // View Button
          ],
        ),
      ),
    );
  }
}
