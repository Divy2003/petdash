import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
          padding: EdgeInsets.symmetric( horizontal: AppSizes.defaultPaddingHorizontal,
            vertical: AppSizes.defaultPaddingVertical,),
          child: Column(
            children: [
              PrimaryButton(
                title: 'Add New Service',
                onPressed: () {
                  Get.to(() => const AddNewServices());
                },
              ),
              SizedBox(height: 30.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service['title'],
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => EditServicesDetails(service: service));
                                },
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.primary,
                                  size: AppSizes.iconSm,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Icon(
                                Icons.delete,
                                color: const Color(0xFFFB2828),
                                size: AppSizes.iconSm,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            service['description'],
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 13.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Text(
                                "Starting from ${service['price']}",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.dottedColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.arrow_forward,
                                color: AppColors.dottedColor,
                                size: AppSizes.iconMd,
                              ),
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
