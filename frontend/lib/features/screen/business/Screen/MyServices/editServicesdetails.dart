import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../provider/services_provider.dart';
import '../../../../../provider/category_provider.dart';
import '../../../../../models/service_model.dart';
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

  // Service availability state
  bool isCat = false;
  bool isDog = false;
  List<String> _catSizes = [];
  List<String> _dogSizes = [];
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.service['title']);
    descriptionController =
        TextEditingController(text: widget.service['description']);
    includedController =
        TextEditingController(text: widget.service['serviceIncluded']);
    notesController = TextEditingController(text: widget.service['notes']);
    priceController = TextEditingController(text: widget.service['price']);

    // Initialize availability data
    final availableFor = widget.service['availableFor'];
    if (availableFor != null) {
      _catSizes = List<String>.from(availableFor['cats'] ?? []);
      _dogSizes = List<String>.from(availableFor['dogs'] ?? []);
      isCat = _catSizes.isNotEmpty;
      isDog = _dogSizes.isNotEmpty;
    }

    // Initialize category
    _selectedCategoryId = widget.service['category'] is String
        ? widget.service['category']
        : widget.service['category']?['_id'];
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

  Future<void> _updateService(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Basic validation
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a service title')),
      );
      return;
    }

    // Prepare availability data
    final availability = ServiceAvailability(
      cats: isCat ? _catSizes : [],
      dogs: isDog ? _dogSizes : [],
    );

    // Create service request with updated data
    final serviceRequest = ServiceRequest(
      categoryId: _selectedCategoryId ?? 'default_category',
      title: titleController.text.trim(),
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      serviceIncluded: includedController.text.trim().isEmpty
          ? null
          : includedController.text.trim(),
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      price: priceController.text.trim().isEmpty
          ? null
          : priceController.text.trim(),
      availableFor: availability,
    );

    final servicesProvider = context.read<ServicesProvider>();
    final success = await servicesProvider.updateService(
      widget.service['id'] ?? '',
      serviceRequest,
      imageFiles: _images.isNotEmpty ? _images : null,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Service updated successfully')),
        );
        Get.back(); // Go back to services list
      } else {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
              content:
                  Text(servicesProvider.error ?? 'Failed to update service')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.service['title']),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.defaultPaddingHorizontal,
          vertical: AppSizes.defaultPaddingVertical,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'Title',
                controller: titleController,
                focusNode: titleFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(descriptionFocus),
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Description',
                controller: descriptionController,
                focusNode: descriptionFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(includedFocus),
                maxLines: 2,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Service Included',
                controller: includedController,
                focusNode: includedFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(notesFocus),
                maxLines: 4,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Notes',
                controller: notesController,
                focusNode: notesFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () =>
                    FocusScope.of(context).requestFocus(priceFocus),
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Price',
                controller: priceController,
                focusNode: priceFocus,
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
                            borderRadius:
                                BorderRadius.circular(AppSizes.cardRadiusSm),
                            child: Image.file(file,
                                width: 60.w, height: 60.w, fit: BoxFit.cover),
                          ))
                      .toList(),
                ),
              SizedBox(height: AppSizes.spaceBtwSections),
              Consumer<ServicesProvider>(
                builder: (context, servicesProvider, child) {
                  return PrimaryButton(
                    title: servicesProvider.isUpdating
                        ? 'Updating...'
                        : 'Update Service',
                    onPressed: servicesProvider.isUpdating
                        ? null
                        : () => _updateService(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14.sp,
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
          // Load categories if not loaded
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
