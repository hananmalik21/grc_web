import 'dart:math';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class TimesheetDetailScreen extends ConsumerWidget {
  const TimesheetDetailScreen({super.key, required this.timesheet});

  final Timesheet timesheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 21.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(timesheet: timesheet, isDark: isDark),
              Gap(24.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 340.w,
                          child: Column(
                            children: [
                              _EmployeeProfile(timesheet: timesheet, isDark: isDark),
                              Gap(21.h),
                              _PeriodSummary(timesheet: timesheet, isDark: isDark),
                            ],
                          ),
                        ),
                        Gap(28.w),
                        Expanded(
                          child: _WorkActivityLog(timesheet: timesheet, isDark: isDark, localizations: localizations),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _EmployeeProfile(timesheet: timesheet, isDark: isDark),
                        Gap(21.h),
                        _PeriodSummary(timesheet: timesheet, isDark: isDark),
                        Gap(24.h),
                        _WorkActivityLog(timesheet: timesheet, isDark: isDark, localizations: localizations),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.timesheet, required this.isDark});
  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.categoryBadgeBorder),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.chevron_left,
              size: 18.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
            ),
          ),
        ),
        Gap(14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Timesheet Details',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 21.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
              Text(
                'Reference: TS-${timesheet.id.toString().padLeft(3, '0')}',
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 12.sp,
                  color: isDark ? AppColors.textMuted : AppColors.tableHeaderText,
                ),
              ),
            ],
          ),
        ),
        DigifyStatusCapsule(status: timesheet.status.name),
      ],
    );
  }
}

class _EmployeeProfile extends StatelessWidget {
  const _EmployeeProfile({required this.timesheet, required this.isDark});
  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.inputBg),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.employeesCyanIcon.path,
                color: AppColors.primary,
                width: 14.w,
                height: 14.h,
              ),
              Gap(7.w),
              Text(
                'EMPLOYEE PROFILE',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 11.sp,
                  letterSpacing: 1.05,
                  color: AppColors.dialogCloseIcon,
                ),
              ),
            ],
          ),
          Gap(26.h),
          Row(
            children: [
              Container(
                width: 49.w,
                height: 49.w,
                decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: Text(
                  timesheet.avatarInitials,
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp, color: AppColors.statIconBlue),
                ),
              ),
              Gap(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timesheet.employeeName,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 16.sp,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      ),
                    ),
                    Text(
                      timesheet.employeeNumber.isEmpty ? 'EMP-${timesheet.employeeId}' : timesheet.employeeNumber,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 11.sp,
                        letterSpacing: 0.525,
                        color: AppColors.tableHeaderText,
                      ),
                    ),
                    Gap(3.h),
                    Row(
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.divisionTreeIcon.path,
                          color: AppColors.sidebarChildItemText,
                          width: 12.w,
                          height: 12.h,
                        ),
                        Gap(5.w),
                        Text(
                          timesheet.departmentName.isEmpty ? 'General' : timesheet.departmentName,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.sidebarChildItemText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(21.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.tableHeaderBackground : AppColors.tableHeaderBackground,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontSize: 10.sp,
                          color: AppColors.dialogCloseIcon,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        timesheet.companyName?.trim().isNotEmpty == true ? timesheet.companyName! : '—',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontSize: 11.sp,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(14.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.tableHeaderBackground : AppColors.tableHeaderBackground,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Division',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                          color: AppColors.dialogCloseIcon,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        timesheet.divisionName?.trim().isNotEmpty == true
                            ? timesheet.divisionName!
                            : (timesheet.departmentName.trim().isNotEmpty ? timesheet.departmentName : '—'),
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontSize: 11.sp,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodSummary extends StatelessWidget {
  const _PeriodSummary({required this.timesheet, required this.isDark});
  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.inputBg),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.attendance.halfDay.path,
                color: AppColors.primary,
                width: 14.w,
                height: 14.h,
              ),
              Gap(7.w),
              Text(
                'PERIOD SUMMARY',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 11.sp,
                  letterSpacing: 1.05,
                  color: AppColors.dialogCloseIcon,
                ),
              ),
            ],
          ),
          Gap(21.h),
          _SummaryRow(
            label: 'Total Regular',
            value: '${timesheet.regularHours.toInt()}h',
            valueColor: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
            isDark: isDark,
          ),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 7.h)),
          _SummaryRow(
            label: 'Total Overtime',
            value: '${timesheet.overtimeHours.toInt()}h',
            valueColor: AppColors.informationIconColor,
            isDark: isDark,
          ),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 7.h)),
          Gap(7.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'GRAND TOTAL',
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 12.sp, color: AppColors.statIconBlue),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, required this.valueColor, required this.isDark});

  final String label;
  final String value;
  final Color valueColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textMuted : AppColors.tableHeaderText,
            ),
          ),
          Text(
            value,
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 16.sp, color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _WorkActivityLog extends StatelessWidget {
  const _WorkActivityLog({required this.timesheet, required this.isDark, required this.localizations});

  final Timesheet timesheet;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.inputBg),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground.withValues(alpha: 0.3),
              border: Border(
                bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.tableHeaderBackground),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Work Activity Log',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 14.sp,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      'Breakdown of hours recorded per day',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.textMuted : AppColors.tableHeaderText,
                      ),
                    ),
                  ],
                ),
                DigifyAsset(
                  assetPath: Assets.icons.attendance.emptyCalander.path,
                  width: 17.w,
                  height: 17.h,
                  color: AppColors.dialogCloseIcon,
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: max(constraints.maxWidth, 700.w),
                  child: Column(
                    children: [
                      _TableHeader(isDark: isDark),
                      if (timesheet.lines.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Text(
                            localizations.noResultsFound,
                            style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                          ),
                        )
                      else
                        ...timesheet.lines.map((line) {
                          DateTime? parsedDate;
                          try {
                            parsedDate = DateTime.parse(line.workDate);
                          } catch (_) {}

                          String dayName = line.workDate;
                          String dateString = '';
                          if (parsedDate != null) {
                            dayName = DateFormat('EEEE').format(parsedDate);
                            dateString = DateFormat('MMM d').format(parsedDate).toUpperCase();
                          }

                          return _TableRow(
                            day: dayName,
                            date: dateString,
                            project: line.projectName ?? '-',
                            regular: line.regularHours,
                            overtime: line.overtimeHours,
                            activity: line.taskText,
                            isDark: isDark,
                            isWeekend:
                                parsedDate?.weekday == DateTime.saturday || parsedDate?.weekday == DateTime.sunday,
                          );
                        }),
                      _TableFooter(timesheet: timesheet, isDark: isDark),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 10.sp,
      letterSpacing: 1.0,
      color: AppColors.dialogCloseIcon,
    );

    return Container(
      color: isDark
          ? AppColors.backgroundDark.withValues(alpha: 0.5)
          : AppColors.tableHeaderBackground.withValues(alpha: 0.5),
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 10.5.h),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Day / Date', style: style)),
          Expanded(flex: 4, child: Text('Project/Task', style: style)),
          Expanded(
            flex: 2,
            child: Text('Regular', style: style, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Text('OT', style: style, textAlign: TextAlign.center),
          ),
          Expanded(flex: 4, child: Text('Activity', style: style)),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.day,
    required this.date,
    required this.project,
    required this.regular,
    required this.overtime,
    required this.activity,
    required this.isDark,
    required this.isWeekend,
  });

  final String day;
  final String date;
  final String project;
  final double regular;
  final double overtime;
  final String activity;
  final bool isDark;
  final bool isWeekend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isWeekend && !isDark ? AppColors.tableHeaderBackground.withValues(alpha: 0.3) : null,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.tableHeaderBackground)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  ),
                ),
                if (date.isNotEmpty)
                  Text(
                    date,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                      color: AppColors.dialogCloseIcon,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              project.isEmpty ? '-' : project,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.3.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${regular.toInt()}h',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${overtime.toInt()}h',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 12.3.sp,
                color: overtime > 0 ? AppColors.informationIconColor : AppColors.dialogCloseIcon,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              activity.isEmpty ? 'No notes' : activity,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10.5.sp,
                color: AppColors.tableHeaderText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableFooter extends StatelessWidget {
  const _TableFooter({required this.timesheet, required this.isDark});

  final Timesheet timesheet;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground.withValues(alpha: 0.8),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 17.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              'Weekly Totals',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${timesheet.regularHours.toInt()}h',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${timesheet.overtimeHours.toInt()}h',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 12.3.sp,
                color: timesheet.overtimeHours > 0 ? AppColors.informationIconColor : AppColors.dialogCloseIcon,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              '${timesheet.totalHours.toInt()}h Total',
              textAlign: TextAlign.right,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
