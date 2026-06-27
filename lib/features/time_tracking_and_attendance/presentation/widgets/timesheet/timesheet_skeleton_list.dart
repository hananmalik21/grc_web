import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimesheetSkeletonList extends StatelessWidget {
  const TimesheetSkeletonList({
    required this.records,
    required this.isLoading,
    required this.approvingGuid,
    required this.rejectingGuid,
    required this.isDark,
    this.onEdit,
    this.onView,
    this.onApprove,
    this.onReject,
    super.key,
  });

  static final Timesheet skeleton = Timesheet(
    id: 0,
    guid: '',
    employeeId: 0,
    employeeName: 'Employee Name',
    employeeNumber: 'EMP-0000',
    departmentName: 'Department',
    weekStartDate: DateTime(2000, 1, 1),
    weekEndDate: DateTime(2000, 1, 7),
    regularHours: 0,
    overtimeHours: 0,
    totalHours: 0,
    status: TimesheetStatus.submitted,
  );

  final List<Timesheet> records;
  final bool isLoading;
  final String? approvingGuid;
  final String? rejectingGuid;
  final bool isDark;
  final void Function(Timesheet)? onEdit;
  final void Function(Timesheet)? onView;
  final void Function(Timesheet)? onApprove;
  final void Function(Timesheet)? onReject;

  @override
  Widget build(BuildContext context) {
    final displayRecords = isLoading && records.isEmpty ? List.filled(5, skeleton) : records;

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: displayRecords.length,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, i) {
          final t = displayRecords[i];
          return _TimesheetCard(
            timesheet: t,
            isDark: isDark,
            status: t.status.name,
            isApproving: approvingGuid == t.guid,
            isRejecting: rejectingGuid == t.guid,
            onEdit: onEdit != null && t.status == TimesheetStatus.draft ? () => onEdit!(t) : null,
            onView: onView != null && t.status != TimesheetStatus.draft ? () => onView!(t) : null,
            onApprove: onApprove != null && t.status == TimesheetStatus.submitted ? () => onApprove!(t) : null,
            onReject: onReject != null && t.status == TimesheetStatus.submitted ? () => onReject!(t) : null,
          );
        },
      ),
    );
  }
}

class _TimesheetCard extends StatelessWidget {
  const _TimesheetCard({
    required this.timesheet,
    required this.isDark,
    required this.status,
    required this.isApproving,
    required this.isRejecting,
    this.onEdit,
    this.onView,
    this.onApprove,
    this.onReject,
  });

  final Timesheet timesheet;
  final bool isDark;
  final String status;
  final bool isApproving;
  final bool isRejecting;
  final VoidCallback? onEdit;
  final VoidCallback? onView;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final bg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(image: null, fallbackInitial: timesheet.employeeName, size: 36.w),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timesheet.employeeName.toUpperCase(),
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(2.h),
                    Text(
                      timesheet.employeeNumber,
                      style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: status),
            ],
          ),
          Gap(10.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _MetaItem(label: 'Week Period', value: timesheet.formattedWeekPeriod, isDark: isDark),
              ),
              Gap(12.w),
              _MetaItem(
                label: 'Total Hours',
                value: '${timesheet.totalHours.toInt()}h',
                isDark: isDark,
                alignEnd: true,
              ),
            ],
          ),
          Gap(10.h),
          const DigifyDivider.thin(),
          Gap(8.h),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: _buildActions()),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    final actions = <Widget>[];

    if (onEdit != null) {
      actions.add(AppMobileButton.primary(svgPath: Assets.icons.editIconGreen.path, onPressed: onEdit));
    }

    if (onView != null) {
      if (actions.isNotEmpty) actions.add(Gap(8.w));
      actions.add(AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: onView));
    }

    if (onApprove != null) {
      if (actions.isNotEmpty) actions.add(Gap(8.w));
      actions.add(
        AppMobileButton(
          svgPath: Assets.icons.checkIconGreen.path,
          backgroundColor: AppColors.success,
          onPressed: isApproving || isRejecting ? null : onApprove,
          isLoading: isApproving,
        ),
      );
    }

    if (onReject != null) {
      if (actions.isNotEmpty) actions.add(Gap(8.w));
      actions.add(
        AppMobileButton.danger(
          svgPath: Assets.icons.closeIcon.path,
          onPressed: isApproving || isRejecting ? null : onReject,
          isLoading: isRejecting,
        ),
      );
    }

    if (actions.isEmpty) return [const SizedBox.shrink()];
    return actions;
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.label, required this.value, required this.isDark, this.alignEnd = false});

  final String label;
  final String value;
  final bool isDark;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: labelColor),
        ),
        Gap(2.h),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500, color: valueColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
