import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';

class CouponInput extends StatelessWidget {
  const CouponInput({super.key});

  void _applyCoupon(BuildContext context, AppointmentBookingProvider provider) {
    if (provider.couponCode.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
      return;
    }

    provider.applyCoupon();

    if (provider.isCouponApplied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon "${provider.couponCode}" applied! Saved \$${provider.couponDiscount.toStringAsFixed(2)}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentBookingProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Coupon Code',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: AppSizes.fontSizeMd,
                    color: AppColors.primary,
                  ),
                ),
                if (provider.isCouponApplied) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Applied',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: provider.setCouponCode,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                        borderSide: const BorderSide(color: AppColors.textprimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.textprimaryColor),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      ),
                      hintText: 'Enter code (SAVE10, SAVE20, FIRST15)',
                      hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _applyCoupon(context, provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3142),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            if (provider.isCouponApplied)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      'Discount: -\$${provider.couponDiscount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: provider.removeCoupon,
                      child: Text(
                        'Remove',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
