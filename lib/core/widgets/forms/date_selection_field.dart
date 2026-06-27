import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:grc/core/widgets/forms/digify_date_picker_dialog.dart';

class DateSelectionField extends StatelessWidget {
  final String? label;
  final bool isRequired;
  final DateTime? date;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;
  final String? labelIconPath;
  final bool enabled;

  const DateSelectionField({
    super.key,
    this.label,
    required this.date,
    required this.onDateSelected,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.labelIconPath,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (labelIconPath != null) ...[
                DigifyAsset(
                  assetPath: labelIconPath!,
                  width: 16.w,
                  height: 16.h,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                ),
                Gap(8.w),
              ],
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
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                          fontFamily: 'Inter',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Gap(8.h),
        ],
        InkWell(
          onTap: enabled ? () => _selectDate(context) : null,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: enabled ? AppColors.cardBackground : AppColors.cardBackground.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? DateFormat('dd/MM/yyyy').format(date!) : (hintText ?? 'Select Date'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: date != null
                          ? (enabled ? AppColors.textPrimary : AppColors.textSecondary)
                          : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DigifyAsset(
                  assetPath: Assets.icons.leaveManagement.emptyLeave.path,
                  color: AppColors.textSecondary,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final effectiveFirst = firstDate ?? now;
    final effectiveLast = lastDate ?? now.add(const Duration(days: 365));
    var initial = date ?? now;
    if (initial.isBefore(effectiveFirst)) initial = effectiveFirst;
    if (initial.isAfter(effectiveLast)) initial = effectiveLast;
    final picked = await DigifyDatePickerDialog.show(
      context,
      initialDate: initial,
      firstDate: effectiveFirst,
      lastDate: effectiveLast,
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }
}

class DateSelectionFieldHorizontal extends StatelessWidget {
  final String label;
  final bool isRequired;
  final DateTime? date;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;
  final String? labelIconPath;
  final bool enabled;
  final bool colorApplied;

  const DateSelectionFieldHorizontal({
    super.key,
    required this.label,
    required this.date,
    required this.onDateSelected,
    this.isRequired = false,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.labelIconPath,
    this.enabled = true,
    this.colorApplied = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelIconPath != null) ...[
          DigifyAsset(
            assetPath: labelIconPath!,
            width: 16.w,
            height: 16.h,
            color: colorApplied
                ? isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.primary
                : null,
          ),
        ],
        Gap(4.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextSecondary : AppColors.inputLabel,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (isRequired)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.error,
                          fontFamily: 'Inter',
                        ),
                      ),
                  ],
                ),
              ),
              Gap(4.h),
              InkWell(
                onTap: enabled ? () => _selectDate(context) : null,
                child: Container(
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: enabled ? AppColors.cardBackground : AppColors.cardBackground.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          date != null ? DateFormat('dd/MM/yyyy').format(date!) : (hintText ?? 'Select Date'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: date != null
                                ? (enabled ? AppColors.textPrimary : AppColors.textSecondary)
                                : AppColors.textSecondary.withValues(alpha: 0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DigifyAsset(
                        assetPath: Assets.icons.leaveManagement.emptyLeave.path,
                        color: AppColors.textSecondary,
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final effectiveFirst = firstDate ?? now;
    final effectiveLast = lastDate ?? now.add(const Duration(days: 365));
    var initial = date ?? now;
    if (initial.isBefore(effectiveFirst)) initial = effectiveFirst;
    if (initial.isAfter(effectiveLast)) initial = effectiveLast;
    final picked = await DigifyDatePickerDialog.show(
      context,
      initialDate: initial,
      firstDate: effectiveFirst,
      lastDate: effectiveLast,
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
