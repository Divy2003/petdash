import 'package:flutter/material.dart';
import 'package:petcare/features/screen/auth/login/widgets/loginform.dart';
import 'package:petcare/utlis/constants/colors.dart';

import '../../../../utlis/constants/size.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.defaultPaddingHorizontal,
              vertical: 54,

            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome \nBack!',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwSections,),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
