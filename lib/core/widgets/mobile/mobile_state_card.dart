import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A card used to display empty, error, or informational states in mobile
/// list views. Shows a circular icon area, title, subtitle, and optional
/// action widget.
class MobileStateCard extends StatelessWidget {
  const MobileStateCard({
    super.key,
    required this.isDark,
    required this.borderColor,
    required this.iconBackground,
    this.icon,
    this.iconPath,
    this.iconColor,
    required this.title,
    required this.subtitle,
    this.action,
  }) : assert(icon != null || iconPath != null, 'Either icon or iconPath must be provided');

  final bool isDark;
  final Color borderColor;
  final Color iconBackground;
  final Widget? icon;
  final String? iconPath;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = iconPath != null
        ? DigifyAsset.square(
            assetPath: iconPath!,
            size: 32,
            color: iconColor ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          )
        : icon!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(color: iconBackground, shape: BoxShape.circle),
            child: Center(child: resolvedIcon),
          ),
          Gap(16.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(6.w),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[Gap(20.w), action!],
        ],
      ),
    );
  }
}
