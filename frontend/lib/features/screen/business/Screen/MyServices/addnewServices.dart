import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../provider/services_provider.dart';
import '../../../../../provider/category_provider.dart';
import '../../../../../models/service_model.dart';
import '../../widgets/ImagePicker.dart';
import '../../widgets/custom_text_field.dart';

class AddNewServices extends StatefulWidget {
  const AddNewServices({super.key});

  @override
  State<AddNewServices> createState() => _AddNewServicesState();
}

class _AddNewServicesState extends State<AddNewServices> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _serviceIncludedController =
  TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool isCat = true;
  bool isDog = true;

  String? _selectedImagePath;

  String? _selectedCategoryId;
  List<String> _catSizes = [];
  List<String> _dogSizes = [];

  Future<void> _saveService(BuildContext context) async {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        'Please enter a service title',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    if (_selectedCategoryId == null) {
      Get.snackbar(
        "Error",
        'Please select a category',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
      return;
    }

    final availability = ServiceAvailability(
      cats: isCat ? _catSizes : [],
      dogs: isDog ? _dogSizes : [],
    );

    final serviceRequest = ServiceRequest(
      categoryId: _selectedCategoryId!,
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      serviceIncluded: _serviceIncludedController.text.trim().isEmpty
          ? null
          : _serviceIncludedController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      price: _priceController.text.trim().isEmpty
          ? null
          : _priceController.text.trim(),
      availableFor: availability,
    );

    final servicesProvider = context.read<ServicesProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await servicesProvider.createService(
      serviceRequest,
      imageFiles: (_selectedImagePath != null &&
          _selectedImagePath!.isNotEmpty)
          ? [File(_selectedImagePath!)]
          : null,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }

    if (mounted) {
      if (success) {
        Get.snackbar(
          "Success",
          'Service created successfully',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
        Get.back();
      } else {
        Get.snackbar(
          "Error",
          servicesProvider.error ?? 'Failed to create service',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
      }
    }
  }

  void _toggleSizeSelection(String size, bool isCatSize) {
    setState(() {
      if (isCatSize) {
        if (_catSizes.contains(size)) {
          _catSizes.remove(size);
        } else {
          _catSizes.add(size);
        }
      } else {
        if (_dogSizes.contains(size)) {
          _dogSizes.remove(size);
        } else {
          _dogSizes.add(size);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add New Service'),
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
              CustomTextField(
                label: 'Price',
                controller: _priceController,
                maxLines: 1,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              _buildCategoryDropdown(),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              Text("Prices",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
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
              Text("Upload Images",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
              SizedBox(height: 8.h),
              SingleImagePicker(
                onImagePicked: (path) {
                  setState(() {
                    _selectedImagePath = path;
                  });
                },
              ),
              SizedBox(height: AppSizes.spaceBtwSections),
              Consumer<ServicesProvider>(
                builder: (context, servicesProvider, child) {
                  return PrimaryButton(
                    title:
                    servicesProvider.isCreating ? 'Saving...' : 'Save',
                    onPressed: servicesProvider.isCreating
                        ? null
                        : () => _saveService(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget priceSelector(String label) {
    final isCatSize = label == "Cats";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sizeButton("Small", isCatSize),
            sizeButton("Medium", isCatSize),
            sizeButton("Large", isCatSize),
          ],
        ),
        SizedBox(height: AppSizes.spaceBtwInputFields),
      ],
    );
  }

  Widget sizeButton(String size, bool isCatSize) {
    final isSelected =
    isCatSize ? _catSizes.contains(size) : _dogSizes.contains(size);
    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleSizeSelection(size, isCatSize),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                fontSize: 13.sp,
                color: isSelected ? AppColors.primary : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.categories.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            categoryProvider.loadCategories();
          });
          return const CircularProgressIndicator();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              ),
              hint: const Text('Select a category'),
              items: categoryProvider.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
