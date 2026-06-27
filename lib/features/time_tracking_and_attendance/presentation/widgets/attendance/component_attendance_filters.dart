import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/date_selection_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceFilters extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final TextEditingController employeeNumberController;
  final ValueChanged<DateTime> onFromDateSelected;
  final ValueChanged<DateTime> onToDateSelected;
  final ValueChanged<String> onEmployeeNumberChanged;
  final bool isDark;

  const AttendanceFilters({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.employeeNumberController,
    required this.onFromDateSelected,
    required this.onToDateSelected,
    required this.onEmployeeNumberChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: context.isMobile ? _buildMobile(context) : _buildDesktop(context),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        DateSelectionFieldHorizontal(
          label: 'From Date',
          labelIconPath: Assets.icons.attendance.emptyCalander.path,
          date: fromDate,
          onDateSelected: onFromDateSelected,
        ),
        Gap(16.h),
        DateSelectionFieldHorizontal(
          label: 'To Date',
          date: toDate,
          onDateSelected: onToDateSelected,
          labelIconPath: Assets.icons.attendance.emptyCalander.path,
        ),
        Gap(16.h),
        _buildEmployeeNumberField(context),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DateSelectionFieldHorizontal(
            label: 'From Date',
            date: fromDate,
            onDateSelected: onFromDateSelected,
            labelIconPath: Assets.icons.attendance.emptyCalander.path,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: DateSelectionFieldHorizontal(
            label: 'To Date',
            date: toDate,
            onDateSelected: onToDateSelected,
            labelIconPath: Assets.icons.attendance.emptyCalander.path,
          ),
        ),
        Gap(14.w),
        Expanded(child: _buildEmployeeNumberField(context)),
      ],
    );
  }

  Widget _buildEmployeeNumberField(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyAsset(
          assetPath: Assets.icons.sidebar.scheduleAssignments.path,
          width: 16.w,
          height: 16.h,
          color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon,
        ),
        Gap(4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Employee Number',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? context.themeTextSecondary : AppColors.inputLabel,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Gap(4.h),
              DigifyTextField(
                hintText: 'Enter employee number...',
                controller: employeeNumberController,
                fillColor: AppColors.cardBackground,
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                onChanged: onEmployeeNumberChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
