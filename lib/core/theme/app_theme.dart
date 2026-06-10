import 'package:flutter/material.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/theme/app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // If SF Pro isn't bundled, Flutter falls back to the next available font.
      fontFamily: 'SF Pro',
      fontFamilyFallback: const ['SF Pro Display', 'SF Pro Text', 'Inter', 'Roboto'],
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed, brightness: Brightness.light).copyWith(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
    );

    return base.copyWith(
      textTheme: AppTextStyles.textTheme(base.textTheme),
      scaffoldBackgroundColor: AppColors.bg,
      dividerColor: AppColors.border,
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'SF Pro',
      fontFamilyFallback: const ['SF Pro Display', 'SF Pro Text', 'Inter', 'Roboto'],
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed, brightness: Brightness.dark),
    );

    return base.copyWith(
      textTheme: AppTextStyles.textTheme(base.textTheme),
    );
  }
}

