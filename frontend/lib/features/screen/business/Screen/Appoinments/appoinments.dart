import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../model/appointments.dart';
import 'AppointmentsDetails.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});


  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<Appointment> appointments = [
    Appointment(
      title: 'Bath & Haircut with FURminator',
      dateTime: DateTime(2021, 5, 20, 11, 0),
      status: 'Upcoming',
    ),
    Appointment(
      title: 'Bath & Haircut',
      dateTime: DateTime(2021, 3, 10, 17, 0),
      status: 'Completed',
    ),
    Appointment(
      title: 'Bath & Haircut with FURminator',
      dateTime: DateTime(2021, 3, 9, 18, 0),
      status: 'Cancelled',
    ),
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Color(0xFF1D9031);
      case 'Completed':
        return Color(0xFF1976D2);
      case 'Cancelled':
        return Color(0xFF999999);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointments'),

      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appt = appointments[index];
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
                      color: getStatusColor(appt.status),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                    ),
                    child: Text(
                      appt.status,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  /// Title
                  Text(
                    appt.title,
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
                        DateFormat('MMMM dd yyyy, EEEE').format(appt.dateTime),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      Spacer(),
                      Text(
                        DateFormat('h:mm a').format(appt.dateTime),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textPrimaryColor,
                        ),
                      )
                    ],
                  ),

                  /// Add to calendar button (only if upcoming)
                  if (appt.status == 'Upcoming') ...[
                    SizedBox(height: 12),
                   PrimaryButton(
                     title: "Add to Calendar",
                     onPressed: (){
                       Get.to(() => AppointmentsDetails());
                     },
                   )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
