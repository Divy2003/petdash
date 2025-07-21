import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';

class EstimatedCostCard extends StatelessWidget {
  const EstimatedCostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated Cost',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: AppSizes.fontSizeMd,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '\$100',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '(inclusive of all taxes)',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: AppColors.primary,
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),
               Text('\$80',
                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                   color: AppColors.primary,
                 ),
               ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax', style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primary,
              ),),
               Text('\$20', style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primary,
              ),),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
               Text(
                '\$100',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
