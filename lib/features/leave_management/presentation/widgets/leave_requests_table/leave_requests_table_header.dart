import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/data/config/leave_requests_table_config.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestsTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const LeaveRequestsTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(leaveRequestsTableWidthsProvider);

    final headerCells = <Widget>[];

    if (LeaveRequestsTableConfig.showLeaveNumber) {
      headerCells.add(_buildHeaderCell(context, 'Leave #', widths.leaveNumber, LeaveRequestsColumn.leaveNumber, ref));
    }
    if (LeaveRequestsTableConfig.showEmployeeNumber) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.employeeNumber,
          widths.employeeNumber,
          LeaveRequestsColumn.employeeNumber,
          ref,
        ),
      );
    }
    if (LeaveRequestsTableConfig.showEmployee) {
      headerCells.add(
        _buildHeaderCell(context, localizations.employeeName, widths.employee, LeaveRequestsColumn.employee, ref),
      );
    }
    if (LeaveRequestsTableConfig.showDepartment) {
      headerCells.add(
        _buildHeaderCell(context, localizations.department, widths.department, LeaveRequestsColumn.department, ref),
      );
    }
    if (LeaveRequestsTableConfig.showPosition) {
      headerCells.add(
        _buildHeaderCell(context, localizations.position, widths.position, LeaveRequestsColumn.position, ref),
      );
    }
    if (LeaveRequestsTableConfig.showLeaveType) {
      headerCells.add(
        _buildHeaderCell(context, localizations.tmType, widths.leaveType, LeaveRequestsColumn.leaveType, ref),
      );
    }
    if (LeaveRequestsTableConfig.showStartDate) {
      headerCells.add(
        _buildHeaderCell(context, localizations.startDate, widths.startDate, LeaveRequestsColumn.startDate, ref),
      );
    }
    if (LeaveRequestsTableConfig.showEndDate) {
      headerCells.add(
        _buildHeaderCell(context, localizations.endDate, widths.endDate, LeaveRequestsColumn.endDate, ref),
      );
    }
    if (LeaveRequestsTableConfig.showDays) {
      headerCells.add(_buildHeaderCell(context, localizations.days, widths.days, LeaveRequestsColumn.days, ref));
    }
    if (LeaveRequestsTableConfig.showReason) {
      headerCells.add(_buildHeaderCell(context, localizations.reason, widths.reason, LeaveRequestsColumn.reason, ref));
    }
    if (LeaveRequestsTableConfig.showStatus) {
      headerCells.add(_buildHeaderCell(context, localizations.status, widths.status, LeaveRequestsColumn.status, ref));
    }
    if (LeaveRequestsTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.actions,
          widths.actions,
          LeaveRequestsColumn.actions,
          ref,
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
    LeaveRequestsColumn column,
    WidgetRef ref, {
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
                  ref.read(leaveRequestsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
