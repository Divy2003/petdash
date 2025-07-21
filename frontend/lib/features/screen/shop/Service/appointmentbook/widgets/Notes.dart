import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';

class NotesInput extends StatelessWidget {
  const NotesInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSizeSm,
          ),
        ),
        const SizedBox(height: 8),
        Consumer<AppointmentBookingProvider>(
          builder: (context, provider, child) {
            return TextField(
              maxLines: 4,
              onChanged: provider.setNotes,
              decoration: InputDecoration(
                hintText: 'Enter any special instructions...',
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
