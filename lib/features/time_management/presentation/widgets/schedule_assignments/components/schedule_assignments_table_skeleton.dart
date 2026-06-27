import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/data/config/schedule_assignments_table_config.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Skeleton rows for the schedule assignments table.
/// Renders inside an existing [Skeletonizer] — no container, no header, no scroll.
class ScheduleAssignmentsTableSkeleton extends ConsumerWidget {
  const ScheduleAssignmentsTableSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final widths = ref.watch(scheduleAssignmentsTableWidthsProvider);

    return Column(
      children: List.generate(
        itemCount,
        (_) => _SkeletonRow(isDark: isDark, widths: widths),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.isDark, required this.widths});

  final bool isDark;
  final ScheduleAssignmentsTableColumnWidths widths;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          if (ScheduleAssignmentsTableConfig.showAssignedTo)
            _buildCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Department Operations', style: TextStyle(fontSize: 13.sp)),
                  Gap(2.h),
                  Text('DEP-001', style: TextStyle(fontSize: 12.sp)),
                ],
              ),
              widths.assignedTo,
            ),
          if (ScheduleAssignmentsTableConfig.showAssignmentLevel)
            _buildCell(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.purpleBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text('DEPARTMENT', style: TextStyle(fontSize: 11.sp)),
              ),
              widths.assignmentLevel,
            ),
          if (ScheduleAssignmentsTableConfig.showSchedule)
            _buildCell(
              Text('Morning Shift Schedule', style: TextStyle(fontSize: 13.sp)),
              widths.schedule,
            ),
          if (ScheduleAssignmentsTableConfig.showStartDate)
            _buildCell(
              Text('01 Jan 2025', style: TextStyle(fontSize: 13.sp)),
              widths.startDate,
            ),
          if (ScheduleAssignmentsTableConfig.showEndDate)
            _buildCell(
              Text('31 Dec 2025', style: TextStyle(fontSize: 13.sp)),
              widths.endDate,
            ),
          if (ScheduleAssignmentsTableConfig.showStatus)
            _buildCell(
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text('Active', style: TextStyle(fontSize: 11.sp)),
              ),
              widths.status,
            ),
          if (ScheduleAssignmentsTableConfig.showAssignedBy)
            _buildCell(
              Text('System Admin', style: TextStyle(fontSize: 13.sp)),
              widths.assignedBy,
            ),
          if (ScheduleAssignmentsTableConfig.showActions)
            _buildCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 32.w, height: 32.w, decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6.r))),
                  Gap(6.w),
                  Container(width: 32.w, height: 32.w, decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6.r))),
                  Gap(6.w),
                  Container(width: 32.w, height: 32.w, decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6.r))),
                ],
              ),
              widths.actions,
            ),
        ],
      ),
    );
  }

  Widget _buildCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: child,
    );
  }
}
