import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/utlis/constants/image_strings.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
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
            onPressed: (){
            Navigator.pop(context);
          }, child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.cart,
            ),
          ),),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : AssetImage(AppImages.person)
                      as ImageProvider,
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Text('Full Name',
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
                cursorColor:AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.textPrimaryColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
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
                ),
              ),
              SizedBox(height: 15,),
              Text('Email',
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
                cursorColor:AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'Your email',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.textPrimaryColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
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
                ),
              ),
              SizedBox(height: 15,),
              Text('Phone Number',
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
                keyboardType: TextInputType.phone,
                cursorColor:AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'Your phone number',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.textPrimaryColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
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
                ),
              ),
              SizedBox(height: 15,),
              Text('Address',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                // validator: (value) {
                //   if (value == null || value.isEmpty) return 'Email is required';
                //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                //   return null;
                // },
                keyboardType: TextInputType.streetAddress,
                cursorColor:AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'E /202 RatanSagarHeight',
                  hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.textPrimaryColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
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
                ),
              ),

              SizedBox(height: 15),
              PrimaryButton(title: 'Edit Profile',onPressed: (){},),
            ],
          ),
        ),
      ),
    );
  }
}
