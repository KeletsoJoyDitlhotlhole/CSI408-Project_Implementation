import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Color(0xFFC3DFE0);
  static const Color statusBarBackground = Colors.black;
  static const Color textColor = Color(0xFF333333);
}

class AppStyles {
  static const TextStyle logoStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle appNameStyle = TextStyle(
    fontFamily: 'Arial',
    fontSize: 16,
    color: AppColors.textColor,
    letterSpacing: 1,
  );
}
