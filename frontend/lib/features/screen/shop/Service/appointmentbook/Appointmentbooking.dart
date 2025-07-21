import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/Notes.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/addonChecklist.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/astimatedcost.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/couponcode.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/dateAndTimePicker.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/cart/servicescart.dart';

import '../../../../../utlis/constants/image_strings.dart';
import '../serviceReceipt/receipt.dart';


class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {

  void _confirmAppointment() {
    final provider = Provider.of<AppointmentBookingProvider>(context, listen: false);

    // Validate form
    if (!provider.isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.validationError ?? 'Please complete all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${provider.selectedDate.toString().split(' ')[0]}'),
            Text('Time: ${provider.selectedTime.format(context)}'),
            Text('Total: \$${provider.total.toStringAsFixed(2)}'),
            if (provider.selectedAddOns.isNotEmpty)
              Text('Add-ons: ${provider.selectedAddOns.length} selected'),
            if (provider.isCouponApplied)
              Text('Coupon: ${provider.couponCode} applied'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would typically call an API to create the appointment
              // For now, we'll just navigate to the receipt
              Get.to(() => Receipt());
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointment'),
      body: Consumer<AppointmentBookingProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceCard(
                    title: 'Pet Patch USA',
                    subtitle: 'Bath & Haircut with FURminator',
                    imagePath: AppImages.storeLogo1,
                  ),
                  const SizedBox(height: 20),
                  DateTimePickerWidget(),
                  const SizedBox(height: 20),
                  AddOnsChecklist(),
                  const SizedBox(height: 10),
                  CouponInput(),
                  const SizedBox(height: 10),
                  NotesInput(),
                  const SizedBox(height: 10),
                  EstimatedCostCard(),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    onPressed: provider.isLoading ? null : _confirmAppointment,
                    title: provider.isLoading ? 'Processing...' : 'Confirm Appointment',
                  ),
                  if (!provider.isFormValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        provider.validationError ?? '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
