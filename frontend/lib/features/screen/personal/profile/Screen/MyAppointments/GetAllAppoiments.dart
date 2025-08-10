import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petcare/services/api_service.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';


import '../../../../../../common/widgets/progessIndicator/threedotindicator.dart';
import 'AppoinmentsDetails.dart';

class GetallAppoiments extends StatefulWidget {
  const GetallAppoiments({super.key});

  @override
  State<GetallAppoiments> createState() => _GetallAppoimentsState();
}

class _GetallAppoimentsState extends State<GetallAppoiments> {
  bool isLoading = false;
  String? error;
  List<dynamic> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final res =
          await ApiService.get('/appointment/customer', requireAuth: true);
      setState(() {
        appointments = res['appointments'] ?? [];
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')), // simple default app bar
      body: isLoading
          ? const Center(child: ThreeDotIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView.separated(
                  itemCount: appointments.length,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final appt = appointments[index];
                    final business = appt['business'];
                    final service = appt['service'];
                    final pet = appt['pet'];
                    final date =
                        DateTime.tryParse(appt['appointmentDate'] ?? '');
                    final time = appt['appointmentTime'] ?? '';

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                service?['title'] ?? 'Service',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor((appt['status'] ?? '').toString().toLowerCase()).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: _statusColor((appt['status'] ?? '').toString().toLowerCase())),
                                ),
                                child: Text(
                                  (appt['status']?.toString().toUpperCase() ?? 'PENDING'),
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: _statusColor((appt['status'] ?? '').toString().toLowerCase()),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Provider: ${business?['name'] ?? '-'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Pet: ${pet?['name'] ?? '-'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                date != null
                                    ? DateFormat('MMMM dd yyyy, EEEE')
                                        .format(date)
                                    : '-',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              Text(
                                time.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          const SizedBox(height: 12),
                          PrimaryButton(
                            title: 'View Details',
                            onPressed: () {
                              final id = appt['_id'] ?? appt['id'];
                              if (id != null) {
                                Get.to(() =>
                                    AppoinmentsDetails(appointmentId: id));
                              }
                            },
                          )
                        ],
                      ),



                    );
                  },
                ),
      backgroundColor: Colors.grey.shade50,
    );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'completed':
      return AppColors.success;
    case 'cancelled':
      return Colors.grey;
    case 'upcoming':
    default:
      return AppColors.primary;
  }
}
