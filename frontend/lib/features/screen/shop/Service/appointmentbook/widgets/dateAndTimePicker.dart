import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';

class DateTimePickerWidget extends StatelessWidget {
  const DateTimePickerWidget({super.key});

  // Date Picker
  Future<void> _selectDate(BuildContext context, AppointmentBookingProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 20),
    );
    if (picked != null) {
      provider.setDate(picked);
    }
  }

  // Time Picker
  Future<void> _selectTime(BuildContext context, AppointmentBookingProvider provider) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.selectedTime,
    );
    if (picked != null) {
      provider.setTime(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentBookingProvider>(
      builder: (context, provider, child) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(provider.selectedDate);
        String formattedTime = provider.selectedTime.format(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Date and Time',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppSizes.fontSizeMd,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textPrimaryColor),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            provider.isDatePicked ? formattedDate : 'Date',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: AppSizes.fontSizeMd,
                              color: provider.isDatePicked ? AppColors.primary : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textPrimaryColor),
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            provider.isTimePicked ? formattedTime : 'Time',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: AppSizes.fontSizeMd,
                              color: provider.isTimePicked ? AppColors.primary : AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
