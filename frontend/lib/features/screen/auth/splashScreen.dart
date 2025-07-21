import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:petcare/features/screen/auth/welcomeScreen.dart';

import '../../../utlis/constants/image_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5), () {
        // Debug print
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen(),));
      });
      // Safe to load data or open route after first render
    });
  }

  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background paw pattern
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.backGround),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo centered
            Padding(
            padding: EdgeInsets.only(
              top: 150,
              bottom: 250,
              left: 10,
              right: 10,
            ),
              child: Image.asset(
                AppImages.logo,
              ),
            ),
        ],
      ),
    );
  }
}
