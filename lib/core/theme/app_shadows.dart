import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get primaryShadow => [
    BoxShadow(color: AppColors.shadowColor, offset: const Offset(0, 1), blurRadius: 3),
  ];

  static List<BoxShadow> get elevatedCardShadow => const [
    BoxShadow(color: AppColors.shadowColor, blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: AppColors.shadowColorLight, blurRadius: 2, offset: Offset(0, 1)),
  ];

  static List<BoxShadow> get dialogShadow => const [
    BoxShadow(color: AppColors.shadowColor, blurRadius: 25, offset: Offset(0, 20)),
    BoxShadow(color: AppColors.shadowColor, blurRadius: 10, offset: Offset(0, 8)),
  ];

  static List<BoxShadow> headerShadow(bool isDark) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
      offset: const Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 4),
  ];

  static List<BoxShadow> get loginCardShadow => [
    // Main soft shadow
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.12),
      blurRadius: 100,
      offset: const Offset(0, 32),
      spreadRadius: -20,
    ),
    // Subtle ambient layer
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: -5,
    ),
  ];
}
