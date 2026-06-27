import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/data/config/schedule_assignments_table_config.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_table_width_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/assignment_level_capsule.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ScheduleAssignmentTableRowData {
  final int scheduleAssignmentId;
  final String assignedToName;
  final String assignedToCode;
  final AssignmentLevel assignmentLevel;
  final String scheduleName;
  final String startDate;
  final String endDate;
  final bool isActive;
  final String assignedByName;

  const ScheduleAssignmentTableRowData({
    required this.scheduleAssignmentId,
    required this.assignedToName,
    required this.assignedToCode,
    required this.assignmentLevel,
    required this.scheduleName,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.assignedByName,
  });
}

class ScheduleAssignmentTableRow extends ConsumerWidget {
  final ScheduleAssignmentTableRowData data;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ScheduleAssignmentTableRow({
    super.key,
    required this.data,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final widths = ref.watch(scheduleAssignmentsTableWidthsProvider);

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
                if (ScheduleAssignmentsTableConfig.showAssignedTo) _buildDivider(widths.assignedTo, isDark),
                if (ScheduleAssignmentsTableConfig.showAssignmentLevel) _buildDivider(widths.assignmentLevel, isDark),
                if (ScheduleAssignmentsTableConfig.showSchedule) _buildDivider(widths.schedule, isDark),
                if (ScheduleAssignmentsTableConfig.showStartDate) _buildDivider(widths.startDate, isDark),
                if (ScheduleAssignmentsTableConfig.showEndDate) _buildDivider(widths.endDate, isDark),
                if (ScheduleAssignmentsTableConfig.showStatus) _buildDivider(widths.status, isDark),
                if (ScheduleAssignmentsTableConfig.showAssignedBy) _buildDivider(widths.assignedBy, isDark),
                if (ScheduleAssignmentsTableConfig.showActions) _buildDivider(widths.actions, isDark, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (ScheduleAssignmentsTableConfig.showAssignedTo)
                _buildDataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.assignedToName,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        data.assignedToCode,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  widths.assignedTo,
                ),
              if (ScheduleAssignmentsTableConfig.showAssignmentLevel)
                _buildDataCell(
                  AssignmentLevelCapsule(level: data.assignmentLevel, isDark: isDark),
                  widths.assignmentLevel,
                ),
              if (ScheduleAssignmentsTableConfig.showSchedule)
                _buildDataCell(
                  Text(
                    data.scheduleName,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  widths.schedule,
                ),
              if (ScheduleAssignmentsTableConfig.showStartDate)
                _buildDataCell(
                  Text(
                    data.startDate,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  widths.startDate,
                ),
              if (ScheduleAssignmentsTableConfig.showEndDate)
                _buildDataCell(
                  Text(
                    data.endDate,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  widths.endDate,
                ),
              if (ScheduleAssignmentsTableConfig.showStatus)
                _buildDataCell(DigifyStatusCapsule(status: data.isActive ? 'Active' : 'InActive'), widths.status),
              if (ScheduleAssignmentsTableConfig.showAssignedBy)
                _buildDataCell(
                  Text(
                    data.assignedByName,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  widths.assignedBy,
                ),
              if (ScheduleAssignmentsTableConfig.showActions)
                _buildDataCell(
                  ScheduleAssignmentActionButtons(
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    isDeleting: isDeleting,
                  ),
                  widths.actions,
                ),
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
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
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
}
