import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';

class CouponInput extends StatefulWidget {
  const CouponInput({super.key});

  @override
  State<CouponInput> createState() => _CouponInputState();
}

class _CouponInputState extends State<CouponInput> {
  final TextEditingController _controller = TextEditingController();

  void _applyCoupon() {
    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon "$code" applied')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Coupon Code',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSizeMd,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                     borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  ),
                  hintText: 'Enter code',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _applyCoupon,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3142), // Dark color from image
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                ),
              ),
              child:  Text(
                'Apply',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.white,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
