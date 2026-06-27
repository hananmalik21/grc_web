import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable empty state with icon, title, message, and optional action button
class EmptyStateWidget extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    this.iconPath,
    this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  }) : assert(iconPath != null || icon != null, 'Either iconPath or icon must be provided');

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              DigifyAsset(
                assetPath: iconPath!,
                width: 64,
                height: 64,
                color: iconColor ?? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
              )
            else if (icon != null)
              Icon(
                icon,
                size: 64.sp,
                color: iconColor ?? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
              ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                height: 24 / 18,
                letterSpacing: 0,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null && message!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  height: 20 / 14,
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
