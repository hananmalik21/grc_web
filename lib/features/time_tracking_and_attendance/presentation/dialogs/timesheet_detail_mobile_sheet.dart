import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_line.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TimesheetDetailMobileSheet {
  TimesheetDetailMobileSheet._();

  static Future<void> show(BuildContext context, Timesheet timesheet) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Timesheet Details',
      child: _TimesheetDetailSheetBody(timesheet: timesheet),
    );
  }
}

class _TimesheetDetailSheetBody extends StatelessWidget {
  const _TimesheetDetailSheetBody({required this.timesheet});

  final Timesheet timesheet;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8.h, bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReferenceRow(timesheet: timesheet, isDark: isDark),
          Gap(16.h),
          _EmployeeCard(timesheet: timesheet, isDark: isDark),
          Gap(12.h),
          _HoursSummaryCard(timesheet: timesheet, isDark: isDark),
          Gap(12.h),
          _WorkLogSection(timesheet: timesheet, isDark: isDark),
        ],
      ),
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  const _ReferenceRow({required this.timesheet, required this.isDark});

  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TS-${timesheet.id.toString().padLeft(3, '0')}',
          style: context.textTheme.labelMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
        DigifyStatusCapsule(status: timesheet.status.name),
      ],
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({required this.timesheet, required this.isDark});

  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(iconPath: Assets.icons.employeesCyanIcon.path, label: 'EMPLOYEE PROFILE', isDark: isDark),
          Gap(14.h),
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: Text(
                  timesheet.avatarInitials,
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 16.sp, color: AppColors.statIconBlue),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timesheet.employeeName,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 14.sp,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      timesheet.employeeNumber.isEmpty ? 'EMP-${timesheet.employeeId}' : timesheet.employeeNumber,
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: AppColors.tableHeaderText),
                    ),
                    if (timesheet.departmentName.isNotEmpty) ...[
                      Gap(2.h),
                      Text(
                        timesheet.departmentName,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 11.sp,
                          color: AppColors.sidebarChildItemText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (timesheet.companyName?.isNotEmpty == true || timesheet.divisionName?.isNotEmpty == true) ...[
            Gap(12.h),
            Row(
              children: [
                if (timesheet.companyName?.trim().isNotEmpty == true)
                  Expanded(
                    child: _InfoChip(label: 'Company', value: timesheet.companyName!, isDark: isDark),
                  ),
                if (timesheet.companyName?.trim().isNotEmpty == true &&
                    timesheet.divisionName?.trim().isNotEmpty == true)
                  Gap(10.w),
                if (timesheet.divisionName?.trim().isNotEmpty == true)
                  Expanded(
                    child: _InfoChip(label: 'Division', value: timesheet.divisionName!, isDark: isDark),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HoursSummaryCard extends StatelessWidget {
  const _HoursSummaryCard({required this.timesheet, required this.isDark});

  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(iconPath: Assets.icons.attendance.halfDay.path, label: 'PERIOD SUMMARY', isDark: isDark),
          Gap(14.h),
          _SummaryRow(
            label: 'Regular Hours',
            value: '${timesheet.regularHours.toInt()}h',
            valueColor: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
            isDark: isDark,
          ),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 6.h)),
          _SummaryRow(
            label: 'Overtime Hours',
            value: '${timesheet.overtimeHours.toInt()}h',
            valueColor: AppColors.informationIconColor,
            isDark: isDark,
          ),
          Gap(10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GRAND TOTAL',
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 11.sp, color: AppColors.statIconBlue),
                ),
                Text(
                  '${timesheet.totalHours.toInt()}h',
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp, color: AppColors.statIconBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkLogSection extends StatelessWidget {
  const _WorkLogSection({required this.timesheet, required this.isDark});

  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(
              assetPath: Assets.icons.attendance.emptyCalander.path,
              width: 14.w,
              height: 14.h,
              color: AppColors.primary,
            ),
            Gap(7.w),
            Text(
              'WORK ACTIVITY LOG',
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 11.sp,
                letterSpacing: 1.05,
                color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon,
              ),
            ),
          ],
        ),
        Gap(10.h),
        if (timesheet.lines.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text(
                'No activity recorded',
                style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              ),
            ),
          )
        else
          Column(
            spacing: 8.h,
            children: timesheet.lines.map((line) {
              return _WorkLogCard(line: line, isDark: isDark);
            }).toList(),
          ),
      ],
    );
  }
}

class _WorkLogCard extends StatelessWidget {
  const _WorkLogCard({required this.line, required this.isDark});

  final TimesheetLine line;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    DateTime? date;
    try {
      date = DateTime.parse(line.workDate);
    } catch (_) {}

    final dayName = date != null ? DateFormat('EEEE').format(date) : line.workDate;
    final dateStr = date != null ? DateFormat('MMM d, yyyy').format(date).toUpperCase() : '';
    final isWeekend = date?.weekday == DateTime.saturday || date?.weekday == DateTime.sunday;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final bg = isWeekend && !isDark
        ? AppColors.tableHeaderBackground.withValues(alpha: 0.5)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                    ),
                  ),
                  if (dateStr.isNotEmpty)
                    Text(
                      dateStr,
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: AppColors.dialogCloseIcon),
                    ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _HourBadge(
                    label: 'Reg',
                    value: '${line.regularHours.toInt()}h',
                    color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                    isDark: isDark,
                  ),
                  Gap(6.w),
                  _HourBadge(
                    label: 'OT',
                    value: '${line.overtimeHours.toInt()}h',
                    color: line.overtimeHours > 0 ? AppColors.informationIconColor : AppColors.dialogCloseIcon,
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
          if (line.projectName?.isNotEmpty == true || line.taskText.isNotEmpty) ...[
            Gap(8.h),
            const DigifyDivider.thin(),
            Gap(8.h),
            if (line.projectName?.isNotEmpty == true)
              Text(
                line.projectName!,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                ),
              ),
            if (line.taskText.isNotEmpty)
              Text(
                line.taskText,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ],
      ),
    );
  }
}

class _HourBadge extends StatelessWidget {
  const _HourBadge({required this.label, required this.value, required this.color, required this.isDark});

  final String label;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 9.sp, color: AppColors.dialogCloseIcon),
          ),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 11.sp, color: color),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.iconPath, required this.label, required this.isDark});

  final String iconPath;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DigifyAsset(assetPath: iconPath, color: AppColors.primary, width: 13.w, height: 13.h),
        Gap(6.w),
        Text(
          label,
          style: context.textTheme.headlineMedium?.copyWith(
            fontSize: 10.sp,
            letterSpacing: 1.05,
            color: AppColors.dialogCloseIcon,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(color: AppColors.tableHeaderBackground, borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: AppColors.dialogCloseIcon),
          ),
          Gap(3.h),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, required this.valueColor, required this.isDark});

  final String label;
  final String value;
  final Color valueColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textMuted : AppColors.tableHeaderText,
            ),
          ),
          Text(
            value,
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 15.sp, color: valueColor),
          ),
        ],
      ),
    );
  }
}
