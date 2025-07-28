import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/size.dart';
import 'addNewSupport.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, dynamic>> supportTickets = [
    {
      'id': 'PSW-2340905940-347',
      'status': 'Open',
      'message': 'Want to change delivery address.',
    },
    {
      'id': 'PSW-2340905940-232',
      'status': 'Solved',
      'message': 'My Order is not delivered yet.',
    },
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return  AppColors.error;
      case 'solved':
        return AppColors.success;
      default:
        return AppColors.textPrimaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Support'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.defaultPaddingHorizontal,
            vertical: AppSizes.defaultPaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryButton(
                title: 'Add New Ticket',
                onPressed: () {
                  Get.to(() => AddNewSupport());
                },
              ),
              SizedBox(height: AppSizes.defaultSpace * 1.5),
              Text(
                'Your Past Ticket',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              /// List of tickets
              ListView.builder(
                itemCount: supportTickets.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final ticket = supportTickets[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ticket ID',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: getStatusColor(ticket['status']),
                                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                              ),
                              child: Text(
                                ticket['status'],
                               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          ticket['id'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: AppSizes.spaceBtwItems),
                        Text(
                          ticket['message'],
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
