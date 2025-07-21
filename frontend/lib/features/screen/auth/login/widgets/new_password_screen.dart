import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../provider/auth_provider/forgot_password_provider.dart';
import '../loginscreen.dart';

class NewPasswordScreen extends StatefulWidget {
  final String otpCode;

  const NewPasswordScreen({Key? key, required this.otpCode}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    final newPassword = passwordController.text.trim();

    // Use the OTP passed from the previous screen

    final error = await provider.resetPassword(widget.otpCode, newPassword);

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset successfully")),
      );
      // Navigate back to login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
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
                  'Create New Password',
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
                  'Your new password must be different from previously used passwords.',
                  style: TextStyle(
                    color: AppColors.textprimaryColor,
                    fontFamily: 'Encode Sans Expanded',
                    fontWeight: FontWeight.w400,
                    fontSize: AppSizes.fontSizeMd,
                  ),
                ),
                SizedBox(height: 40),

                // New Password field
                Text(
                  'New Password',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontFamily: 'Encode Sans Expanded',
                    fontWeight: FontWeight.w500,
                    fontSize: AppSizes.fontSizeMd,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textprimaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Confirm Password field
                Text(
                  'Confirm Password',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontFamily: 'Encode Sans Expanded',
                    fontWeight: FontWeight.w500,
                    fontSize: AppSizes.fontSizeMd,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Confirm new password',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textprimaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),

                // Reset Password button
                PrimaryButton(
                  onPressed: provider.isLoading ? null : resetPassword,
                  title: provider.isLoading ? "Resetting..." : "Reset Password",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
