import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:petcare/services/appointment_service.dart';

import '../../../../../common/widgets/appbar/appbar.dart';

import '../../../../../common/widgets/progessIndicator/threedotindicator.dart';
import 'AppointmentsDetails.dart';


class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});


  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Map<String, dynamic>> appointments = [];
  bool isLoading = false;
  String? error;
  final Set<String> _updating = {};

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await AppointmentService.getBusinessAppointments();
      setState(() {
        appointments = List<Map<String, dynamic>>.from(data);
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

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return  Color(0xFF1D9031);
      case 'completed':
        return  Color(0xFF1976D2);
      case 'cancelled':
        return  Color(0xFF999999);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointments'),

      body: isLoading
          ?  Center(child: ThreeDotIndicator())
          : error != null
              ? Center(child: Text(error!))
              : RefreshIndicator(
                  onRefresh: _loadAppointments,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appt = appointments[index];
                      final status = (appt['status'] ?? 'upcoming').toString();
                      final dateStr = (appt['appointmentDate'] ?? '').toString();
                      final timeStr = (appt['appointmentTime'] ?? '').toString();
                      final dateTime = dateStr.isNotEmpty
                          ? DateTime.tryParse(dateStr) ?? DateTime.now()
                          : DateTime.now();
                      return Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textPrimaryColor),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
              color: AppColors.white,
            ),
            child: Padding(
              padding:  EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Status
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                    ),
                    child: Text(
                      status.capitalizeFirst ?? status,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  /// Title
                  Text(
                    (appt['service']?['title'] ?? appt['title'] ?? 'Appointment').toString(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 12),

                  /// Date & Time Row
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 6),
                      Text(
                        DateFormat('MMMM dd yyyy, EEEE').format(dateTime),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      Spacer(),
                      Text(
                        timeStr.isNotEmpty ? timeStr : DateFormat('h:mm a').format(dateTime),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textPrimaryColor,
                        ),
                      )
                    ],
                  ),

                  if (status.toLowerCase() == 'upcoming') ...[
                    /// Actions
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            title: _updating.contains(appt['_id']) ? 'Updating...' : 'Mark Completed',
                            onPressed: _updating.contains(appt['_id'])
                                ? null
                                : () async {
                                    final id = appt['_id']?.toString();
                                    if (id == null) return;
                                    setState(() => _updating.add(id));
                                    final ok = await AppointmentService.updateAppointmentStatus(
                                      appointmentId: id,
                                      status: 'completed',
                                    );
                                    setState(() => _updating.remove(id));
                                    if (ok) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Marked as completed')),
                                      );
                                      setState(() {
                                        final idx = appointments.indexWhere((x) => x['_id'] == id);
                                        if (idx != -1) appointments[idx]['status'] = 'completed';
                                      });
                                    }
                                  },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            title: _updating.contains(appt['_id']) ? 'Updating...' : 'Cancel',
                            onPressed: _updating.contains(appt['_id'])
                                ? null
                                : () async {
                                    final id = appt['_id']?.toString();
                                    if (id == null) return;
                                    setState(() => _updating.add(id));
                                    final ok = await AppointmentService.updateAppointmentStatus(
                                      appointmentId: id,
                                      status: 'cancelled',
                                    );
                                    setState(() => _updating.remove(id));
                                    if (ok) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Appointment cancelled')),
                                      );
                                      setState(() {
                                        appointments.removeWhere((x) => x['_id'] == id);
                                      });
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],

                  /// Details navigation
                  SizedBox(height: 12),
                  PrimaryButton(
                    title: "View Details",
                    onPressed: (){
                      final id = appt['_id']?.toString();
                      if (id != null) {
                        Get.to(() => AppointmentsDetails(appointmentId: id));
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}
