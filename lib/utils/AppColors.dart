import 'package:flutter/material.dart';

// Colors
class AppColors {
  static const Color primaryColor = Color(0xFF005A8B);
  static const Color backgroundColor = Colors.grey;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color selectedBorderColor = Colors.blue;
  static const Color unselectedItemColor = Colors.grey;
}

// Text Styles
class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: AppColors.white,
  );

  static const TextStyle bodyTextLarge = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    color: Colors.black,
  );

  static const TextStyle bodyTextSmall = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black,
  );

  static const TextStyle productTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 13,
    color: Colors.black,
  );

  static const TextStyle productPrice = TextStyle(
    color: AppColors.grey,
    fontSize: 10,
  );
}
