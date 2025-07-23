import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../provider/auth_provider/forgot_password_provider.dart';
import 'new_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String getOtpCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOtp() async {
    final otpCode = getOtpCode();
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter the complete 6-digit code")),
      );
      return;
    }

    final provider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    final error = await provider.verifyOtp(otpCode);

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP verified successfully")),
      );
      // Navigate to new password screen and pass the OTP
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NewPasswordScreen(otpCode: otpCode)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> resendOtp() async {
    final provider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    final error = await provider.resendOtp();

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("New code sent to your email")),
      );
      // Clear current OTP fields
      for (var controller in otpControllers) {
        controller.clear();
      }
      focusNodes[0].requestFocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Widget buildOtpField(int index) {
    return Container(
      width: 50,
      height: 60,
      child: TextFormField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: AppColors.primary,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            borderSide: BorderSide(
              color: AppColors.textPrimaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            borderSide: BorderSide(
              color: AppColors.textPrimaryColor,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
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
                  'Verify\nCode',
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
                  'Enter the 6-digit code sent to ${provider.email ?? 'your email'}',
                  style: TextStyle(
                    color: AppColors.textPrimaryColor,
                    fontFamily: 'Encode Sans Expanded',
                    fontWeight: FontWeight.w400,
                    fontSize: AppSizes.fontSizeMd,
                  ),
                ),
                SizedBox(height: 40),

                // OTP Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) => buildOtpField(index)),
                ),
                SizedBox(height: 30),

                // Resend code
                Center(
                  child: TextButton(
                    onPressed: provider.isLoading ? null : resendOtp,
                    child: Text(
                      'Didn\'t receive code? Resend',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: 'Encode Sans Expanded',
                        fontWeight: FontWeight.w500,
                        fontSize: AppSizes.fontSizeMd,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Verify button
                PrimaryButton(
                  onPressed: provider.isLoading ? null : verifyOtp,
                  title: provider.isLoading ? "Verifying..." : "Verify Code",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
