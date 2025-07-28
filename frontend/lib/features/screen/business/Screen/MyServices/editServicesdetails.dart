import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../widgets/custom_text_field.dart';

class EditServicesDetails extends StatefulWidget {
  const EditServicesDetails({super.key, required this.service});
  final Map<String, dynamic> service;

  @override
  State<EditServicesDetails> createState() => _EditServicesDetailsState();
}

class _EditServicesDetailsState extends State<EditServicesDetails> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController includedController;
  late TextEditingController notesController;
  late TextEditingController priceController;

  final FocusNode titleFocus = FocusNode();
  final FocusNode descriptionFocus = FocusNode();
  final FocusNode includedFocus = FocusNode();
  final FocusNode notesFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.service['title']);
    descriptionController = TextEditingController(text: widget.service['description']);
    includedController = TextEditingController();
    notesController = TextEditingController();
    priceController = TextEditingController(text: widget.service['price']);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    includedController.dispose();
    notesController.dispose();
    priceController.dispose();

    titleFocus.dispose();
    descriptionFocus.dispose();
    includedFocus.dispose();
    notesFocus.dispose();
    priceFocus.dispose();

    super.dispose();
  }

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
      appBar: CustomAppBar(title: widget.service['title']),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.defaultPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'Title',
                controller: titleController,
                focusNode: titleFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(descriptionFocus),
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),

              CustomTextField(
                label: 'Description',
                controller: descriptionController,
                focusNode: descriptionFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(includedFocus),
                maxLines: 2,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),

              CustomTextField(
                label: 'Service Included',
                controller: includedController,
                focusNode: includedFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(notesFocus),
                maxLines: 4,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),

              CustomTextField(
                label: 'Notes',
                controller: notesController,
                focusNode: notesFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(priceFocus),
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),

              CustomTextField(
                label: 'Price',
                controller: priceController,
                focusNode: priceFocus,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSizes.spaceBtwSections),

              Text(
                'Upload Images',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppSizes.sm),

              GestureDetector(
                onTap: pickImages,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(AppSizes.borderRadiusMd),
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
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.sm),

              if (_images.isNotEmpty)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _images
                      .map((file) => ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
                    child: Image.file(file,
                        width: 60.w, height: 60.w, fit: BoxFit.cover),
                  ))
                      .toList(),
                ),

              SizedBox(height: AppSizes.spaceBtwSections),

              PrimaryButton(
                title: 'Update Service',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Service Updated")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
