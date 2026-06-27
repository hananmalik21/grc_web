import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/features/time_tracking_and_attendance/data/config/attendance_table_config.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/mark_attendance_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_table_width_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'attendance_status_chip.dart';

class AttendanceTableRow extends ConsumerWidget with AttendancePermissionMixin {
  final AttendanceRecord record;
  final bool isDark;
  final bool isExpanded;
  final VoidCallback onToggle;

  const AttendanceTableRow({
    super.key,
    required this.record,
    required this.isDark,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText);
    final widths = ref.watch(attendanceTableWidthsProvider);
    final dividerColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return InkWell(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: isExpanded
              ? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarActiveBg.withAlpha(128))
              : null,
          border: isExpanded
              ? null
              : Border(
                  bottom: BorderSide(color: dividerColor, width: 1.w),
                ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  if (AttendanceTableConfig.showEmployee) _buildDivider(widths.employee, dividerColor),
                  if (AttendanceTableConfig.showDepartment) _buildDivider(widths.department, dividerColor),
                  if (AttendanceTableConfig.showDate) _buildDivider(widths.date, dividerColor),
                  if (AttendanceTableConfig.showCheckIn) _buildDivider(widths.checkIn, dividerColor),
                  if (AttendanceTableConfig.showCheckOut) _buildDivider(widths.checkOut, dividerColor),
                  if (AttendanceTableConfig.showStatus) _buildDivider(widths.status, dividerColor),
                  if (AttendanceTableConfig.showActions) _buildDivider(widths.actions, dividerColor, isLast: true),
                ],
              ),
            ),
            Row(
              children: [
                if (AttendanceTableConfig.showEmployee)
                  _buildDataCell(
                    Row(
                      children: [
                        AnimatedRotation(
                          turns: isExpanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: isExpanded
                                ? AppColors.statIconBlue
                                : isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.dialogCloseIcon,
                            size: 20.r,
                          ),
                        ),
                        Gap(8.w),
                        AppAvatar(image: null, fallbackInitial: record.employeeName, size: 35.w),
                        Gap(11.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                record.employeeName.toUpperCase(),
                                style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                              ),
                              Gap(2.h),
                              Text(record.employeeId, style: secondaryStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                    widths.employee,
                  ),
                if (AttendanceTableConfig.showDepartment)
                  _buildDataCell(
                    Text(
                      (record.departmentName.isEmpty ? record.displayValue(null) : record.departmentName).toUpperCase(),
                      style: textStyle,
                    ),
                    widths.department,
                  ),
                if (AttendanceTableConfig.showDate)
                  _buildDataCell(Text(DateFormat('MMM d, yyyy').format(record.date), style: textStyle), widths.date),
                if (AttendanceTableConfig.showCheckIn)
                  _buildDataCell(Text(record.displayValue(record.checkIn), style: textStyle), widths.checkIn),
                if (AttendanceTableConfig.showCheckOut)
                  _buildDataCell(Text(record.displayValue(record.checkOut), style: textStyle), widths.checkOut),
                if (AttendanceTableConfig.showStatus)
                  _buildDataCell(AttendanceStatusChip(status: record.status), widths.status),
                if (AttendanceTableConfig.showActions)
                  _buildDataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: canUpdateAttendance
                          ? [
                              ActionButtonWidget(
                                type: ActionButtonType.edit,
                                onTap: () {
                                  if (record.attendance != null) {
                                    MarkAttendanceDialog.show(context, attendanceRecord: record);
                                  }
                                },
                                width: 18.w,
                                height: 18.w,
                                padding: 6.w,
                                borderRadius: BorderRadius.circular(6.r),
                                customBorder: null,
                              ),
                              Gap(8.w),
                              ActionButtonWidget(
                                icon: Assets.icons.locationIcon.path,
                                width: 18.w,
                                height: 18.w,
                                padding: 6.w,
                                customBorder: null,
                                borderRadius: BorderRadius.circular(6.r),
                                tooltip: 'Location',
                                color: AppColors.primary,
                                onTap: () {},
                              ),
                            ]
                          : [Text('No Actions', style: context.textTheme.labelSmall)],
                    ),
                    widths.actions,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AttendanceTableConfig.cellPaddingHorizontal.w,
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
}
