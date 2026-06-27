import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/data/config/schedule_assignments_table_config.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentTableHeader extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;

  const ScheduleAssignmentTableHeader({super.key, required this.isDark, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(scheduleAssignmentsTableWidthsProvider);

    final headerCells = <Widget>[];
    if (ScheduleAssignmentsTableConfig.showAssignedTo) {
      headerCells.add(
        _buildHeaderCell(context, 'Assigned To', widths.assignedTo, ScheduleAssignmentColumn.assignedTo, ref),
      );
    }
    if (ScheduleAssignmentsTableConfig.showAssignmentLevel) {
      headerCells.add(
        _buildHeaderCell(
          context,
          'Assignment Level',
          widths.assignmentLevel,
          ScheduleAssignmentColumn.assignmentLevel,
          ref,
        ),
      );
    }
    if (ScheduleAssignmentsTableConfig.showSchedule) {
      headerCells.add(_buildHeaderCell(context, 'Schedule', widths.schedule, ScheduleAssignmentColumn.schedule, ref));
    }
    if (ScheduleAssignmentsTableConfig.showStartDate) {
      headerCells.add(
        _buildHeaderCell(context, 'Start Date', widths.startDate, ScheduleAssignmentColumn.startDate, ref),
      );
    }
    if (ScheduleAssignmentsTableConfig.showEndDate) {
      headerCells.add(_buildHeaderCell(context, 'End Date', widths.endDate, ScheduleAssignmentColumn.endDate, ref));
    }
    if (ScheduleAssignmentsTableConfig.showStatus) {
      headerCells.add(
        _buildHeaderCell(context, localizations.status, widths.status, ScheduleAssignmentColumn.status, ref),
      );
    }
    if (ScheduleAssignmentsTableConfig.showAssignedBy) {
      headerCells.add(
        _buildHeaderCell(context, 'Assigned By', widths.assignedBy, ScheduleAssignmentColumn.assignedBy, ref),
      );
    }
    if (ScheduleAssignmentsTableConfig.showActions) {
      headerCells.add(
        _buildHeaderCell(
          context,
          localizations.actions,
          widths.actions,
          ScheduleAssignmentColumn.actions,
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
    ScheduleAssignmentColumn column,
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
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
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
                  ref.read(scheduleAssignmentsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
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
