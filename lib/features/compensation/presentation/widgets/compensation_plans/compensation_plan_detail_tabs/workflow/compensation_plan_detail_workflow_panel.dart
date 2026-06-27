import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'compensation_plan_detail_workflow_data.dart';
import 'compensation_plan_detail_workflow_empty_state.dart';
import 'compensation_plan_detail_workflow_timeline.dart';

class CompensationPlanDetailWorkflowPanel extends StatelessWidget {
  final List<WorkflowEvent> events;

  const CompensationPlanDetailWorkflowPanel({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark
        ? AppColors.borderGreyDark.withValues(alpha: 0.55)
        : AppColors.sidebarSecondaryText.withValues(alpha: 0.30);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Approval Workflow',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 18.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(4.h),
                Text(
                  'Plan creation and approval history',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          DigifyDivider.horizontal(),
          if (events.isEmpty)
            const CompensationPlanDetailWorkflowEmptyState()
          else
            CompensationPlanDetailWorkflowTimeline(events: events),
        ],
      ),
    );
  }
}
