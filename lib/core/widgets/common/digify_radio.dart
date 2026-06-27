import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A reusable radio button widget that follows the app's design system
/// Supports light/dark themes and can be used with or without a label
class DigifyRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final Widget? labelWidget;
  final Color? activeColor;
  final Color? fillColor;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;

  const DigifyRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.labelWidget,
    this.activeColor,
    this.fillColor,
    this.enabled = true,
    this.padding,
    this.alignment = MainAxisAlignment.start,
  }) : assert(label == null || labelWidget == null, 'Cannot provide both label and labelWidget');

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveActiveColor = activeColor ?? AppColors.primary;

    final borderColor = enabled
        ? (_isSelected ? effectiveActiveColor : (isDark ? AppColors.borderGreyDark : AppColors.borderGrey))
        : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);

    final radio = GestureDetector(
      onTap: enabled && onChanged != null ? () => onChanged!(value) : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: _isSelected
            ? Center(
                child: Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(color: effectiveActiveColor, shape: BoxShape.circle),
                ),
              )
            : null,
      ),
    );

    if (label == null && labelWidget == null) {
      return radio;
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          radio,
          if (label != null || labelWidget != null) ...[
            Gap(8.w),
            labelWidget ??
                Text(
                  label!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: enabled
                        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                        : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
