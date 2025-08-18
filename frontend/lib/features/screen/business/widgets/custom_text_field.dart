import 'package:flutter/material.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/size.dart';

/// A reusable custom text field widget for business screens
/// This widget provides consistent styling and behavior across all business forms
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final int maxLines;
  final bool obscureText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsets? contentPadding;
  final TextStyle? labelStyle;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.obscureText = false,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.contentPadding,
    this.labelStyle,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          onFieldSubmitted:
              onFieldSubmitted != null ? (_) => onFieldSubmitted!() : null,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: AppColors.textPrimaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: AppColors.grey,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A helper function to create a CustomTextField with common business form styling
Widget buildTextField(
  String label,
  TextEditingController controller, {
  FocusNode? focusNode,
  int maxLines = 1,
  bool obscureText = false,
  String? hintText,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  VoidCallback? onFieldSubmitted,
  String? Function(String?)? validator,
  bool enabled = true,
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return CustomTextField(
    label: label,
    controller: controller,
    focusNode: focusNode,
    maxLines: maxLines,
    obscureText: obscureText,
    hintText: hintText,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    onFieldSubmitted: onFieldSubmitted,
    validator: validator,
    enabled: enabled,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
  );
}
