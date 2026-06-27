import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class InfoGuidelinesBox extends StatelessWidget {
  final String title;
  final List<String> messages;
  final IconData? icon;
  final String? iconAssetPath;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? messageColor;
  final double? spacing;

  const InfoGuidelinesBox({
    super.key,
    required this.title,
    required this.messages,
    this.icon,
    this.iconAssetPath,
    this.backgroundColor,
    this.borderColor,
    this.iconBackgroundColor,
    this.iconColor,
    this.titleColor,
    this.messageColor,
    this.spacing,
  }) : assert(icon != null || iconAssetPath != null, 'Either icon or iconAssetPath must be provided');

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveBackgroundColor = backgroundColor ?? (isDark ? AppColors.infoBgDark : AppColors.infoBg);
    final effectiveBorderColor = borderColor ?? (isDark ? AppColors.infoBorderDark : AppColors.infoBorder);
    final effectiveIconBackgroundColor = iconBackgroundColor ?? AppColors.jobRoleBg;
    final effectiveIconColor = iconColor ?? AppColors.infoText;
    final effectiveTitleColor = titleColor ?? AppColors.sidebarFooterTitle;
    final effectiveMessageColor = messageColor ?? AppColors.infoTextSecondary;
    final effectiveSpacing = spacing ?? 4.h;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border.all(color: effectiveBorderColor),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: effectiveIconBackgroundColor, borderRadius: BorderRadius.circular(10.r)),
            child: iconAssetPath != null
                ? DigifyAsset(assetPath: iconAssetPath!, width: 20, height: 20, color: effectiveIconColor)
                : Icon(icon, size: 20.sp, color: effectiveIconColor),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: effectiveSpacing,
              children: [
                Text(title, style: context.textTheme.titleSmall?.copyWith(color: effectiveTitleColor)),
                ...messages.map(
                  (message) => Text(
                    message,
                    style: context.textTheme.bodySmall?.copyWith(color: effectiveMessageColor, fontSize: 12.0.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
