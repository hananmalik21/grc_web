import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable square-shaped capsule/badge widget with specific styling
class DigifySquareCapsule extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const DigifySquareCapsule({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.width,
    this.height,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveBackgroundColor = backgroundColor ?? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg);
    final effectiveTextColor = textColor ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary);
    final effectiveBorderColor = borderColor ?? (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    Widget container = Container(
      height: height,
      constraints: height == null ? BoxConstraints(minHeight: 24.h) : null,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.5.h),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: borderColor != null ? Border.all(color: effectiveBorderColor, width: 1) : null,
        borderRadius: borderRadius ?? BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(color: effectiveTextColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );

    if (width != null) {
      container = SizedBox(width: width, child: container);
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}
