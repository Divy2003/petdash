import 'package:flutter/material.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/cart/servicescart.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';


class AppointmentsDetails extends StatefulWidget {
  const AppointmentsDetails({super.key});

  @override
  State<AppointmentsDetails> createState() => _AppointmentsDetailsState();
}

class _AppointmentsDetailsState extends State<AppointmentsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Appointment Details'),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [
              ServiceCard(
                title: 'Bath & Haircut with FURminator',
                subtitle: 'Customer: John Doe',
                imagePath: AppImages.person,
              ),

              SizedBox(height: AppSizes.spaceBtwItems),

              // Date and Time
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: AppSizes.iconSm, color: AppColors.primary),
                  SizedBox(width: AppSizes.sm),
                  Text(
                    '20 May 2021,\nMonday',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time,
                      size: AppSizes.iconSm, color: Colors.black54),
                  SizedBox(width: AppSizes.xs),
                  Text(
                    '11:00 AM',
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
                  petInfo("Pet Type", "Dog"),
                  petInfo("Owner Name", "Jane Cooper"),
                  petInfo("Pet Size", "Medium"),
                  petInfo("Pet Breed", "Husky"),
                ],
              ),
              SizedBox(height: 74),

                InkWell(
                onTap: (){},
                child: Container(
              width: double.infinity,
              height: 50, // responsive height
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                color: AppColors.primary,
                border: Border.all(color: AppColors.textprimaryColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Download invoice',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3,),
                  Icon(Icons.download, color: AppColors.white),
                ],
              ),
            ),
          ),
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
