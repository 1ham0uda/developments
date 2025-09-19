import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static TextStyle get bodyMedium => TextStyle(
   fontSize: 16,
   color: AppColors.primary, // أو أي لون تحبه
   fontWeight: FontWeight.normal,
  );
  static TextStyle get bodySmall => TextStyle(
   fontSize: 14,
   color: AppColors.greyDark, // أو أي لون تحبه
   fontWeight: FontWeight.normal,
  );
  static TextStyle get headingLarge => TextStyle(
   fontSize: 24,
   fontWeight: FontWeight.bold,
   color: AppColors.grey,
  );
  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black, // ممكن تغيّر اللون حسب التصميم بتاعك
  );


  

}
