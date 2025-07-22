import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:petcare/features/screen/auth/login/widgets/requestpasswordreset.dart';
import 'package:petcare/features/screen/auth/register/registerScreen.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/image_strings.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../provider/auth_provider/loginprovider.dart';
import '../../../Navigation.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  @override
  void initState() {
    super.initState();

    emailFocus.addListener(() {
      setState(() => isEmailFocused = emailFocus.hasFocus);
    });

    passwordFocus.addListener(() {
      setState(() => isPasswordFocused = passwordFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Future<void> submit() async{
    final provider =
    Provider.of<LoginProvider>(context, listen: false);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final error = await provider.login(email, password);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CurvedNavScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocus,
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
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLg),
                      borderSide: BorderSide(
                        color: AppColors.textprimaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  cursorColor: AppColors.primary,
                  controller: passwordController,
                  focusNode: passwordFocus,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusLg),
                      borderSide: BorderSide(
                        color: AppColors.textprimaryColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password is required';
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),

          //forget password?
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RequestPasswordResetScreen()),
                );
              },
              child: Text(
                'Forgot Password ?',
                style: TextStyle(
                  color: AppColors.textprimaryColor,
                  fontFamily: 'Encode Sans Expanded',
                  fontWeight: FontWeight.w400,
                  fontSize: AppSizes.fontSizeSm,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          PrimaryButton(
             onPressed: loginProvider.isLoading ? null : submit,
            title: 'Log-in',
          ),
          // Login  button

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
                    child:
                        Divider(thickness: 1, color: AppColors.dividerColor)),
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
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
              border: Border.all(
                color: AppColors.textprimaryColor,
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
                    color: AppColors.textprimaryColor,
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
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account yet?",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: AppSizes.fontSizeMd,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()));
                  },
                  child: Text(
                    " Sign Up",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: AppSizes.fontSizeMd,
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
