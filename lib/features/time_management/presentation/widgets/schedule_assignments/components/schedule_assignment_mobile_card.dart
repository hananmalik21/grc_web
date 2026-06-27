import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/action_button.dart';
import 'package:grc/core/widgets/buttons/icon_action_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/assignment_level_capsule.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ScheduleAssignmentMobileCard extends StatelessWidget {
  final String scheduleName;
  final String assignedToName;
  final AssignmentLevel assignmentLevel;
  final String startDate;
  final String endDate;
  final bool isActive;
  final bool isDeleting;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleAssignmentMobileCard({
    super.key,
    required this.scheduleName,
    required this.assignedToName,
    required this.assignmentLevel,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CardHeader(
              scheduleName: scheduleName,
              assignedToName: assignedToName,
              assignmentLevel: assignmentLevel,
              isActive: isActive,
              isDark: isDark,
            ),
            Gap(12.h),
            _DateRange(startDate: startDate, endDate: endDate, isDark: isDark),
            DigifyDivider(margin: EdgeInsets.symmetric(vertical: 12.h)),
            _CardActions(
              onView: onView,
              onEdit: onEdit,
              onDelete: onDelete,
              isDeleting: isDeleting,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String scheduleName;
  final String assignedToName;
  final AssignmentLevel assignmentLevel;
  final bool isActive;
  final bool isDark;

  const _CardHeader({
    required this.scheduleName,
    required this.assignedToName,
    required this.assignmentLevel,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyAsset(
          assetPath: Assets.icons.timeManagement.scheduleAssignment.path,
          width: 22,
          height: 22,
          color: AppColors.primary,
        ),
        Gap(10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                scheduleName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(3.h),
              Text(
                assignedToName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Gap(6.h),
              AssignmentLevelCapsule(level: assignmentLevel, isDark: isDark),
            ],
          ),
        ),
        Gap(8.w),
        DigifyStatusCapsule(status: isActive ? 'Active' : 'Inactive'),
      ],
    );
  }
}

class _DateRange extends StatelessWidget {
  final String startDate;
  final String endDate;
  final bool isDark;

  const _DateRange({
    required this.startDate,
    required this.endDate,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.labelSmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
    final valueStyle = context.textTheme.labelMedium?.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
      fontWeight: FontWeight.w500,
    );
    final emptyEnd = endDate.isEmpty || endDate == 'N/A';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start Date', style: labelStyle),
              Gap(2.h),
              Text(startDate.isEmpty ? '--' : startDate, style: valueStyle),
            ],
          ),
        ),
        Container(
          height: 24.h,
          width: 1,
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('End Date', style: labelStyle),
              Gap(2.h),
              Text(emptyEnd ? '--' : endDate, style: valueStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardActions extends StatelessWidget with ScheduleAssignmentsPermissionMixin {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const _CardActions({
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (canViewScheduleAssignment)
          Expanded(
            child: ActionButton(
              label: 'View',
              onTap: onView,
              iconPath: Assets.icons.viewIconBlue.path,
              backgroundColor: AppColors.infoBg,
              foregroundColor: AppColors.primary,
            ),
          ),
        if (canUpdateScheduleAssignment) ...[
          Gap(8.w),
          Expanded(
            child: ActionButton(
              label: 'Edit',
              onTap: onEdit,
              iconPath: Assets.icons.editIconGreen.path,
              backgroundColor: AppColors.greenBg,
              foregroundColor: AppColors.greenButton,
            ),
          ),
        ],
        if (canDeleteScheduleAssignment) ...[
          Gap(8.w),
          IconActionButton(
            iconPath: Assets.icons.deleteIconRed.path,
            bgColor: AppColors.errorBg,
            iconColor: AppColors.error,
            onPressed: isDeleting ? null : onDelete,
            isLoading: isDeleting,
          ),
        ],
      ],
    );
  }
}
