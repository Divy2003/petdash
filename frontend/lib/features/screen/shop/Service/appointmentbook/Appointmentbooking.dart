import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/Notes.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/addonChecklist.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/astimatedcost.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/couponcode.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbook/widgets/dateAndTimePicker.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';
import 'package:petcare/services/api_service.dart';
import 'package:petcare/services/petowerServices/pet_service.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/cart/servicescart.dart';

import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import 'ThankyouAppoinmentbook.dart';

class AppointmentBooking extends StatefulWidget {
  final String businessId;
  final String serviceId;
  final String petId;

  const AppointmentBooking({
    super.key,
    required this.businessId,
    required this.serviceId,
    required this.petId,
  });

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  Future<String?> _ensurePetId() async {
    // If petId already provided, use it
    if (widget.petId.trim().isNotEmpty) return widget.petId;

    try {
      // Try to fetch user's pets and use the first one
      final pets = await PetService.getAllPets();
      if (pets.isNotEmpty && pets.first.id != null) {
        return pets.first.id!;
      }
    } catch (e) {
      // ignore and fall through to error handling below
    }

    return null; // no pet available
  }

  Future<void> _createAppointment() async {
    final provider =
        Provider.of<AppointmentBookingProvider>(context, listen: false);

    // Validate form
    if (!provider.isFormValid) {
      Get.snackbar(
        "Error",
        provider.validationError ?? 'Please complete all required fields',
        backgroundColor: AppColors.error,
        colorText:  AppColors.white,
      );
      return;
    }

    final effectivePetId = await _ensurePetId();
    if (effectivePetId == null || effectivePetId.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please select or create a pet profile before booking.',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    // Validate service/business ids too
    final businessId = widget.businessId.trim();
    final serviceId = widget.serviceId.trim();
    if (businessId.isEmpty || serviceId.isEmpty) {
      Get.snackbar(
        'Error',
        'Service information is missing. Please reopen this service.',
        backgroundColor: AppColors.error,
        colorText:  AppColors.white,
      );
      return;
    }

    if (!mounted) return;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title:  Text(
            'Confirm Appointment',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
            ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Date: ${provider.selectedDate.toString().split(' ')[0]}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.secondary,
              ),
            ),
            Text('Time: ${provider.selectedTime.format(context)}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.secondary,
              ),
            ),
            Text('Total: \$${provider.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.secondary,
              ),
            ),
            if (provider.selectedAddOns.isNotEmpty)
              Text('Add-ons: ${provider.selectedAddOns.length} selected',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            if (provider.isCouponApplied)
              Text('Coupon: ${provider.couponCode} applied',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.secondary,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text('Cancel',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              // close dialog
              try {
                provider.setLoading(true);
                final payload = provider.getAppointmentData(
                  businessId: widget.businessId,
                  serviceId: widget.serviceId,
                  petId: effectivePetId,
                );

                // Call API: POST /appointment/create (auth required)
                final response = await ApiService.post(
                  '/appointment/create',
                  payload,
                  requireAuth: true,
                );

                provider.resetForm();

                // Navigate to Thank You screen with appointment data
                Get.off(() => ThankyouAppoinmentBook(
                      appointment: response['appointment'],
                      message: response['message'] ??
                          'Appointment created successfully',
                    ));
              } catch (e) {
                Get.snackbar(
                  'Error',
                  e.toString(),
                  backgroundColor: AppColors.error,
                  colorText: AppColors.white,
                );
              } finally {
                provider.setLoading(false);
              }
            },
            child:  Text('Confirm',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
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
                  // CouponInput(),
                  // const SizedBox(height: 10),
                  NotesInput(),
                  const SizedBox(height: 10),
                  EstimatedCostCard(),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    onPressed: provider.isLoading ? null : _createAppointment,
                    title: provider.isLoading
                        ? 'Processing...'
                        : 'Confirm Appointment',
                  ),
                  if (!provider.isFormValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        provider.validationError ?? '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.error,
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
