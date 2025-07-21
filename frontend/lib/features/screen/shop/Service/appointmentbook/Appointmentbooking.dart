import 'package:flutter/material.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbok/widgets/Notes.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbok/widgets/addonChecklist.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbok/widgets/astimatedcost.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbok/widgets/couponcode.dart';
import 'package:petcare/features/screen/shop/Service/appointmentbok/widgets/dateAndTimePicker.dart';
import 'package:petcare/utlis/constants/size.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/cart/servicescart.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';


class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointment',),

      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          crossAxisAlignment:  CrossAxisAlignment.start,
          children: [
            ServiceCard(
              title: 'Pet Patch USA',
              subtitle: 'Bath & Haircut with FURminator',
              imagePath: AppImages.storeLogo1,
            ),
            SizedBox(height: 20,),
            DateTimePickerWidget(),
            SizedBox(height: 20,),
            AddOnsChecklist(),
            SizedBox(height: 10,),
        
            CouponInput(),
            SizedBox(height: 10,),
            NotesInput(),
            SizedBox(height: 10,),
            EstimatedCostCard(),
            SizedBox(height: 20,),
            PrimaryButton(
              onPressed: (){},
              title: 'Confirm Appointment',
            )
          ],
        )),
      ),
    );
  }
}
