import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/utlis/constants/size.dart';

import '../../../../common/widgets/Button/primarybutton.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import 'appointmentbook/Appointmentbooking.dart';

class ServicesSubDetails extends StatefulWidget {
  const ServicesSubDetails({super.key});

  @override
  State<ServicesSubDetails> createState() => _ServicesSubDetailsState();
}

class _ServicesSubDetailsState extends State<ServicesSubDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Bath & Full haircut'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              Container(
                width: double.infinity,
                height: 130.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg.r),
                  image: DecorationImage(
                    image: AssetImage(AppImages.store1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 11.h),

              /// Title
              Text(
                'Bath & Full haircut',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.primary,
                  fontSize: AppSizes.fontSizeSm.sp,
                ),
              ),

              SizedBox(height: 10.h),

              /// Description
              Text(
                'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 10.h),

              /// Service Included Title
              Text(
                'Service included:',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),

              /// Service List
              ...[
                "Oxygen-infused bath with shampoo & blow dry",
                "15-minute brushing",
                "Haircut & light dematting",
                "Nail trim",
                "Ear cleaning, hair removal & flushing (if needed)",
                "Scissoring feet & pad shaving",
                "Sanitary trim",
                "Anal gland cleaning",
                "FURminator low-shed shampoo",
                "FURminator deShedding™ solution",
                "Up to 20 minutes of brushing with FURminator Tool",
              ].map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

              SizedBox(height: 10.h),

              /// Info Note
              Text(
                "*Price varies based on breed, coat condition & service time. Book online & see estimated price before your visit.",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: const Color(0xFF4552CB).withOpacity(0.6),
                ),
              ),

              SizedBox(height: 30.h),

              /// Estimated Price
              Text(
                'Estimated Price: \$45',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 30.h),

              /// Book Appointment Button
              PrimaryButton(
                title: 'Book Appointment',
                onPressed: () {
                  Get.to(() => const AppointmentBooking());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
