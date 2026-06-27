import 'dart:ui';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart' show AppButton, AppButtonType;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class DigifyDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool isDark;

  const DigifyDatePickerDialog({super.key, this.initialDate, this.firstDate, this.lastDate, required this.isDark});

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          DigifyDatePickerDialog(initialDate: initialDate, firstDate: firstDate, lastDate: lastDate, isDark: isDark),
    );
  }

  @override
  State<DigifyDatePickerDialog> createState() => _DigifyDatePickerDialogState();
}

class _DigifyDatePickerDialogState extends State<DigifyDatePickerDialog> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final textColor = widget.isDark ? context.themeTextPrimary : AppColors.textPrimary;
    final mutedTextColor = widget.isDark ? context.themeTextMuted : AppColors.textSecondary;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Container(
          width: 380.w,
          constraints: BoxConstraints(maxWidth: 400.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: widget.isDark ? AppColors.inputBorderDark : AppColors.borderGrey),
            boxShadow: AppShadows.headerShadow(widget.isDark),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selected Date Showcase Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                decoration: BoxDecoration(
                  color: widget.isDark ? AppColors.inputBgDark : AppColors.primary.withValues(alpha: 0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: widget.isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedDate != null ? DateFormat('yyyy').format(_selectedDate!) : 'Select Year',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: mutedTextColor,
                      ),
                    ),
                    Gap(6.h),
                    Text(
                      _selectedDate != null ? DateFormat('EEE, MMM d').format(_selectedDate!) : 'Select Date',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        color: widget.isDark ? AppColors.textPrimaryDark : AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Body - Syncfusion Calendar
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
                child: SizedBox(
                  height: 310.h,
                  child: SfDateRangePicker(
                    initialSelectedDate: widget.initialDate,
                    minDate: widget.firstDate,
                    maxDate: widget.lastDate,
                    selectionMode: DateRangePickerSelectionMode.single,
                    showNavigationArrow: true,
                    selectionShape: DateRangePickerSelectionShape.circle,
                    headerHeight: 50.h,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      setState(() {
                        _selectedDate = args.value as DateTime?;
                      });
                    },
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: context.textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat: 'EEE',
                      viewHeaderHeight: 40.h,
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: context.textTheme.labelMedium?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: mutedTextColor,
                        ),
                      ),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                      disabledDatesTextStyle: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: mutedTextColor.withValues(alpha: 0.4),
                      ),
                      todayTextStyle: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      todayCellDecoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectionColor: AppColors.primary,
                    todayHighlightColor: AppColors.primary,
                    selectionTextStyle: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cardBackground,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Cancel',
                        type: AppButtonType.outline,
                        onPressed: () => Navigator.pop(context),
                        height: 48.h,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: AppButton(
                        label: 'Confirm',
                        onPressed: () {
                          Navigator.pop(context, _selectedDate ?? widget.initialDate ?? DateTime.now());
                        },
                        backgroundColor: AppColors.primary,
                        height: 48.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
