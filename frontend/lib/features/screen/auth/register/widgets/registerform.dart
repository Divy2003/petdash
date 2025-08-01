import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:petcare/features/screen/auth/login/loginscreen.dart';
import 'package:petcare/features/screen/business/BusinessProfileScreen.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../provider/auth_provider/registerprovider.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../Navigation.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    final provider = Provider.of<RegisterProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      // Check if user type is selected
      if (provider.selectedType == null) {
        Get.snackbar(
          "Error",
          "Please select a user type",
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      final error = await provider.registerUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (mounted) {
        if (error == null) {
          Get.snackbar(
            "Success",
            "Signup successful! Please login to continue.",
            backgroundColor: AppColors.success,
            colorText: AppColors.white,
          );

          // Debug print
          print("Registration successful! User type: ${provider.selectedType}");

          // Add a small delay to ensure the snackbar is shown
          await Future.delayed(const Duration(milliseconds: 1500));

          // Navigate to login screen after successful registration
          print("Navigating to Login Screen");
          Get.offAll(() => const LoginScreen());
        } else {
          print("Registration error: $error");
          Get.snackbar(
            "Error",
            error,
            backgroundColor: AppColors.error,
            colorText: AppColors.white,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                  'Your email',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Your email',
                    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                  'Password',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                  'User Type',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          registerProvider.setUserType(UserType.petOwner);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: registerProvider.selectedType ==
                                    UserType.petOwner
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border.all(
                              color: registerProvider.selectedType ==
                                      UserType.petOwner
                                  ? AppColors.primary
                                  : AppColors.textPrimaryColor,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadiusLg),
                          ),
                          child: Center(
                            child: Text(
                              'Pet Owner',
                              style: TextStyle(
                                color: registerProvider.selectedType ==
                                        UserType.petOwner
                                    ? AppColors.primary
                                    : AppColors.textPrimaryColor,
                                fontFamily: 'Encode Sans Expanded',
                                fontWeight: FontWeight.w500,
                                fontSize: AppSizes.fontSizeLg,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 23),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          registerProvider.setUserType(UserType.business);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: registerProvider.selectedType ==
                                    UserType.business
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border.all(
                              color: registerProvider.selectedType ==
                                      UserType.business
                                  ? AppColors.primary
                                  : AppColors.textPrimaryColor,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadiusLg),
                          ),
                          child: Center(
                            child: Text(
                              'Business',
                              style: TextStyle(
                                color: registerProvider.selectedType ==
                                        UserType.business
                                    ? AppColors.primary
                                    : AppColors.textPrimaryColor,
                                fontFamily: 'Encode Sans Expanded',
                                fontWeight: FontWeight.w500,
                                fontSize: AppSizes.fontSizeLg,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 52),
                PrimaryButton(
                  onPressed: () async {
                    await submitForm(); // Navigation is handled inside submitForm
                  },
                  title: 'Sign-up',
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: Row(
                    children: const [
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: AppColors.dividerColor,
                      )),
                      SizedBox(
                        width: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: AppColors.dividerColor,
                            fontFamily: 'Encode Sans Expanded',
                            fontWeight: FontWeight.w400,
                            fontSize: AppSizes.fontSizeLg,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                          child: Divider(
                              thickness: 1, color: AppColors.dividerColor)),
                    ],
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                // Google button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  width: 350,
                  height: 50, // responsive height
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusMd),
                    border: Border.all(
                      color: AppColors.textPrimaryColor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.google,
                        height: 30,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Log-in with Google',
                        style: TextStyle(
                          color: AppColors.textPrimaryColor,
                          fontFamily: 'Encode Sans Expanded',
                          fontWeight: FontWeight.w500,
                          fontSize: AppSizes.fontSizeLg,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                // facebook button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  width: 350,
                  height: 50, // responsive height
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusMd),
                    color: Color(0xFF3B5998),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.facebook,
                        height: 30,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Log-in with facebook',
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Encode Sans Expanded',
                          fontWeight: FontWeight.w500,
                          fontSize: AppSizes.fontSizeLg,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                // Register sign button,
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already Have an Account?",
                      style: TextStyle(
                        color: AppColors.textPrimaryColor,
                        fontSize: AppSizes.fontSizeSm,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Encode Sans Expanded',
                      ),
                      children: [
                        TextSpan(
                          text: "Log-in",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: AppSizes.fontSizeSm,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Encode Sans Expanded',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const LoginScreen());
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
