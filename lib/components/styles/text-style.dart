import 'package:flutter/material.dart';
import 'color.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
    letterSpacing: -0.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}
