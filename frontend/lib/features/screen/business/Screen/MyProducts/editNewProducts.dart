import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/utlis/constants/image_strings.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../widgets/ImagePicker.dart';
import '../../widgets/custom_text_field.dart';

class EditNewProducts extends StatefulWidget {
  const EditNewProducts({super.key});

  @override
  State<EditNewProducts> createState() => _EditNewProductsState();
}

class _EditNewProductsState extends State<EditNewProducts> {
  final _titleController = TextEditingController(text: "Merrick Grain Free");
  final _descController = TextEditingController(text: "Grain-free dry food for dogs.");
  final _manufacturerController = TextEditingController(text: "Merrick");
  final _priceController = TextEditingController(text: "59.99");
  final _shippingController = TextEditingController(text: "5.00");
  final _monthlyDeliveryController = TextEditingController(text: "3.00");

  final FocusNode _focusTitle = FocusNode();
  final FocusNode _focusDesc = FocusNode();
  final FocusNode _focusManu = FocusNode();
  final FocusNode _focusPrice = FocusNode();
  final FocusNode _focusShipping = FocusNode();
  final FocusNode _focusMonthly = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titleController.text),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.defaultPaddingHorizontal,
            vertical: AppSizes.defaultPaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Title',
                controller: _titleController,
                focusNode: _focusTitle,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(_focusDesc),
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              CustomTextField(
                label: 'Description',
                controller: _descController,
                focusNode: _focusDesc,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(_focusManu),
                maxLines: 4,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              CustomTextField(
                label: 'Manufacturer',
                controller: _manufacturerController,
                focusNode: _focusManu,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(_focusPrice),
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              CustomTextField(
                label: 'Price',
                controller: _priceController,
                focusNode: _focusPrice,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(_focusShipping),
                keyboardType: TextInputType.number,
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              CustomTextField(
                label: 'Shipping Cost',
                controller: _shippingController,
                focusNode: _focusShipping,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(_focusMonthly),
                keyboardType: TextInputType.number,
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              CustomTextField(
                label: 'Monthly Delivery Price (Optional)',
                controller: _monthlyDeliveryController,
                focusNode: _focusMonthly,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: () => FocusScope.of(context).unfocus(),
                keyboardType: TextInputType.number,
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// Image Picker
              MultipleImagePicker(),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// Save Button
              PrimaryButton(
                title: "Save",
                onPressed: () {
                  debugPrint('Saving updated product...');
                  // Add validation or API call logic
                },
              ),
              SizedBox(height: AppSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
