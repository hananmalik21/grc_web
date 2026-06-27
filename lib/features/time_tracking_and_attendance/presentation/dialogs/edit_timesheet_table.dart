import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/edit_timesheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EditTimesheetTable extends StatelessWidget {
  const EditTimesheetTable({
    super.key,
    required this.state,
    required this.notifier,
    required this.regularHoursControllers,
    required this.overtimeHoursControllers,
  });

  final EditTimesheetFormState state;
  final EditTimesheetNotifier notifier;
  final List<TextEditingController> regularHoursControllers;
  final List<TextEditingController> overtimeHoursControllers;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Daily Time Entries',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
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
        Gap(6.h),
        if (context.isMobile)
          _MobileLayout(
            state: state,
            notifier: notifier,
            regularHoursControllers: regularHoursControllers,
            overtimeHoursControllers: overtimeHoursControllers,
            isDark: isDark,
          )
        else
          _DesktopLayout(
            state: state,
            notifier: notifier,
            regularHoursControllers: regularHoursControllers,
            overtimeHoursControllers: overtimeHoursControllers,
            isDark: isDark,
          ),
      ],
    );
  }
}

// ── Mobile ──────────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.state,
    required this.notifier,
    required this.regularHoursControllers,
    required this.overtimeHoursControllers,
    required this.isDark,
  });

  final EditTimesheetFormState state;
  final EditTimesheetNotifier notifier;
  final List<TextEditingController> regularHoursControllers;
  final List<TextEditingController> overtimeHoursControllers;
  final bool isDark;

  String _fmt(double v) =>
      v == 0 ? '0h' : (v == v.roundToDouble() ? '${v.toInt()}h' : '${v.toStringAsFixed(2)}h');

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        for (var i = 0; i < state.weekDays.length; i++)
          _MobileDayCard(
            date: state.weekDays[i],
            index: i,
            state: state,
            notifier: notifier,
            regularController: regularHoursControllers[i],
            overtimeController: overtimeHoursControllers[i],
            isDark: isDark,
          ),
        _MobileTotalCard(
          regular: _fmt(state.totalRegularHours),
          overtime: _fmt(state.totalOvertimeHours),
          isDark: isDark,
        ),
      ],
    );
  }
}

class _MobileDayCard extends StatelessWidget {
  const _MobileDayCard({
    required this.date,
    required this.index,
    required this.state,
    required this.notifier,
    required this.regularController,
    required this.overtimeController,
    required this.isDark,
  });

  final DateTime date;
  final int index;
  final EditTimesheetFormState state;
  final EditTimesheetNotifier notifier;
  final TextEditingController regularController;
  final TextEditingController overtimeController;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isRestDay =
        date.weekday == DateTime.friday || date.weekday == DateTime.saturday;
    final borderColor =
        isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final headerBg = isRestDay
        ? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey)
        : (isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            color: headerBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE').format(date),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMM d').format(date),
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 11.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                    if (isRestDay) ...[
                      Gap(6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Rest',
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 9.sp,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10.h,
              children: [
                DigifyTextField(
                  initialValue: index < state.taskTexts.length ? state.taskTexts[index] : null,
                  hintText: 'Task / notes',
                  onChanged: (v) => notifier.setTaskText(index, v),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                ),
                Row(
                  spacing: 10.w,
                  children: [
                    Expanded(
                      child: DigifyTextField(
                        controller: regularController,
                        labelText: 'Regular hrs',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        onChanged: (v) => notifier.setRegularHours(index, v),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      ),
                    ),
                    Expanded(
                      child: DigifyTextField(
                        controller: overtimeController,
                        labelText: 'OT hrs',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        onChanged: (v) => notifier.setOvertimeHours(index, v),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileTotalCard extends StatelessWidget {
  const _MobileTotalCard({
    required this.regular,
    required this.overtime,
    required this.isDark,
  });

  final String regular;
  final String overtime;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.infoText.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Weekly Total',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TotalChip(label: 'Reg', value: regular, isDark: isDark),
              Gap(8.w),
              _TotalChip(label: 'OT', value: overtime, isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 10.sp,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
          ),
        ),
      ],
    );
  }
}

// ── Desktop ──────────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.state,
    required this.notifier,
    required this.regularHoursControllers,
    required this.overtimeHoursControllers,
    required this.isDark,
  });

  final EditTimesheetFormState state;
  final EditTimesheetNotifier notifier;
  final List<TextEditingController> regularHoursControllers;
  final List<TextEditingController> overtimeHoursControllers;
  final bool isDark;

  String _fmt(double v) =>
      v == 0 ? '0h' : (v == v.roundToDouble() ? '${v.toInt()}h' : '${v.toStringAsFixed(2)}h');

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final style = context.textTheme.headlineMedium?.copyWith(
      fontSize: 14.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Day', style: style)),
          Gap(16.w),
          Expanded(flex: 2, child: Text('Date', style: style)),
          Gap(16.w),
          Expanded(flex: 3, child: Text('Project/Task', style: style)),
          Gap(16.w),
          Expanded(flex: 2, child: Text('Regular Hrs', style: style)),
          Gap(16.w),
          Expanded(flex: 2, child: Text('OT Hrs', style: style)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < state.weekDays.length; i++) ...[
          _buildRow(context, i),
          if (i < state.weekDays.length - 1) DigifyDivider.horizontal(),
        ],
        _buildTotalRow(context),
      ],
    );
  }

  Widget _buildRow(BuildContext context, int index) {
    final date = state.weekDays[index];
    final isRestDay =
        date.weekday == DateTime.friday || date.weekday == DateTime.saturday;

    return Container(
      color: isRestDay
          ? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey)
          : AppColors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: DateFormat('EEEE').format(date),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                    ),
                  ),
                  if (isRestDay)
                    TextSpan(
                      text: '  (Rest)',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('MMM d').format(date),
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 3,
            child: DigifyTextField(
              initialValue: index < state.taskTexts.length ? state.taskTexts[index] : null,
              hintText: 'Enter task',
              onChanged: (v) => notifier.setTaskText(index, v),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: DigifyTextField(
              controller: regularHoursControllers[index],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              onChanged: (v) => notifier.setRegularHours(index, v),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: DigifyTextField(
              controller: overtimeHoursControllers[index],
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              onChanged: (v) => notifier.setOvertimeHours(index, v),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.infoBg,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Weekly Total',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
              ),
            ),
          ),
          Gap(16.w),
          const Expanded(flex: 2, child: SizedBox.shrink()),
          Gap(16.w),
          const Expanded(flex: 3, child: SizedBox.shrink()),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              _fmt(state.totalRegularHours),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.inputLabel,
              ),
            ),
          ),
          Gap(16.w),
          Expanded(
            flex: 2,
            child: Text(
              _fmt(state.totalOvertimeHours),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.inputLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
