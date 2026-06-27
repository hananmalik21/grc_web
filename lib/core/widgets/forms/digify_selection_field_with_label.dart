import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifySelectionFieldWithLabel extends StatelessWidget {
  final String label;
  final String hint;
  final int? selectedCount;
  final String? value;
  final VoidCallback? onTap;
  final bool isRequired;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? valueColor;
  final Color? hintColor;
  final String Function(int count)? valueTextBuilder;

  const DigifySelectionFieldWithLabel({
    super.key,
    required this.label,
    required this.hint,
    this.selectedCount,
    this.value,
    required this.onTap,
    this.isRequired = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.borderColor,
    this.valueColor,
    this.hintColor,
    this.valueTextBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final normalizedValue = value?.trim();
    final hasValue = normalizedValue != null && normalizedValue.isNotEmpty;
    final count = selectedCount ?? 0;
    final hasSelection = hasValue || count > 0;
    final effectiveBackgroundColor = backgroundColor ?? Colors.white;
    final effectiveBorderColor = borderColor ?? AppColors.borderGrey;
    final effectiveValueColor = valueColor ?? AppColors.textPrimary;
    final effectiveHintColor = hintColor ?? AppColors.textSecondary.withValues(alpha: 0.8);
    final valueText = hasValue
        ? normalizedValue
        : count > 0
        ? (valueTextBuilder?.call(count) ?? '$count selected')
        : hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(8.h),
        InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            height: 40.w,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: isEnabled ? effectiveBackgroundColor : AppColors.inputBg.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: effectiveBorderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    valueText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: hasSelection ? effectiveValueColor : effectiveHintColor,
                      fontWeight: hasSelection ? FontWeight.w500 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DigifyAsset(
                  assetPath: Assets.icons.workforce.chevronRight.path,
                  color: isEnabled ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.3),
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DigifyMultiSelectFieldWithLabel extends StatelessWidget {
  final String label;
  final String hint;
  final int selectedCount;
  final VoidCallback? onTap;
  final bool isRequired;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? valueColor;
  final Color? hintColor;
  final String Function(int count)? valueTextBuilder;

  const DigifyMultiSelectFieldWithLabel({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedCount,
    required this.onTap,
    this.isRequired = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.borderColor,
    this.valueColor,
    this.hintColor,
    this.valueTextBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DigifySelectionFieldWithLabel(
      label: label,
      hint: hint,
      selectedCount: selectedCount,
      onTap: onTap,
      isRequired: isRequired,
      isEnabled: isEnabled,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      valueColor: valueColor,
      hintColor: hintColor,
      valueTextBuilder: valueTextBuilder,
    );
  }
}
