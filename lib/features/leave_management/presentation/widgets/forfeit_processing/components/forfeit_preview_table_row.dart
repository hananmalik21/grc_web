import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/forfeit_preview_table_config.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/components/forfeit_preview_badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ForfeitPreviewTableRow extends StatelessWidget {
  final ForfeitPreviewEmployee employee;
  final AppLocalizations localizations;

  const ForfeitPreviewTableRow({super.key, required this.employee, required this.localizations});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (ForfeitPreviewTableConfig.showEmployee)
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
                ],
              ),
              ForfeitPreviewTableConfig.employeeWidth.w,
            ),
          if (ForfeitPreviewTableConfig.showDepartment)
            _buildDataCell(
              Text(
                employee.department,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              ForfeitPreviewTableConfig.departmentWidth.w,
            ),
          if (ForfeitPreviewTableConfig.showLeaveType)
            _buildDataCell(
              ForfeitLeaveTypeBadge(leaveType: employee.leaveType),
              ForfeitPreviewTableConfig.leaveTypeWidth.w,
            ),
          if (ForfeitPreviewTableConfig.showTotalBalance)
            _buildDataCell(
              Center(
                child: Text(
                  '${employee.totalBalance.toStringAsFixed(employee.totalBalance == employee.totalBalance.toInt() ? 0 : 1)} days',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              ForfeitPreviewTableConfig.totalBalanceWidth.w,
            ),
          if (ForfeitPreviewTableConfig.showCarryLimit)
            _buildDataCell(
              Center(
                child: Text(
                  '${employee.carryLimit.toStringAsFixed(employee.carryLimit == employee.carryLimit.toInt() ? 0 : 1)} days',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
              ForfeitPreviewTableConfig.carryLimitWidth.w,
            ),
          if (ForfeitPreviewTableConfig.showForfeitDays)
            _buildDataCell(
              ForfeitDaysBadge(days: employee.forfeitDays),
              ForfeitPreviewTableConfig.forfeitDaysWidth.w,
              center: true,
            ),
          if (ForfeitPreviewTableConfig.showExpiryDate)
            _buildDataCell(
              Center(
                child: Text(
                  dateFormat.format(employee.expiryDate),
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              ForfeitPreviewTableConfig.expiryDateWidth.w,
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
