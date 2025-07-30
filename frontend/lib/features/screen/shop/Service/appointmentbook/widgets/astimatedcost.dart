import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';

class EstimatedCostCard extends StatelessWidget {
  const EstimatedCostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentBookingProvider>(
      builder: (context, provider, child) {
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
                '\$${provider.total.toStringAsFixed(2)}',
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
                  Text(
                    'Base Service',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '\$${provider.basePrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (provider.addOnsTotal > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add-ons',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '\$${provider.addOnsTotal.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '\$${provider.subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (provider.isCouponApplied) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.green.shade700,
                      ),
                    ),
                    Text(
                      '-\$${provider.couponDiscount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tax (25%)',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '\$${provider.taxAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
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
                    '\$${provider.total.toStringAsFixed(2)}',
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
      },
    );
  }
}
