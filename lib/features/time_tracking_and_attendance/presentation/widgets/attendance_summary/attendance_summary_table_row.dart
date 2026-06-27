import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_tracking_and_attendance/data/config/attendance_summary_table_config.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance_summary/attendance_summary_record.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance_summary/attendance_summary_table_width_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/attendance_summary_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceSummaryTableRow extends ConsumerWidget {
  final AttendanceSummaryRecord record;
  final bool isDark;

  const AttendanceSummaryTableRow({super.key, required this.record, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final nameStyle = context.textTheme.titleMedium;
    final widths = ref.watch(attendanceSummaryTableWidthsProvider);
    final dividerColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor, width: 1.w)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (AttendanceSummaryTableConfig.showEmployee) _buildDivider(widths.employee, dividerColor),
                if (AttendanceSummaryTableConfig.showDate) _buildDivider(widths.date, dividerColor),
                if (AttendanceSummaryTableConfig.showCheckIn) _buildDivider(widths.checkIn, dividerColor),
                if (AttendanceSummaryTableConfig.showCheckOut) _buildDivider(widths.checkOut, dividerColor),
                if (AttendanceSummaryTableConfig.showHours) _buildDivider(widths.hours, dividerColor),
                if (AttendanceSummaryTableConfig.showOvertime) _buildDivider(widths.overtime, dividerColor),
                if (AttendanceSummaryTableConfig.showStatus) _buildDivider(widths.status, dividerColor, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (AttendanceSummaryTableConfig.showEmployee)
                _buildDataCell(Text(record.employeeName ?? '----------------', style: nameStyle), widths.employee),
              if (AttendanceSummaryTableConfig.showDate)
                _buildDataCell(
                  Text(AttendanceSummaryFormatters.formatDate(record.attendanceDate), style: textStyle),
                  widths.date,
                ),
              if (AttendanceSummaryTableConfig.showCheckIn)
                _buildDataCell(
                  Text(AttendanceSummaryFormatters.formatTime(record.checkInTime), style: textStyle),
                  widths.checkIn,
                ),
              if (AttendanceSummaryTableConfig.showCheckOut)
                _buildDataCell(
                  Text(AttendanceSummaryFormatters.formatTime(record.checkOutTime), style: textStyle),
                  widths.checkOut,
                ),
              if (AttendanceSummaryTableConfig.showHours)
                _buildDataCell(Text(record.hoursWorked ?? '--', style: textStyle), widths.hours),
              if (AttendanceSummaryTableConfig.showOvertime)
                _buildDataCell(Text(record.overtimeHours?.toString() ?? '--', style: textStyle), widths.overtime),
              if (AttendanceSummaryTableConfig.showStatus)
                _buildDataCell(DigifyStatusCapsule(status: record.attendanceStatus ?? '-------'), widths.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AttendanceSummaryTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }

  Widget _buildDivider(double width, Color dividerColor, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast ? null : Border(right: BorderSide(color: dividerColor, width: 1.w)),
      ),
    );
  }
}
