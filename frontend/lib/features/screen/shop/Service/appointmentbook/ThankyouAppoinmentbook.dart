import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/features/screen/Navigation.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';

class ThankyouAppoinmentBook extends StatefulWidget {
  final Map<String, dynamic>? appointment;
  final String? message;

  const ThankyouAppoinmentBook({super.key, this.appointment, this.message});

  @override
  State<ThankyouAppoinmentBook> createState() => _ThankyouAppoinmentBookState();
}

class _ThankyouAppoinmentBookState extends State<ThankyouAppoinmentBook> {
  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment ?? {};
    final bookingId = appt['bookingId'] ?? '';
    final date = appt['appointmentDate'] ?? '';
    final time = appt['appointmentTime'] ?? '';
    final serviceTitle =
        appt['service'] is Map ? appt['service']['title'] ?? '' : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmed'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             SizedBox(height:  AppSizes.spaceBtwItems *1.5),
            Icon(Icons.check_circle, color: AppColors.success, size: 90),
             SizedBox(height:AppSizes.spaceBtwItems),
            Text(
              widget.message ??
                  'Your appointment has been booked successfully!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
             SizedBox(height: AppSizes.spaceBtwItems *1.5),

            // Receipt-like card
            Container(
              width: double.infinity,
              padding:  EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                border: Border.all(color: AppColors.textPrimaryColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bookingId.toString().isNotEmpty)
                    _row('Booking ID', bookingId.toString()),
                  if (serviceTitle.toString().isNotEmpty)
                    _row('Service', serviceTitle.toString()),
                  if (date.toString().isNotEmpty)
                    _row('Date', date.toString().split('T').first),
                  if (time.toString().isNotEmpty) _row('Time', time.toString()),
                ],
              ),
            ),

            const Spacer(),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                      ),
                    ),
                    onPressed: () {
                      // Basic print: log to console
                      debugPrint('--- Appointment Receipt ---');
                      debugPrint('Booking ID: $bookingId');
                      debugPrint('Service: $serviceTitle');
                      debugPrint('Date: $date');
                      debugPrint('Time: $time');
                      Get.snackbar(
                        'Printed',
                        'Receipt details printed to console',
                        backgroundColor: AppColors.success,
                        colorText: AppColors.white,
                      );
                    },
                    child:  Text('Print',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                 SizedBox(width: AppSizes.spaceBtwItems),
                Expanded(
                  child: PrimaryButton(
                    title: 'Back to Home',
                    onPressed: () {
                      Get.offAll(() =>  CurvedNavScreen());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade50,
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.textPrimaryColor,
            )),
            Text(value, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            )),
          ],
        ),
      );
}
