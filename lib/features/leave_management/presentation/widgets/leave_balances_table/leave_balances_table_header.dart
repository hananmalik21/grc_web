import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/leave_balances_table_config.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balances_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalancesTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const LeaveBalancesTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(leaveBalancesTableWidthsProvider);

    final headerCells = <Widget>[];

    if (LeaveBalancesTableConfig.showEmployeeNumber) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.employeeNumber,
          widths.employeeNumber,
          LeaveBalancesColumn.employeeNumber,
          ref,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showEmployee) {
      headerCells.add(
        _buildHeaderCell(context, localizations.employeeName, widths.employee, LeaveBalancesColumn.employee, ref),
      );
    }
    if (LeaveBalancesTableConfig.showDepartment) {
      headerCells.add(
        _buildHeaderCell(context, localizations.department, widths.department, LeaveBalancesColumn.department, ref),
      );
    }
    if (LeaveBalancesTableConfig.showJoinDate) {
      headerCells.add(
        _buildHeaderCell(context, localizations.joinDate, widths.joinDate, LeaveBalancesColumn.joinDate, ref),
      );
    }
    if (LeaveBalancesTableConfig.showAnnualLeave) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.annualLeave,
          widths.annualLeave,
          LeaveBalancesColumn.annualLeave,
          ref,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showSickLeave) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.sickLeave,
          widths.sickLeave,
          LeaveBalancesColumn.sickLeave,
          ref,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showUnpaidLeave) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'Unpaid Leave',
          widths.unpaidLeave,
          LeaveBalancesColumn.unpaidLeave,
          ref,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showTotalAvailable) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'Total Available',
          widths.totalAvailable,
          LeaveBalancesColumn.totalAvailable,
          ref,
          center: true,
        ),
      );
    }
    if (LeaveBalancesTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.actions,
          widths.actions,
          LeaveBalancesColumn.actions,
          ref,
          center: true,
          isLast: true,
        ),
      );
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    LeaveBalancesColumn column,
    WidgetRef ref, {
    bool center = false,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 12.h),
            alignment: center ? Alignment.center : Alignment.centerLeft,
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
                  ref.read(leaveBalancesTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
