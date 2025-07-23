import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';

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

  Widget buildLabel(String label) => Text(
    label,
   style: Theme.of(context).textTheme.titleMedium!.copyWith(
      color: AppColors.primary,
    ),
  );

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        borderSide: BorderSide(
          color: AppColors.textPrimaryColor,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        borderSide: BorderSide(
          color: AppColors.textPrimaryColor,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.service['title']),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildLabel('Title'),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                focusNode: titleFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(descriptionFocus),
                decoration: buildInputDecoration(),
              ),

              const SizedBox(height: 16),
              buildLabel('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                focusNode: descriptionFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(includedFocus),
                maxLines: 2,
                decoration: buildInputDecoration(),
              ),

              const SizedBox(height: 16),
              buildLabel('Service Included'),
              const SizedBox(height: 8),
              TextFormField(
                controller: includedController,
                focusNode: includedFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(notesFocus),
                maxLines: 4,
                decoration: buildInputDecoration(),
              ),

              const SizedBox(height: 16),
              buildLabel('Notes'),
              const SizedBox(height: 8),
              TextFormField(
                controller: notesController,
                focusNode: notesFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(priceFocus),
                decoration: buildInputDecoration(),
              ),

              const SizedBox(height: 16),
              buildLabel('Price'),
              const SizedBox(height: 8),
              TextFormField(
                controller: priceController,
                focusNode: priceFocus,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(),
              ),

              const SizedBox(height: 24),
              buildLabel('Upload Images'),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: pickImages,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  dashPattern: [6, 4],
                  color: AppColors.dottedColor,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                        'Attach Images',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.dottedColor,
                      ),
                    ),
                  ),
                )
              ),
              const SizedBox(height: 10),

              if (_images.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _images
                      .map((file) => Image.file(file, width: 60, height: 60, fit: BoxFit.cover))
                      .toList(),
                ),

              const SizedBox(height: 30),

              PrimaryButton(
                title: 'Update Service',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Add update logic here
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
