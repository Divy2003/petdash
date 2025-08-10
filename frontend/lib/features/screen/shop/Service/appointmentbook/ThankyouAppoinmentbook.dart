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
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Icon(Icons.check_circle, color: AppColors.success, size: 90),
            const SizedBox(height: 16),
            Text(
              widget.message ??
                  'Your appointment has been booked successfully!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // Receipt-like card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
                border: Border.all(color: Colors.grey.shade200),
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
                  child: OutlinedButton(
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
                        colorText: Colors.white,
                      );
                    },
                    child: const Text('Print'),
                  ),
                ),
                 SizedBox(width: AppSizes.spaceBtwItems),
                Expanded(
                  child: PrimaryButton(
                    title: 'Back to Home',
                    onPressed: () {
                      Get.offAll(() => const CurvedNavScreen());
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
            Text(label, style: const TextStyle(color: Colors.black54)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
