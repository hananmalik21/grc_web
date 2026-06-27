import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/leave_request_employee_detail_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestEmployeeDetailTableHeader extends StatelessWidget {
  const LeaveRequestEmployeeDetailTableHeader({super.key, required this.isDark, required this.localizations});

  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;

    return Container(
      color: headerColor,
      child: Row(
        children: [
          if (LeaveRequestEmployeeDetailTableConfig.showLeaveNumber)
            _buildHeaderCell(context, 'Leave #', LeaveRequestEmployeeDetailTableConfig.leaveNumberWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showLeaveType)
            _buildHeaderCell(context, localizations.tmType, LeaveRequestEmployeeDetailTableConfig.leaveTypeWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showDepartment)
            _buildHeaderCell(
              context,
              localizations.department,
              LeaveRequestEmployeeDetailTableConfig.departmentWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showPosition)
            _buildHeaderCell(context, localizations.position, LeaveRequestEmployeeDetailTableConfig.positionWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showStartDate)
            _buildHeaderCell(context, localizations.startDate, LeaveRequestEmployeeDetailTableConfig.startDateWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showEndDate)
            _buildHeaderCell(context, localizations.endDate, LeaveRequestEmployeeDetailTableConfig.endDateWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showDays)
            _buildHeaderCell(context, localizations.days, LeaveRequestEmployeeDetailTableConfig.daysWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showSubmittedAt)
            _buildHeaderCell(
              context,
              localizations.submittedAt,
              LeaveRequestEmployeeDetailTableConfig.submittedAtWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showProcessedAt)
            _buildHeaderCell(
              context,
              localizations.processedAt,
              LeaveRequestEmployeeDetailTableConfig.processedAtWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showReason)
            _buildHeaderCell(context, localizations.reason, LeaveRequestEmployeeDetailTableConfig.reasonWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showStatus)
            _buildHeaderCell(context, localizations.status, LeaveRequestEmployeeDetailTableConfig.statusWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showActions)
            _buildHeaderCell(context, localizations.actions, LeaveRequestEmployeeDetailTableConfig.actionsWidth.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Text(text.toUpperCase(), style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
