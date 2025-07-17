import 'package:flutter/material.dart';
import 'package:petcare/features/screen/auth/register/widgets/registerform.dart';

import '../../../../utlis/constants/colors.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 54,
        
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New \nAccount.',
                style: TextStyle(
                  fontSize: 35,
                  color: AppColors.secondary,
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 30,),
              RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}
