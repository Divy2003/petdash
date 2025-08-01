import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/utlis/constants/image_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../services/BusinessServices/products_services.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../model/addproductsmodel.dart';
import '../../widgets/ImagePicker.dart';
import '../../widgets/custom_text_field.dart';

class EditNewProducts extends StatefulWidget {
  final ProductRequest? product;

  const EditNewProducts({super.key, this.product});

  @override
  State<EditNewProducts> createState() => _EditNewProductsState();
}

class _EditNewProductsState extends State<EditNewProducts> {
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
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    if (widget.product != null) {
      _titleController.text = widget.product!.name;
      _descController.text = widget.product!.description;
      _manufacturerController.text = widget.product!.manufacturer;
      _priceController.text = widget.product!.price.toString();
      _shippingController.text = widget.product!.shippingCost.toString();
      _monthlyDeliveryController.text = widget.product!.monthlyDeliveryPrice?.toString() ?? '';
    }
  }

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

  void _saveProduct() async {
    try {
      // Validate required fields
      if (_titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Product title is required")),
        );
        return;
      }

      if (_priceController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Product price is required")),
        );
        return;
      }

      // Get the authentication token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Authentication required. Please login again.")),
        );
        return;
      }

      if (widget.product?.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Product ID not found")),
        );
        return;
      }

      final updatedProduct = ProductRequest(
        id: widget.product!.id,
        name: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        manufacturer: _manufacturerController.text.trim(),
        shippingCost: double.tryParse(_shippingController.text.trim()) ?? 0,
        monthlyDeliveryPrice: double.tryParse(_monthlyDeliveryController.text.trim()),
        brand: widget.product!.brand,
        itemWeight: widget.product!.itemWeight,
        itemForm: widget.product!.itemForm,
        ageRange: widget.product!.ageRange,
        breedRecommendation: widget.product!.breedRecommendation,
        dietType: widget.product!.dietType,
        images: widget.product!.images,
        stock: widget.product!.stock,
        subscriptionAvailable: widget.product!.subscriptionAvailable,
        category: widget.product!.category,
      );

      final success = await ProductApiService.updateProduct(
        token: token,
        productId: widget.product!.id!,
        product: updatedProduct,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Product updated successfully")),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to update product")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.product?.name ?? 'Edit Product'),
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
              SingleImagePicker(),
              SizedBox(height: AppSizes.spaceBtwSections),

              /// Save Button
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
