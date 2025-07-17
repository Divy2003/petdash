import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'customtheme/texttheme.dart';


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // primaryColor:  Color(0xFF6A1B9A),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: AppTextTheme.textTheme,
    // inputDecorationTheme: InputDecorationTheme(
    //   border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    // ),
  );
}