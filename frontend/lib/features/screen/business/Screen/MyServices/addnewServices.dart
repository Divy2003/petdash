import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../widgets/custom_text_field.dart';

class AddNewServices extends StatefulWidget {
  const AddNewServices({super.key});

  @override
  State<AddNewServices> createState() => _AddNewServicesState();
}

class _AddNewServicesState extends State<AddNewServices> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _serviceIncludedController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool isCat = true;
  bool isDog = true;
  final picker = ImagePicker();
  List<File> _images = [];

  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images = picked.map((img) => File(img.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add New Service'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Title',
                controller: _titleController,
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Description',
                controller: _descController,
                maxLines: 3,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Service Included',
                controller: _serviceIncludedController,
                maxLines: 3,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Notes',
                controller: _notesController,
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              Text("Prices",
                  style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text("Cats", style: TextStyle(fontSize: 14.sp)),
                  Switch(
                    value: isCat,
                    onChanged: (value) {
                      setState(() {
                        isCat = value;
                      });
                    },
                  ),
                  Spacer(),
                  Text("Dogs", style: TextStyle(fontSize: 14.sp)),
                  Switch(
                    value: isDog,
                    onChanged: (value) {
                      setState(() {
                        isDog = value;
                      });
                    },
                  ),
                ],
              ),
              if (isCat) priceSelector("Cats"),
              if (isDog) priceSelector("Dogs"),
              SizedBox(height: AppSizes.spaceBtwSections),
              Text("Upload Images", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: pickImages,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10.r),
                  dashPattern: [6, 4],
                  color: AppColors.dottedColor,
                  child: Container(
                    height: 100.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Attach Images',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.dottedColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              if (_images.isNotEmpty)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _images
                      .map((file) => Image.file(
                    file,
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ))
                      .toList(),
                ),
              SizedBox(height: AppSizes.spaceBtwSections),
              PrimaryButton(title: 'Save', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget priceSelector(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sizeButton("Small"),
            sizeButton("Medium"),
            sizeButton("Large"),
          ],
        ),
        SizedBox(height: AppSizes.spaceBtwInputFields),
      ],
    );
  }

  Widget sizeButton(String size) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(child: Text(size, style: TextStyle(fontSize: 13.sp))),
      ),
    );
  }
}
