import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_tracking_and_attendance/data/config/attendance_summary_table_config.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance_summary/attendance_summary_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceSummaryTableHeader extends ConsumerWidget {
  final bool isDark;

  const AttendanceSummaryTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widths = ref.watch(attendanceSummaryTableWidthsProvider);
    final lastColumn = _lastVisibleColumn();
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          if (AttendanceSummaryTableConfig.showEmployee)
            _buildHeaderCell(
              context,
              'Employee',
              widths.employee,
              AttendanceSummaryColumn.employee,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == AttendanceSummaryColumn.employee,
            ),
          if (AttendanceSummaryTableConfig.showDate)
            _buildHeaderCell(
              context,
              'Date',
              widths.date,
              AttendanceSummaryColumn.date,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == AttendanceSummaryColumn.date,
            ),
          if (AttendanceSummaryTableConfig.showCheckIn)
            _buildHeaderCell(
              context,
              'Check In',
              widths.checkIn,
              AttendanceSummaryColumn.checkIn,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == AttendanceSummaryColumn.checkIn,
            ),
          if (AttendanceSummaryTableConfig.showCheckOut)
            _buildHeaderCell(
              context,
              'Check Out',
              widths.checkOut,
              AttendanceSummaryColumn.checkOut,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == AttendanceSummaryColumn.checkOut,
            ),
          if (AttendanceSummaryTableConfig.showHours)
            _buildHeaderCell(
              context,
              'Hours',
              widths.hours,
              AttendanceSummaryColumn.hours,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == AttendanceSummaryColumn.hours,
            ),
          if (AttendanceSummaryTableConfig.showOvertime)
            _buildHeaderCell(
              context,
              'Overtime',
              widths.overtime,
              AttendanceSummaryColumn.overtime,
              ref,
              borderColor: borderColor,
              isLast: lastColumn == AttendanceSummaryColumn.overtime,
            ),
          if (AttendanceSummaryTableConfig.showStatus)
            _buildHeaderCell(
              context,
              'Status',
              widths.status,
              AttendanceSummaryColumn.status,
              ref,
              borderColor: borderColor,
              isLast: true,
            ),
        ],
      ),
    );
  }

  AttendanceSummaryColumn _lastVisibleColumn() {
    if (AttendanceSummaryTableConfig.showActions) return AttendanceSummaryColumn.actions;
    if (AttendanceSummaryTableConfig.showStatus) return AttendanceSummaryColumn.status;
    if (AttendanceSummaryTableConfig.showOvertime) return AttendanceSummaryColumn.overtime;
    if (AttendanceSummaryTableConfig.showHours) return AttendanceSummaryColumn.hours;
    if (AttendanceSummaryTableConfig.showCheckOut) return AttendanceSummaryColumn.checkOut;
    if (AttendanceSummaryTableConfig.showCheckIn) return AttendanceSummaryColumn.checkIn;
    if (AttendanceSummaryTableConfig.showDate) return AttendanceSummaryColumn.date;
    return AttendanceSummaryColumn.employee;
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    AttendanceSummaryColumn column,
    WidgetRef ref, {
    required Color borderColor,
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
              horizontal: AttendanceSummaryTableConfig.cellPaddingHorizontal.w,
              vertical: 14.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
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
                  ref.read(attendanceSummaryTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
