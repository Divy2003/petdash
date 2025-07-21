import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../provider/auth_provider/forgot_password_provider.dart';
import 'otp_verification_screen.dart';

class RequestPasswordResetScreen extends StatefulWidget {
  @override
  State<RequestPasswordResetScreen> createState() =>
      _RequestPasswordResetScreenState();
}

class _RequestPasswordResetScreenState
    extends State<RequestPasswordResetScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> sendPasswordResetRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    final email = emailController.text.trim();

    final error = await provider.requestPasswordReset(email);

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reset code sent to your email")),
      );
      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpVerificationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForgotPasswordProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 54,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: AppColors.secondary),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Forgot\nPassword?',
                  style: TextStyle(
                    fontSize: 35,
                    color: AppColors.secondary,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),

                // Subtitle
                Text(
                  'Enter your email address and we\'ll send you a code to reset your password.',
                  style: TextStyle(
                    color: AppColors.textprimaryColor,
                    fontFamily: 'Encode Sans Expanded',
                    fontWeight: FontWeight.w400,
                    fontSize: AppSizes.fontSizeMd,
                  ),
                ),
                SizedBox(height: 40),

                // Email field
                Text(
                  'Email',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontFamily: 'Encode Sans Expanded',
                    fontWeight: FontWeight.w500,
                    fontSize: AppSizes.fontSizeMd,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Your email',
                    hintStyle: TextStyle(
                      color: AppColors.textprimaryColor,
                      fontFamily: 'Encode Sans Expanded',
                      fontWeight: FontWeight.w400,
                      fontSize: AppSizes.fontSizeLg,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLg),
                      borderSide: BorderSide(
                        color: AppColors.textprimaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLg),
                      borderSide: BorderSide(
                        color: AppColors.textprimaryColor,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLg),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),

                // Send button
                PrimaryButton(
                  onPressed:
                      provider.isLoading ? null : sendPasswordResetRequest,
                  title: provider.isLoading ? "Sending..." : "Send Reset Code",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
