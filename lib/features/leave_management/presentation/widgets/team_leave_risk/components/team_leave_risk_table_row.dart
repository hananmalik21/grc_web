import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/team_leave_risk_table_config.dart';
import 'package:grc/features/leave_management/domain/models/team_leave_risk_employee.dart';
import 'package:grc/features/leave_management/presentation/widgets/team_leave_risk/components/team_leave_risk_action_buttons.dart';
import 'package:grc/features/leave_management/presentation/widgets/team_leave_risk/components/team_leave_risk_badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class TeamLeaveRiskTableRow extends StatelessWidget {
  final TeamLeaveRiskEmployee employee;
  final AppLocalizations localizations;
  final VoidCallback? onView;
  final VoidCallback? onApprove;

  const TeamLeaveRiskTableRow({
    super.key,
    required this.employee,
    required this.localizations,
    this.onView,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dateFormat = DateFormat('yyyy-MM-dd');
    final daysLeft = employee.daysUntilExpiry;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (TeamLeaveRiskTableConfig.showEmployee)
            _buildDataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    employee.name,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    employee.employeeId,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                    ),
                  ),
                  Gap(4.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Text(
                        employee.nameArabic,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TeamLeaveRiskTableConfig.employeeWidth.w,
            ),
          if (TeamLeaveRiskTableConfig.showDepartment)
            _buildDataCell(
              Text(
                employee.department,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              TeamLeaveRiskTableConfig.departmentWidth.w,
            ),
          if (TeamLeaveRiskTableConfig.showLeaveType)
            _buildDataCell(LeaveTypeBadge(leaveType: employee.leaveType), TeamLeaveRiskTableConfig.leaveTypeWidth.w),
          if (TeamLeaveRiskTableConfig.showTotalBalance)
            _buildDataCell(
              Center(
                child: Text(
                  '${employee.totalBalance.toStringAsFixed(employee.totalBalance == employee.totalBalance.toInt() ? 0 : 1)} days',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              TeamLeaveRiskTableConfig.totalBalanceWidth.w,
            ),
          if (TeamLeaveRiskTableConfig.showAtRiskDays)
            _buildDataCell(
              AtRiskDaysBadge(days: employee.atRiskDays),
              TeamLeaveRiskTableConfig.atRiskDaysWidth.w,
              center: true,
            ),
          if (TeamLeaveRiskTableConfig.showCarryForwardLimit)
            _buildDataCell(
              Center(
                child: Text(
                  '${employee.carryForwardLimit.toStringAsFixed(employee.carryForwardLimit == employee.carryForwardLimit.toInt() ? 0 : 1)} days',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
              TeamLeaveRiskTableConfig.carryForwardLimitWidth.w,
            ),
          if (TeamLeaveRiskTableConfig.showExpiryDate)
            _buildDataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateFormat.format(employee.expiryDate),
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    localizations.daysLeft(daysLeft),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              TeamLeaveRiskTableConfig.expiryDateWidth.w,
              center: true,
            ),
          if (TeamLeaveRiskTableConfig.showRiskLevel)
            _buildDataCell(
              RiskLevelBadge(riskLevel: employee.riskLevel),
              TeamLeaveRiskTableConfig.riskLevelWidth.w,
              center: true,
            ),
          if (TeamLeaveRiskTableConfig.showActions)
            _buildDataCell(
              TeamLeaveRiskActionButtons(onView: onView, onApprove: onApprove),
              TeamLeaveRiskTableConfig.actionsWidth.w,
              center: true,
            ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width, {bool center = false}) {
    return Container(
      width: width,
      alignment: center ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: child,
    );
  }
}
