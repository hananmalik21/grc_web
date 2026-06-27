import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_tracking_and_attendance/data/config/timesheet_table_config.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_actions_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_table_width_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TimesheetTableRow extends ConsumerWidget with TimesheetPermissionMixin {
  final Timesheet timesheet;
  final bool isDark;

  const TimesheetTableRow({super.key, required this.timesheet, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timesheetNotifierProvider);
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText);
    final widths = ref.watch(timesheetTableWidthsProvider);
    final dividerColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (TimesheetTableConfig.showEmployee) _buildDivider(widths.employee, dividerColor),
                if (TimesheetTableConfig.showDepartment) _buildDivider(widths.department, dividerColor),
                if (TimesheetTableConfig.showWeekPeriod) _buildDivider(widths.weekPeriod, dividerColor),
                if (TimesheetTableConfig.showRegularHours) _buildDivider(widths.regularHours, dividerColor),
                if (TimesheetTableConfig.showOvertimeHours) _buildDivider(widths.overtimeHours, dividerColor),
                if (TimesheetTableConfig.showTotalHours) _buildDivider(widths.totalHours, dividerColor),
                if (TimesheetTableConfig.showStatus) _buildDivider(widths.status, dividerColor),
                if (TimesheetTableConfig.showActions) _buildDivider(widths.actions, dividerColor, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (TimesheetTableConfig.showEmployee)
                _buildDataCell(
                  Row(
                    children: [
                      AppAvatar(image: null, fallbackInitial: timesheet.employeeName, size: 35.w),
                      Gap(11.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              timesheet.employeeName.toUpperCase(),
                              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                            ),
                            Gap(2.h),
                            Text(timesheet.employeeNumber, style: secondaryStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  widths.employee,
                ),
              if (TimesheetTableConfig.showDepartment)
                _buildDataCell(Text(timesheet.departmentName.toUpperCase(), style: textStyle), widths.department),
              if (TimesheetTableConfig.showWeekPeriod)
                _buildDataCell(Text(timesheet.formattedWeekPeriod, style: textStyle), widths.weekPeriod),
              if (TimesheetTableConfig.showRegularHours)
                _buildDataCell(Text('${timesheet.regularHours.toInt()}h', style: textStyle), widths.regularHours),
              if (TimesheetTableConfig.showOvertimeHours)
                _buildDataCell(Text('${timesheet.overtimeHours.toInt()}h', style: textStyle), widths.overtimeHours),
              if (TimesheetTableConfig.showTotalHours)
                _buildDataCell(Text('${timesheet.totalHours.toInt()}h', style: textStyle), widths.totalHours),
              if (TimesheetTableConfig.showStatus)
                _buildDataCell(DigifyStatusCapsule(status: timesheet.status.name), widths.status),
              if (TimesheetTableConfig.showActions)
                _buildDataCell(_buildActionsCell(context, ref, state), widths.actions),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width, {Alignment alignment = Alignment.centerLeft}) {
    return Container(
      width: width,
      alignment: alignment,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: TimesheetTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildDivider(double width, Color dividerColor, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: dividerColor, width: 1.w),
              ),
      ),
    );
  }

  Widget _buildActionsCell(BuildContext context, WidgetRef ref, TimesheetState state) {
    if (timesheet.status == TimesheetStatus.draft) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canUpdateTimesheet)
            ActionButtonWidget(
              type: ActionButtonType.edit,
              onTap: () => EditTimesheetDialog.show(context, timesheet),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
        ],
      );
    }

    if (timesheet.status == TimesheetStatus.submitted) {
      final isApproving = state.approvingTimesheetGuid == timesheet.guid;
      final isRejecting = state.rejectingTimesheetGuid == timesheet.guid;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canViewTimesheet)
            ActionButtonWidget(
              type: ActionButtonType.view,
              onTap: () => context.push(AppRoutes.timeTrackingTimesheetDetail, extra: timesheet),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          if (canApproveTimesheet) ...[
            Gap(8.w),
            ActionButtonWidget(
              isLoading: isApproving,
              icon: Assets.icons.checkIconGreen.path,
              color: AppColors.success,
              onTap: isApproving || isRejecting
                  ? null
                  : () => TimesheetActions.approveTimesheet(context, ref, timesheet),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),

            Gap(8.w),
            ActionButtonWidget(
              icon: Assets.icons.closeIcon.path,
              color: AppColors.error,
              isLoading: isRejecting,
              onTap: isApproving || isRejecting
                  ? null
                  : () => TimesheetActions.rejectTimesheet(context, ref, timesheet),
              width: 18.w,
              height: 18.w,
              padding: 6.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canViewTimesheet)
          ActionButtonWidget(
            type: ActionButtonType.view,
            onTap: () => context.push(AppRoutes.timeTrackingTimesheetDetail, extra: timesheet),
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
      ],
    );
  }
}
