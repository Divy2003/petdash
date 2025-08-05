import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/Button/primarybutton.dart';
import '../../../../utlis/constants/size.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/app_config/app_config.dart';
import '../../../../models/profile_model.dart';
import '../../../../provider/profile_provider.dart';
import '../widgets/custom_text_field.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _shopOpenTimeController = TextEditingController();
  final TextEditingController _shopCloseTimeController =
      TextEditingController();

  // Image files
  File? _profileImageFile;
  File? _shopImageFile;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _shopOpenTimeController.dispose();
    _shopCloseTimeController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getProfile();

    if (profileProvider.profile != null) {
      final profile = profileProvider.profile!;
      _nameController.text = profile.name ?? '';
      _emailController.text = profile.email ?? '';
      _phoneController.text = profile.phoneNumber ?? '';
      _shopOpenTimeController.text = profile.shopOpenTime ?? '';
      _shopCloseTimeController.text = profile.shopCloseTime ?? '';
    }
  }

  Future<void> _pickProfileImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _profileImageFile = File(picked.path);
      });
    }
  }

  Future<void> _pickShopImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _shopImageFile = File(picked.path);
      });
    }
  }

  Future<void> _selectTime(
      TextEditingController controller, String label) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      controller.text = formattedTime;
    }
  }

  Future<void> _testServerConnection() async {
    try {
      print('🔍 Testing server connectivity...');
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('🌐 Server connectivity test: ${response.statusCode}');

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Server is reachable ✅',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
      } else {
        Get.snackbar(
          'Warning',
          'Server responded with status: ${response.statusCode}',
          backgroundColor: AppColors.warning,
          colorText: AppColors.white,
        );
      }
    } catch (e) {
      print('❌ Server connectivity failed: $e');
      Get.snackbar(
        'Error',
        'Server is not reachable ❌\nError: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      await profileProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        shopOpenTime: _shopOpenTimeController.text.trim(),
        shopCloseTime: _shopCloseTimeController.text.trim(),
        profileImageFile: _profileImageFile,
        shopImageFile: _shopImageFile,
      );

      if (profileProvider.error == null) {
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        Get.snackbar(
          'Error',
          profileProvider.error!,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Business Profile'),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading && profileProvider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Section
                    _buildImageSection(
                      title: 'Profile Image',
                      imageFile: _profileImageFile,
                      existingImageUrl: profileProvider.profile?.profileImage,
                      onTap: _pickProfileImage,
                    ),

                    SizedBox(height: AppSizes.spaceBtwSections),

                    // Shop Image Section
                    _buildImageSection(
                      title: 'Shop Image',
                      imageFile: _shopImageFile,
                      existingImageUrl: profileProvider.profile?.shopImage,
                      onTap: _pickShopImage,
                    ),

                    SizedBox(height: AppSizes.spaceBtwSections),

                    // Basic Information
                    Text(
                      'Basic Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    SizedBox(height: AppSizes.spaceBtwItems),

                    // Name Field
                    CustomTextField(
                      label: 'Business Name',
                      controller: _nameController,
                      hintText: 'Enter your business name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Business name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizes.spaceBtwInputFields),

                    // Email Field
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      hintText: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!GetUtils.isEmail(value.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizes.spaceBtwInputFields),

                    // Phone Field
                    CustomTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizes.spaceBtwSections),

                    // Shop Hours
                    Text(
                      'Shop Hours',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    SizedBox(height: AppSizes.spaceBtwItems),

                    // Opening Time
                    CustomTextField(
                      label: 'Opening Time',
                      controller: _shopOpenTimeController,
                      hintText: 'Select opening time',
                      readOnly: true,
                      onTap: () =>
                          _selectTime(_shopOpenTimeController, 'Opening Time'),
                      suffixIcon:
                          Icon(Icons.access_time, color: AppColors.primary),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Opening time is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizes.spaceBtwInputFields),

                    // Closing Time
                    CustomTextField(
                      label: 'Closing Time',
                      controller: _shopCloseTimeController,
                      hintText: 'Select closing time',
                      readOnly: true,
                      onTap: () =>
                          _selectTime(_shopCloseTimeController, 'Closing Time'),
                      suffixIcon:
                          Icon(Icons.access_time, color: AppColors.primary),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Closing time is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizes.spaceBtwSections),

                    // Save Button
                    PrimaryButton(
                      title: _isLoading ? 'Saving...' : 'Save Profile',
                      onPressed: _isLoading ? null : _saveProfile,
                    ),
                    SizedBox(height: AppSizes.sm),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection({
    required String title,
    required File? imageFile,
    required String? existingImageUrl,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
        SizedBox(height: AppSizes.spaceBtwItems),
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(AppSizes.borderRadiusLg),
            dashPattern: const [6, 4],
            color: AppColors.primary,
            strokeWidth: 2,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                color: AppColors.grey.withValues(alpha: 0.1),
              ),
              child: imageFile != null
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLg),
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : existingImageUrl != null
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          child: Image.network(
                            '${AppConfig.baseFileUrl}$existingImageUrl',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder();
                            },
                          ),
                        )
                      : _buildImagePlaceholder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: AppColors.primary,
        ),
        SizedBox(height: AppSizes.xs),
        Text(
          'Tap to select image',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }
}
