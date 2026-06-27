import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedule_card_actions.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleMobileCard extends StatelessWidget {
  final String title;
  final String? titleArabic;
  final String code;
  final bool isActive;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final bool isDeleting;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WorkScheduleMobileCard({
    super.key,
    required this.title,
    this.titleArabic,
    required this.code,
    required this.isActive,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.onViewDetails,
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
            _Header(title: title, titleArabic: titleArabic, code: code, isActive: isActive, isDark: isDark),
            Gap(12.h),
            _DateRange(startDate: effectiveStartDate, endDate: effectiveEndDate, isDark: isDark),
            DigifyDivider(margin: EdgeInsets.symmetric(vertical: 12.h)),
            WorkScheduleCardActions(
              onViewDetails: onViewDetails,
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

class _Header extends StatelessWidget {
  final String title;
  final String? titleArabic;
  final String code;
  final bool isActive;
  final bool isDark;

  const _Header({
    required this.title,
    this.titleArabic,
    required this.code,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyAsset(
          assetPath: Assets.icons.sidebar.workSchedules.path,
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
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (titleArabic != null && titleArabic!.isNotEmpty) ...[
                Gap(2.h),
                Text(
                  titleArabic!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
              Gap(6.h),
              DigifySquareCapsule(
                label: code.toUpperCase(),
                backgroundColor: AppColors.jobRoleBg,
                textColor: AppColors.infoText,
              ),
            ],
          ),
        ),
        DigifyStatusCapsule(status: isActive ? 'Active' : 'Inactive'),
      ],
    );
  }
}

class _DateRange extends StatelessWidget {
  final String startDate;
  final String endDate;
  final bool isDark;

  const _DateRange({required this.startDate, required this.endDate, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.labelSmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
    final valueStyle = context.textTheme.labelMedium?.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
      fontWeight: FontWeight.w500,
    );

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
              Text(endDate.isEmpty ? '--' : endDate, style: valueStyle),
            ],
          ),
        ),
      ],
    );
  }
}
