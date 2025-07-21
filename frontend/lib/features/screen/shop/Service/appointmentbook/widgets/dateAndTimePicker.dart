import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';

class DateTimePickerWidget extends StatefulWidget {
  const DateTimePickerWidget({super.key});

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isDatePicked = false;
  bool isTimePicked = false;

  String get formattedDate => DateFormat('yyyy-MM-dd').format(selectedDate);
  String get formattedTime => selectedTime.format(context);

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 20),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        isDatePicked = true;
      });
    }
  }

  // Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        isTimePicked = true;
      });
    }
  }

  // Confirm Action
  @override
  Widget build(BuildContext context) {
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
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(
                          Icons.calendar_today_outlined, size: 18),
                       SizedBox(width: 8),
                      Text(
                        isDatePicked ? formattedDate : 'Date',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: AppSizes.fontSizeMd,
                          color:
                          isDatePicked ? AppColors.primary : AppColors.black,
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
                onTap: () => _selectTime(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        isTimePicked ? formattedTime : 'Time',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSizes.fontSizeMd,
                          color:
                          isTimePicked ? AppColors.primary : AppColors.black,
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
  }
}
