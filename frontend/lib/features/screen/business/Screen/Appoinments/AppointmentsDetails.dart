import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/cart/servicescart.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../services/appointment_service.dart';


class AppointmentsDetails extends StatefulWidget {
  final String? appointmentId;
  const AppointmentsDetails({super.key, this.appointmentId});

  @override
  State<AppointmentsDetails> createState() => _AppointmentsDetailsState();
}

class _AppointmentsDetailsState extends State<AppointmentsDetails> {
  Map<String, dynamic>? details;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.appointmentId != null) {
      _loadDetails();
    }
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await AppointmentService.getAppointmentDetails(widget.appointmentId!);
      setState(() {
        details = data;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointment Details'),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                final appt = (details?['appointment'] ?? {}) as Map<String, dynamic>;
                final service = (appt['service'] ?? {}) as Map<String, dynamic>;
                final customer = (appt['customer'] ?? {}) as Map<String, dynamic>;
                return ServiceCard(
                  title: (service['title'] ?? 'Service').toString(),
                  subtitle: 'Customer: ' + (customer['name'] ?? 'N/A').toString(),
                  imagePath: AppImages.person,
                );
              }),

              SizedBox(height: AppSizes.spaceBtwItems),

              // Date and Time
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: AppSizes.iconSm, color: AppColors.primary),
                  SizedBox(width: AppSizes.sm),
                  Text(
                    (() {
                      final appt = (details?['appointment'] ?? {}) as Map<String, dynamic>;
                      final dateStr = (appt['appointmentDate'] ?? '').toString();
                      if (dateStr.isEmpty) return '—';
                      final dt = DateTime.tryParse(dateStr);
                      if (dt == null) return '—';
                      return DateFormat('dd MMM yyyy, EEEE').format(dt);
                    })(),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time,
                      size: AppSizes.iconSm, color: Colors.black54),
                  SizedBox(width: AppSizes.xs),
                  Text(
                    (() {
                      final appt = (details?['appointment'] ?? {}) as Map<String, dynamic>;
                      final t = (appt['appointmentTime'] ?? '').toString();
                      return t.isNotEmpty ? t : '—';
                    })(),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              // Booking Details
              Text(
                'Booking Details',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: AppSizes.fontSizeMd,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSizes.sm),

              Padding(
                padding: EdgeInsets.only(left: AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary)),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Bath & Haircut with FURminator ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.primary),
                                children: [
                                  TextSpan(
                                    text: '(View details)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: const Color(0xFF4552CB)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.xs),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary)),
                          Expanded(
                            child: Text(
                              'Add on services - None',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• "),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Tax and service charges - ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: AppColors.primary),
                              children: [
                                TextSpan(
                                  text: '\$20',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwSections),



              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.email_outlined, size: 24, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        "MariaM@gmail.com",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Customer Rating",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        "5 Star",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 24, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                      "(406) 555-0120",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              /// Pet info (grid-style)
              Wrap(
                runSpacing: 8,
                spacing: 16,
                children: [
                  Builder(builder: (context) {
                    final appt = (details?['appointment'] ?? {}) as Map<String, dynamic>;
                    final pet = (appt['pet'] ?? {}) as Map<String, dynamic>;
                    final customer = (appt['customer'] ?? {}) as Map<String, dynamic>;
                    return Wrap(
                      runSpacing: 8,
                      spacing: 16,
                      children: [
                        petInfo("Pet Type", (pet['species'] ?? '—').toString()),
                        petInfo("Owner Name", (customer['name'] ?? '—').toString()),
                        petInfo("Pet Breed", (pet['breed'] ?? '—').toString()),
                      ],
                    );
                  }),
                ],
              ),
              SizedBox(height: 74),

              Builder(builder: (context) {
                final appt = (details?['appointment'] ?? {}) as Map<String, dynamic>;
                final status = (appt['status'] ?? '').toString().toLowerCase();
                if (status != 'upcoming') return const SizedBox.shrink();
                return Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        title: 'Mark as Completed',
                        onPressed: () async {
                          if (widget.appointmentId == null) return;
                          final ok = await AppointmentService.updateAppointmentStatus(
                            appointmentId: widget.appointmentId!,
                            status: 'completed',
                          );
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Status updated to completed')),
                            );
                            _loadDetails();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        title: 'Cancel Appointment',
                        onPressed: () async {
                          if (widget.appointmentId == null) return;
                          final ok = await AppointmentService.updateAppointmentStatus(
                            appointmentId: widget.appointmentId!,
                            status: 'cancelled',
                          );
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Appointment cancelled')),
                            );
                            _loadDetails();
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),

    );
  }

  Widget petInfo(String label, String value) {
    return SizedBox(
      width: 150,
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.dividerColor,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
