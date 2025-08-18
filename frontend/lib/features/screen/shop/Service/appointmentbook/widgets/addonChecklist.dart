import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';

class AddOnsChecklist extends StatelessWidget {
  const AddOnsChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentBookingProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Add Ons',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppSizes.fontSizeMd,
                color: AppColors.primary,
              ),
            ),
            ...provider.addOns.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Row(
                children: [
                  Expanded(
                    child: Text(
                      item['title'],
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(width: 1, color: AppColors.primary),
                    value: item['selected'],
                    onChanged: (value) {
                      provider.toggleAddOn(index);
                    },
                  ),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
