import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/image_strings.dart';

import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/size.dart';
import 'login/loginscreen.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 120,),
          Image.asset(
            AppImages.welcome,
            height: 400,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 50,),
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(height: 10,),
          Text(
            'All types of services for your pet in one place, instantly searchable.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: AppSizes.fontSizeMd,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(height: 50,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // responsive radius
              ),
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            },
            child: Text(
              "Let's Get Started",
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSizes.fontSizeSm,
              ),
            ),
          )
        ],
      ),
    );
  }
}


