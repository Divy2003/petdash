import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/provider/auth_provider/loginprovider.dart';
import 'package:petcare/provider/auth_provider/registerprovider.dart';
import 'package:petcare/provider/auth_provider/forgot_password_provider.dart';
import 'package:petcare/utlis/theme/Theme.dart';
import 'package:provider/provider.dart';

import 'features/screen/auth/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Set based on your design mockup
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
