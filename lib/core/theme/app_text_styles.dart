import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/theme/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextTheme textTheme(TextTheme base) {
    TextStyle t({
      required double size,
      FontWeight weight = FontWeight.w400,
      double? height,
      double? letterSpacing,
      Color? color,
    }) {
      return TextStyle(
        fontSize: size.sp,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );
    }

    return base.copyWith(
      // Header title: 20 / 28, tracking -0.46
      titleLarge: t(
        size: 20,
        // Figma: SF Pro Semibold (590) → closest Flutter: w600
        weight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: -0.46,
        color: AppColors.textPrimary,
      ),
      // Section titles: 18 / 28, tracking -0.45
      titleMedium: t(
        size: 18,
        weight: FontWeight.w600,
        height: 28 / 18,
        letterSpacing: -0.45,
        color: AppColors.textPrimary,
      ),
      // Card big value: 24 / 32, tracking 0.072
      headlineSmall: t(
        size: 24,
        weight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: 0.072,
        color: AppColors.textPrimary,
      ),
      // Body: 14 / 20, tracking -0.154
      bodyMedium: t(
        size: 14,
        weight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: -0.154,
        color: AppColors.textBody,
      ),
      // Body emphasis: 14 / 20
      bodyLarge: t(
        size: 14,
        // Figma: SF Pro Medium (510) → closest Flutter: w500
        weight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: -0.154,
        color: AppColors.textPrimary,
      ),
      // Small: 12 / 16
      bodySmall: t(
        size: 12,
        weight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.textSecondary,
      ),
      labelSmall: t(
        size: 12,
        weight: FontWeight.w500,
        height: 16 / 12,
      ),
      // Library page title: 24 / 32
      displaySmall: t(
        size: 24,
        weight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: 0.072,
        color: AppColors.textPrimary,
      ),
      // 16px medium for question titles and action buttons
      titleSmall: t(
        size: 16,
        weight: FontWeight.w500,
        height: 24 / 16,
        letterSpacing: -0.32,
        color: AppColors.textPrimary,
      ),
    );
  }
}

