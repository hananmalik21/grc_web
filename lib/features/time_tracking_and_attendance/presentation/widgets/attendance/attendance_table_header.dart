import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_tracking_and_attendance/data/config/attendance_table_config.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceTableHeader extends ConsumerWidget {
  final bool isDark;

  const AttendanceTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widths = ref.watch(attendanceTableWidthsProvider);
    final lastColumn = _lastVisibleColumn();

    return Container(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          if (AttendanceTableConfig.showEmployee)
            _buildHeaderCell(
              context,
              'Employee',
              widths.employee,
              AttendanceColumn.employee,
              ref,
              isLast: lastColumn == AttendanceColumn.employee,
            ),
          if (AttendanceTableConfig.showDepartment)
            _buildHeaderCell(
              context,
              'Department',
              widths.department,
              AttendanceColumn.department,
              ref,
              isLast: lastColumn == AttendanceColumn.department,
            ),
          if (AttendanceTableConfig.showDate)
            _buildHeaderCell(
              context,
              'Date',
              widths.date,
              AttendanceColumn.date,
              ref,
              isLast: lastColumn == AttendanceColumn.date,
            ),
          if (AttendanceTableConfig.showCheckIn)
            _buildHeaderCell(
              context,
              'Check In',
              widths.checkIn,
              AttendanceColumn.checkIn,
              ref,
              isLast: lastColumn == AttendanceColumn.checkIn,
            ),
          if (AttendanceTableConfig.showCheckOut)
            _buildHeaderCell(
              context,
              'Check Out',
              widths.checkOut,
              AttendanceColumn.checkOut,
              ref,
              isLast: lastColumn == AttendanceColumn.checkOut,
            ),
          if (AttendanceTableConfig.showStatus)
            _buildHeaderCell(
              context,
              'Status',
              widths.status,
              AttendanceColumn.status,
              ref,
              isLast: lastColumn == AttendanceColumn.status,
            ),
          if (AttendanceTableConfig.showActions)
            _buildHeaderCell(
              context,
              'Actions',
              widths.actions,
              AttendanceColumn.actions,
              ref,
              isLast: lastColumn == AttendanceColumn.actions,
            ),
        ],
      ),
    );
  }

  AttendanceColumn _lastVisibleColumn() {
    if (AttendanceTableConfig.showActions) return AttendanceColumn.actions;
    if (AttendanceTableConfig.showStatus) return AttendanceColumn.status;
    if (AttendanceTableConfig.showCheckOut) return AttendanceColumn.checkOut;
    if (AttendanceTableConfig.showCheckIn) return AttendanceColumn.checkIn;
    if (AttendanceTableConfig.showDate) return AttendanceColumn.date;
    if (AttendanceTableConfig.showDepartment) return AttendanceColumn.department;
    return AttendanceColumn.employee;
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    AttendanceColumn column,
    WidgetRef ref, {
    TextAlign textAlign = TextAlign.left,
    bool isLast = false,
  }) {
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
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
              horizontal: AttendanceTableConfig.cellPaddingHorizontal.w,
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
                  ref.read(attendanceTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
