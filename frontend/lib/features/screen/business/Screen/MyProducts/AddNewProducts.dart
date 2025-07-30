import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart'; // AppSizes used here
import '../../widgets/ImagePicker.dart';
import '../../widgets/custom_text_field.dart';

class AddNewProducts extends StatefulWidget {
  const AddNewProducts({super.key});

  @override
  State<AddNewProducts> createState() => _AddNewProductsState();
}

class _AddNewProductsState extends State<AddNewProducts> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _priceController = TextEditingController();
  final _shippingController = TextEditingController();
  final _monthlyDeliveryController = TextEditingController();

  final FocusNode _focusTitle = FocusNode();
  final FocusNode _focusDesc = FocusNode();
  final FocusNode _focusManu = FocusNode();
  final FocusNode _focusPrice = FocusNode();
  final FocusNode _focusShipping = FocusNode();
  final FocusNode _focusMonthly = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _manufacturerController.dispose();
    _priceController.dispose();
    _shippingController.dispose();
    _monthlyDeliveryController.dispose();

    _focusTitle.dispose();
    _focusDesc.dispose();
    _focusManu.dispose();
    _focusPrice.dispose();
    _focusShipping.dispose();
    _focusMonthly.dispose();

    super.dispose();
  }

  void _saveProduct() {
    // TODO: Add API integration here
    debugPrint("Saving Product...");
    debugPrint("Title: ${_titleController.text}");
    debugPrint("Description: ${_descController.text}");
    debugPrint("Manufacturer: ${_manufacturerController.text}");
    debugPrint("Price: ${_priceController.text}");
    debugPrint("Shipping Cost: ${_shippingController.text}");
    debugPrint("Monthly Delivery: ${_monthlyDeliveryController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add New Product'),
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
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(_focusDesc),
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              CustomTextField(
                label: 'Description',
                controller: _descController,
                focusNode: _focusDesc,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(_focusManu),
                maxLines: 4,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              CustomTextField(
                label: 'Manufacturer',
                controller: _manufacturerController,
                focusNode: _focusManu,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(_focusPrice),
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              CustomTextField(
                label: 'Price',
                controller: _priceController,
                focusNode: _focusPrice,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(_focusShipping),
                keyboardType: TextInputType.number,
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwItems),

              CustomTextField(
                label: 'Shipping Cost',
                controller: _shippingController,
                focusNode: _focusShipping,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(_focusMonthly),
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
              SizedBox(height: AppSizes.spaceBtwItems),

              /// 🖼️ Multiple Image Picker
              MultipleImagePicker(),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// ✅ Save Button
              PrimaryButton(
                title: "Save",
                onPressed: _saveProduct,
              ),
              SizedBox(height: AppSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
