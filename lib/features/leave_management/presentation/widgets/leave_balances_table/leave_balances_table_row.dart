import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/features/leave_management/data/config/leave_balances_table_config.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balances_table_width_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/all_leave_balances_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_badge.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:grc/core/utils/number_format_utils.dart';

typedef OnAdjustRequested = void Function(BuildContext context, LeaveBalanceSummaryItem item);

class LeaveBalancesTableRow extends ConsumerWidget with AllLeaveBalancesPermissionMixin {
  final LeaveBalanceSummaryItem item;
  final OnAdjustRequested? onAdjustRequested;

  const LeaveBalancesTableRow({super.key, required this.item, this.onAdjustRequested});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = _buildTextStyle(context, isDark);
    final widths = ref.watch(leaveBalancesTableWidthsProvider);

    final rowCells = <Widget>[];

    if (LeaveBalancesTableConfig.showEmployeeNumber) {
      rowCells.add(_buildEmployeeNumberCell(context, textStyle, widths.employeeNumber));
    }
    if (LeaveBalancesTableConfig.showEmployee) {
      rowCells.add(_buildEmployeeNameCell(context, textStyle, widths.employee));
    }
    if (LeaveBalancesTableConfig.showDepartment) {
      rowCells.add(_buildDepartmentCell(context, textStyle, widths.department));
    }
    if (LeaveBalancesTableConfig.showJoinDate) {
      rowCells.add(_buildJoinDateCell(context, textStyle, widths.joinDate));
    }
    if (LeaveBalancesTableConfig.showAnnualLeave) {
      rowCells.add(
        _buildLeaveBalanceCell(context, item.annualLeave, LeaveBadgeType.annualLeave, widths.annualLeave, center: true),
      );
    }
    if (LeaveBalancesTableConfig.showSickLeave) {
      rowCells.add(
        _buildLeaveBalanceCell(context, item.sickLeave, LeaveBadgeType.sickLeave, widths.sickLeave, center: true),
      );
    }
    if (LeaveBalancesTableConfig.showUnpaidLeave) {
      rowCells.add(_buildLeaveBalanceCell(context, 0, LeaveBadgeType.unpaidLeave, widths.unpaidLeave, center: true));
    }
    if (LeaveBalancesTableConfig.showTotalAvailable) {
      rowCells.add(
        _buildLeaveBalanceCell(
          context,
          item.totalAvailable,
          LeaveBadgeType.totalAvailable,
          widths.totalAvailable,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showActions) {
      rowCells.add(_buildDataCell(_buildActionsCell(context, localizations), widths.actions, center: true));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (LeaveBalancesTableConfig.showEmployeeNumber) _buildDivider(widths.employeeNumber, isDark),
                if (LeaveBalancesTableConfig.showEmployee) _buildDivider(widths.employee, isDark),
                if (LeaveBalancesTableConfig.showDepartment) _buildDivider(widths.department, isDark),
                if (LeaveBalancesTableConfig.showJoinDate) _buildDivider(widths.joinDate, isDark),
                if (LeaveBalancesTableConfig.showAnnualLeave) _buildDivider(widths.annualLeave, isDark),
                if (LeaveBalancesTableConfig.showSickLeave) _buildDivider(widths.sickLeave, isDark),
                if (LeaveBalancesTableConfig.showUnpaidLeave) _buildDivider(widths.unpaidLeave, isDark),
                if (LeaveBalancesTableConfig.showTotalAvailable) _buildDivider(widths.totalAvailable, isDark),
                if (LeaveBalancesTableConfig.showActions) _buildDivider(widths.actions, isDark, isLast: true),
              ],
            ),
          ),
          Row(children: rowCells),
        ],
      ),
    );
  }

  TextStyle? _buildTextStyle(BuildContext context, bool isDark) {
    return context.textTheme.titleSmall?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);
  }

  Widget _buildEmployeeNameCell(BuildContext context, TextStyle? textStyle, double width) {
    final name = item.employeeName.trim().isEmpty ? '-' : item.employeeName;
    return _buildDataCell(Text(name, style: textStyle), width);
  }

  Widget _buildEmployeeNumberCell(BuildContext context, TextStyle? textStyle, double width) {
    return _buildDataCell(Text(item.employeeNumber.isEmpty ? '-' : item.employeeNumber, style: textStyle), width);
  }

  Widget _buildDepartmentCell(BuildContext context, TextStyle? textStyle, double width) {
    return _buildDataCell(Text(item.department.isEmpty ? '-' : item.department, style: textStyle), width);
  }

  Widget _buildJoinDateCell(BuildContext context, TextStyle? textStyle, double width) {
    final text = item.joinDate != null ? DateFormat('yyyy-MM-dd').format(item.joinDate!) : '-';
    return _buildDataCell(Text(text, style: textStyle), width);
  }

  Widget _buildLeaveBalanceCell(
    BuildContext context,
    double value,
    LeaveBadgeType type,
    double width, {
    bool center = false,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return _buildDataCell(
      LeaveBalanceBadge(text: '${NumberFormatUtils.formatDays(value)} ${localizations.days.toLowerCase()}', type: type),
      width,
      center: center,
    );
  }

  Widget _buildDataCell(Widget child, double width, {bool center = false}) {
    return Container(
      width: width,
      alignment: center ? Alignment.center : Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
      child: child,
    );
  }

  Widget _buildDivider(double width, bool isDark, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }

  Widget _buildActionsCell(BuildContext context, AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.w,
      children: [
        if (canViewLeaveBalance)
          ActionButtonWidget(
            type: ActionButtonType.view,
            onTap: () => _handleDetails(context),
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
        if (canUpdateLeaveBalance)
          ActionButtonWidget(
            type: ActionButtonType.edit,
            onTap: () => _handleAdjust(context),
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
      ],
    );
  }

  void _handleAdjust(BuildContext context) {
    onAdjustRequested?.call(context, item);
  }

  void _handleDetails(BuildContext context) {
    LeaveDetailsDialog.show(context, item: item);
  }
}
