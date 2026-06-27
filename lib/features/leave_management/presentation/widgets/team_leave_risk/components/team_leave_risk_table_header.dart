import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/team_leave_risk_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamLeaveRiskTableHeader extends StatelessWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const TeamLeaveRiskTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final headerColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;

    final headerCells = <Widget>[];

    if (TeamLeaveRiskTableConfig.showEmployee) {
      headerCells.add(_buildHeaderCell(context, localizations.employee, TeamLeaveRiskTableConfig.employeeWidth.w));
    }
    if (TeamLeaveRiskTableConfig.showDepartment) {
      headerCells.add(_buildHeaderCell(context, localizations.department, TeamLeaveRiskTableConfig.departmentWidth.w));
    }
    if (TeamLeaveRiskTableConfig.showLeaveType) {
      headerCells.add(_buildHeaderCell(context, localizations.leaveType, TeamLeaveRiskTableConfig.leaveTypeWidth.w));
    }
    if (TeamLeaveRiskTableConfig.showTotalBalance) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.totalBalance,
          TeamLeaveRiskTableConfig.totalBalanceWidth.w,
          center: true,
        ),
      );
    }
    if (TeamLeaveRiskTableConfig.showAtRiskDays) {
      headerCells.add(
        _buildHeaderCell(context, localizations.atRiskDays, TeamLeaveRiskTableConfig.atRiskDaysWidth.w, center: true),
      );
    }
    if (TeamLeaveRiskTableConfig.showCarryForwardLimit) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.carryForwardLimit,
          TeamLeaveRiskTableConfig.carryForwardLimitWidth.w,
          center: true,
        ),
      );
    }
    if (TeamLeaveRiskTableConfig.showExpiryDate) {
      headerCells.add(
        _buildHeaderCell(context, localizations.expiryDate, TeamLeaveRiskTableConfig.expiryDateWidth.w, center: true),
      );
    }
    if (TeamLeaveRiskTableConfig.showRiskLevel) {
      headerCells.add(
        _buildHeaderCell(context, localizations.riskLevel, TeamLeaveRiskTableConfig.riskLevelWidth.w, center: true),
      );
    }
    if (TeamLeaveRiskTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(context, localizations.actions, TeamLeaveRiskTableConfig.actionsWidth.w, center: true),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {bool center = false}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(text, style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText)),
    );
  }
}
