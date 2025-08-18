import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/utlis/constants/image_strings.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../services/BusinessServices/profile_service.dart';
import '../../../../../models/profile_model.dart';
import '../../../../../utlis/helpers/image_helper.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel? initialProfile;

  const EditProfile({super.key, this.initialProfile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final shopOpenTimeController = TextEditingController();
  final shopCloseTimeController = TextEditingController();

  File? _profileImageFile;
  File? _shopImageFile;
  ProfileModel? _profile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Use initial profile if provided, otherwise fetch from service
      ProfileModel? profile = widget.initialProfile;
      profile ??= await ProfileService.getProfile();

      if (profile != null) {
        setState(() {
          _profile = profile;
          nameController.text = profile!.name ?? '';
          emailController.text = profile.email ?? '';
          phoneNumberController.text = profile.phoneNumber ?? '';
          addressController.text = profile.primaryAddress?.streetName ?? '';
          shopOpenTimeController.text = profile.shopOpenTime ?? '';
          shopCloseTimeController.text = profile.shopCloseTime ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    shopOpenTimeController.dispose();
    shopCloseTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImageFile = File(picked.path);
      });
    }
  }

  Future<void> _pickShopImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _shopImageFile = File(picked.path);
      });
    }
  }

  ImageProvider _getProfileImageProvider() {
    if (_profileImageFile != null) {
      return FileImage(_profileImageFile!);
    } else if (_profile?.profileImage != null &&
        _profile!.profileImage!.isNotEmpty) {
      final imageUrl = ImageHelper.getImageUrl(_profile!.profileImage!);
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(AppImages.person);
    }
  }

  Widget _getShopImageWidget() {
    if (_shopImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        child: Image.file(_shopImageFile!, fit: BoxFit.cover),
      );
    } else if (_profile?.shopImage != null && _profile!.shopImage!.isNotEmpty) {
      final imageUrl = ImageHelper.getImageUrl(_profile!.shopImage!);
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 40, color: AppColors.textPrimaryColor),
                SizedBox(height: 8),
                Text('Failed to load image',
                    style: TextStyle(color: AppColors.textPrimaryColor)),
              ],
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate,
              size: 40, color: AppColors.textPrimaryColor),
          SizedBox(height: 8),
          Text('Add Shop Image',
              style: TextStyle(color: AppColors.textPrimaryColor)),
        ],
      );
    }
  }

  Future<void> _selectTime(
      TextEditingController controller, String label) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      final formattedTime = picked.format(context);
      controller.text = formattedTime;
    }
  }

  Future<void> _updateProfile() async {
    if (_isSaving) return;

    try {
      setState(() {
        _isSaving = true;
      });

      final updatedProfile = await ProfileService.updateProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        // Business-only fields removed for pet owner edit
        shopOpenTime: null,
        shopCloseTime: null,
        profileImageFile: _profileImageFile,
        shopImageFile: null, // hide/remove shop image for pet owner
        streetName: addressController.text.trim(),
      );

      if (updatedProfile != null) {
        setState(() {
          _profile = updatedProfile;
          _profileImageFile = null;
          _shopImageFile = null;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.cart,
                  ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _getProfileImageProvider(),
                          ),
                          GestureDetector(
                            onTap: _pickProfileImage,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.camera_alt,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Full Name',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: nameController,
                      // validator: (value) {
                      //   if (value == null || value.trim().isEmpty) {
                      //     return 'Name is required';
                      //   }
                      //   return null;
                      // },
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: 'Your name',
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: AppColors.textPrimaryColor,
                                ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: emailController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) return 'Email is required';
                      //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                      //   return null;
                      // },
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: 'Your email',
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: AppColors.textPrimaryColor,
                                ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Phone Number',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: phoneNumberController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) return 'Email is required';
                      //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                      //   return null;
                      // },
                      keyboardType: TextInputType.phone,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: 'Your phone number',
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: AppColors.textPrimaryColor,
                                ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Address',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: addressController,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) return 'Email is required';
                      //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                      //   return null;
                      // },
                      keyboardType: TextInputType.streetAddress,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: 'E /202 RatanSagarHeight',
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: AppColors.textPrimaryColor,
                                ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadiusLg),
                          borderSide: BorderSide(
                            color: AppColors.textPrimaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Business-specific fields are hidden for pet owner edit screen
                    // If you ever want them back for Business mode, re-add behind a role check
                    // like: if (_profile?.isBusiness == true) ...[ ... ]
                    // (intentionally removed)


                    PrimaryButton(
                      title: _isSaving ? 'Updating...' : 'Update Profile',
                      onPressed: _isSaving ? null : _updateProfile,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
