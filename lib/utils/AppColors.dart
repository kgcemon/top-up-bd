import 'package:flutter/material.dart';

// Colors
class AppColors {
  static const Color primaryColor = Color(0xFF005A8B);
  static const Color backgroundColor = Color(0xFFF5F5F5); // Lighter grey for background
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xFFEEEEEE); // Lighter grey for contrast
  static const Color selectedBorderColor = Colors.blue;
  static const Color unselectedItemColor = Colors.grey;
  static const Color accentColor = Color(0xFF3A8FBD); // Accent color for highlights
  static const Color textColor = Colors.black; // Slightly softer black for text
  static const Color errorColor = Colors.redAccent; // Error color for validation
}

// Text Styles
class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.white,
  );

  static const TextStyle bodyTextLarge = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    color: AppColors.textColor,
  );

  static const TextStyle bodyTextMedium = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.textColor,
  );

  static const TextStyle bodyTextSmall = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: AppColors.textColor,
  );

  static const TextStyle productTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.black,
  );

  static const TextStyle productPrice = TextStyle(
    color: AppColors.grey,
    fontSize: 14,
  );

  static const TextStyle buttonText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.white,
  );

  static const TextStyle linkText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.accentColor,
    decoration: TextDecoration.underline,
  );

  static const TextStyle errorText = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.errorColor,
  );
}
