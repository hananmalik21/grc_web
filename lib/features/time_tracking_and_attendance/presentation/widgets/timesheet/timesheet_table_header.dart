import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_tracking_and_attendance/data/config/timesheet_table_config.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimesheetTableHeader extends ConsumerWidget {
  final bool isDark;

  const TimesheetTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widths = ref.watch(timesheetTableWidthsProvider);
    final lastColumn = _lastVisibleColumn();
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          if (TimesheetTableConfig.showEmployee)
            _buildHeaderCell(
              context,
              'Employee',
              widths.employee,
              TimesheetColumn.employee,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == TimesheetColumn.employee,
            ),
          if (TimesheetTableConfig.showDepartment)
            _buildHeaderCell(
              context,
              'Department',
              widths.department,
              TimesheetColumn.department,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == TimesheetColumn.department,
            ),
          if (TimesheetTableConfig.showWeekPeriod)
            _buildHeaderCell(
              context,
              'Week Period',
              widths.weekPeriod,
              TimesheetColumn.weekPeriod,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == TimesheetColumn.weekPeriod,
            ),
          if (TimesheetTableConfig.showRegularHours)
            _buildHeaderCell(
              context,
              'Regular Hours',
              widths.regularHours,
              TimesheetColumn.regularHours,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == TimesheetColumn.regularHours,
              textAlign: TextAlign.center,
            ),
          if (TimesheetTableConfig.showOvertimeHours)
            _buildHeaderCell(
              context,
              'Overtime Hours',
              widths.overtimeHours,
              TimesheetColumn.overtimeHours,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == TimesheetColumn.overtimeHours,
              textAlign: TextAlign.center,
            ),
          if (TimesheetTableConfig.showTotalHours)
            _buildHeaderCell(
              context,
              'Total Hours',
              widths.totalHours,
              TimesheetColumn.totalHours,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == TimesheetColumn.totalHours,
              textAlign: TextAlign.center,
            ),
          if (TimesheetTableConfig.showStatus)
            _buildHeaderCell(
              context,
              'Status',
              widths.status,
              TimesheetColumn.status,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == TimesheetColumn.status,
            ),
          if (TimesheetTableConfig.showActions)
            _buildHeaderCell(
              context,
              'Actions',
              widths.actions,
              TimesheetColumn.actions,
              ref,
              borderColor: borderColor,
              isLast: true,
            ),
        ],
      ),
    );
  }

  TimesheetColumn _lastVisibleColumn() {
    if (TimesheetTableConfig.showActions) return TimesheetColumn.actions;
    if (TimesheetTableConfig.showStatus) return TimesheetColumn.status;
    if (TimesheetTableConfig.showTotalHours) return TimesheetColumn.totalHours;
    if (TimesheetTableConfig.showOvertimeHours) return TimesheetColumn.overtimeHours;
    if (TimesheetTableConfig.showRegularHours) return TimesheetColumn.regularHours;
    if (TimesheetTableConfig.showWeekPeriod) return TimesheetColumn.weekPeriod;
    if (TimesheetTableConfig.showDepartment) return TimesheetColumn.department;
    return TimesheetColumn.employee;
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    TimesheetColumn column,
    WidgetRef ref, {
    required Color borderColor,
    TextAlign textAlign = TextAlign.left,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : borderColor, width: 1.w),
          bottom: BorderSide(color: borderColor, width: 1.w),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: TimesheetTableConfig.cellPaddingHorizontal.w,
              vertical: 14.h,
            ),
            alignment: textAlign == TextAlign.center ? Alignment.center : Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
              textAlign: textAlign,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
            ),
          ),
          if (!isLast)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 15.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  ref.read(timesheetTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
