import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../services/BusinessServices/products_services.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart'; // AppSizes used here
import '../../model/addproductsmodel.dart';
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
  String? _selectedImagePath;

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
        Get.snackbar(
          "Error",
          "❌ Product title is required",
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      if (_priceController.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "❌ Product price is required",
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      // Get the authentication token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userType = prefs.getString('user_type');

      if (token == null || token.isEmpty) {
        Get.snackbar(
          "Error",
          "❌ Authentication required. Please login again.",
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      // Check if user has business access
      if (userType != "Business") {
        Get.snackbar(
          "Error",
          "❌ Business account required to create products.",
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      final product = ProductRequest(
        name: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        manufacturer: _manufacturerController.text.trim(),
        shippingCost: double.tryParse(_shippingController.text.trim()) ?? 0,
        monthlyDeliveryPrice:
            double.tryParse(_monthlyDeliveryController.text.trim()),
        brand: "", // Add dropdown/textfield if required
        itemWeight: "",
        itemForm: "",
        ageRange: "",
        breedRecommendation: "",
        dietType: "",
        images: _selectedImagePath != null && _selectedImagePath!.isNotEmpty
            ? [_selectedImagePath!]
            : [],
        stock: 0,
        subscriptionAvailable: false,
        category: "",
      );

      final success = await ProductApiService.createProduct(
        token: token,
        product: product,
      );

      if (success) {
        Get.snackbar(
          "Success",
          "✅ Product saved successfully",
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        Get.snackbar(
          "Error",
          "❌ Failed to save product",
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "❌ Error: ${e.toString()}",
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
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
              SingleImagePicker(
                onImagePicked: (path) {
                  setState(() {
                    _selectedImagePath = path;
                  });
                },
              ),
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
