import 'package:flutter/material.dart';

import '../../constants/size.dart';

class AppTextTheme {
  static TextTheme get textTheme => const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Playfair Display',
      fontWeight: FontWeight.w700,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Playfair Display',
      fontWeight: FontWeight.w600,
      fontSize: 28,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Playfair Display',
      fontWeight: FontWeight.w500,
      fontSize: AppSizes.fontSizeXl,
    ),
    titleLarge: TextStyle(
      fontFamily: 'EncodeSansExpanded',
      fontWeight: FontWeight.w600,
      fontSize: AppSizes.fontSizeLg,
    ),
    titleMedium: TextStyle(
      fontFamily: 'EncodeSansExpanded',
      fontWeight: FontWeight.w500,
      fontSize: AppSizes.fontSizeLg,
    ),
    titleSmall: TextStyle(
      fontFamily: 'EncodeSansExpanded',
      fontWeight: FontWeight.w400,
      fontSize: AppSizes.fontSizeMd,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'EncodeSansExpanded',
      fontWeight: FontWeight.w400,
      fontSize: AppSizes.fontSizeMd,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'EncodeSansExpanded',
      fontWeight: FontWeight.w400,
      fontSize: AppSizes.fontSizeSm,
    ),
    bodySmall: TextStyle(
      fontFamily: 'EncodeSansExpanded',
      fontWeight: FontWeight.w400,
      fontSize: AppSizes.fontSizeXs,
    ),
    labelLarge: TextStyle(
      fontFamily: 'EncodeSansExpanded',
      fontWeight: FontWeight.w500,
      fontSize:  AppSizes.fontSizeSm,
    ),
  );
}
