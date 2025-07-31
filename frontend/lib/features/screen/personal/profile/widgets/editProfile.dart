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

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

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
      body: SingleChildScrollView(
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
                            backgroundImage: _profileImageFile != null
                                ? FileImage(_profileImageFile!)
                                : (_profile?.profileImage != null
                                        ? NetworkImage(_profile!.profileImage!)
                                        : AssetImage(AppImages.person))
                                    as ImageProvider,
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

                    // Business-specific fields
                    if (_profile?.isBusiness == true) ...[
                      Text(
                        'Shop Image',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: _pickShopImage,
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.textPrimaryColor),
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadiusLg),
                          ),
                          child: _shopImageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.borderRadiusLg),
                                  child: Image.file(_shopImageFile!,
                                      fit: BoxFit.cover),
                                )
                              : (_profile?.shopImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.borderRadiusLg),
                                      child: Image.network(_profile!.shopImage!,
                                          fit: BoxFit.cover),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate,
                                            size: 40,
                                            color: AppColors.textPrimaryColor),
                                        SizedBox(height: 8),
                                        Text('Add Shop Image',
                                            style: TextStyle(
                                                color: AppColors
                                                    .textPrimaryColor)),
                                      ],
                                    )),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Shop Opening Time',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: shopOpenTimeController,
                        readOnly: true,
                        onTap: () => _selectTime(
                            shopOpenTimeController, 'Shop Opening Time'),
                        decoration: InputDecoration(
                          hintText: 'Select opening time',
                          suffixIcon: Icon(Icons.access_time),
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
                                color: AppColors.textPrimaryColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadiusLg),
                            borderSide: BorderSide(
                                color: AppColors.textPrimaryColor, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Shop Closing Time',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: shopCloseTimeController,
                        readOnly: true,
                        onTap: () => _selectTime(
                            shopCloseTimeController, 'Shop Closing Time'),
                        decoration: InputDecoration(
                          hintText: 'Select closing time',
                          suffixIcon: Icon(Icons.access_time),
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
                                color: AppColors.textPrimaryColor, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadiusLg),
                            borderSide: BorderSide(
                                color: AppColors.textPrimaryColor, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],

                    PrimaryButton(
                      title:  'Update Profile',
                      onPressed:(){

                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
