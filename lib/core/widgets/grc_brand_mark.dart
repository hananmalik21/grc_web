import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_text_theme.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class GrcBrandMark extends StatelessWidget {
  const GrcBrandMark({super.key, this.fontSize, this.color});

  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final size = fontSize ?? 16;
    final textColor =
        color ?? (isDark ? AppColors.primaryLight : AppColors.primary);
    final radius = size * 0.42;
    final horizontalPadding = size * 0.62;
    final verticalPadding = size * 0.28;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primary.withValues(alpha: 0.28),
                  AppColors.primary.withValues(alpha: 0.12),
                ]
              : [AppColors.primaryTint, Colors.white],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.primaryLight.withValues(alpha: 0.22)
              : AppColors.primary.withValues(alpha: 0.14),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Text(
          'GRC',
          style: TextStyle(
            fontFamily: AppTextTheme.fontFamily,
            fontSize: size,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: size * 0.14,
            height: 1,
          ),
        ),
      ),
    );
  }
}
