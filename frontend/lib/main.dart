import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/provider/auth_provider/loginprovider.dart';
import 'package:petcare/provider/auth_provider/registerprovider.dart';
import 'package:petcare/provider/auth_provider/forgot_password_provider.dart';
import 'package:petcare/provider/appointment_provider/appointment_booking_provider.dart';
import 'package:petcare/provider/category_provider.dart';
import 'package:petcare/provider/business_provider.dart';
import 'package:petcare/provider/location_provider.dart';
import 'package:petcare/provider/services_provider.dart';
import 'package:petcare/provider/profile_provider.dart';

import 'package:petcare/utlis/theme/Theme.dart';
import 'package:provider/provider.dart';

import 'features/screen/auth/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize login provider and load token
  final loginProvider = LoginProvider();
  await loginProvider.initToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider.value(value: loginProvider),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentBookingProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
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
      designSize: const Size(360, 750), // Set based on your design mockup
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
