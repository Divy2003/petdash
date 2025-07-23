import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/utlis/constants/colors.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/size.dart';
import 'addnewServices.dart';
import 'editServicesdetails.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  final List<Map<String, dynamic>> services = [
    {
      "title": "Bath & Full Haircut",
      "description": "For dogs who need a bath & haircut.",
      "price": "\$45"
    },
    {
      "title": "Bath & Haircut with FURminator",
      "description":
      "For dogs who need a bath, haircut & extra attention to their coats to help reduce shedding.",
      "price": "\$55"
    },
    {
      "title": "Bath & Brush with FURminator",
      "description":
      "For dogs who need a bath plus extra attention to their coats to help reduce shedding.",
      "price": "\$65"
    },
    {
      "title": "Bath & Brush",
      "description":
      "For dogs who just need a bath to maintain a healthy-looking coat, clean ears & trimmed nails.",
      "price": "\$65"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Services'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              PrimaryButton(
                title: 'Add New Service',
                onPressed: () {
                  Get.to(() => AddNewServices());
                },
              ),
              const SizedBox(height: 30),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // IMPORTANT
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                service['title'],
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(() => EditServicesDetails(service: service));
                                },
                                  child: Icon(Icons.edit_outlined, color: AppColors.primary,size: 14,)),
                              SizedBox(width: 10,),
                              Icon(Icons.delete, color: Color(0xFFFB2828),size: 14,),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service['description'],
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Starting from ${service['price']}",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color : Color(0xFF4552CB),
                                  fontWeight: FontWeight.w600,
                                ),

                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward,  color : Color(0xFF4552CB), size: 24),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
