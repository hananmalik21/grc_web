import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/delete_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/edit_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/work_pattern_details_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternMobileList extends StatelessWidget {
  const WorkPatternMobileList({
    super.key,
    required this.patterns,
    required this.enterpriseId,
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.onNext,
    this.onPrevious,
  });

  final List<WorkPattern> patterns;
  final int enterpriseId;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: patterns.length,
          separatorBuilder: (_, _) => Gap(12.h),
          itemBuilder: (context, index) => _WorkPatternCard(pattern: patterns[index], enterpriseId: enterpriseId),
        ),
        if (totalPages > 0) ...[
          PaginationControls.fromPaginationInfo(
            paginationInfo: PaginationInfo(
              currentPage: currentPage,
              totalPages: totalPages,
              totalItems: totalItems,
              pageSize: pageSize,
              hasNext: hasNextPage,
              hasPrevious: hasPreviousPage,
            ),
            currentPage: currentPage,
            pageSize: pageSize,
            onPrevious: hasPreviousPage ? onPrevious : null,
            onNext: hasNextPage ? onNext : null,
            style: PaginationStyle.simple,
          ),
        ],
        Gap(24.h),
      ],
    );
  }
}

class WorkPatternMobileListSkeleton extends StatelessWidget {
  const WorkPatternMobileListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Column(
      children: List.generate(
        4,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Container(
            height: 140.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: AppShadows.primaryShadow,
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkPatternCard extends StatelessWidget with WorkPatternsPermissionMixin {
  const _WorkPatternCard({required this.pattern, required this.enterpriseId});

  final WorkPattern pattern;
  final int enterpriseId;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isActive = pattern.status == PositionStatus.active;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: DigifyAsset(
                  assetPath: Assets.icons.leaveManagementMainIcon.path,
                  width: 22.w,
                  height: 22.w,
                  color: AppColors.primary,
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.patternNameEn,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (pattern.patternNameAr.isNotEmpty)
                      Text(
                        pattern.patternNameAr,
                        textDirection: TextDirection.rtl,
                        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Gap(6.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: [
                        DigifySquareCapsule(label: pattern.patternCode.toUpperCase()),
                        DigifySquareCapsule(label: pattern.patternType),
                      ],
                    ),
                  ],
                ),
              ),
              DigifyStatusCapsule(status: isActive ? 'Active' : 'Inactive'),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              _StatChip(label: '${pattern.totalHoursPerWeek}h/wk', icon: Icons.schedule_outlined, isDark: isDark),
              Gap(8.w),
              _StatChip(
                label: '${pattern.workingDays}W · ${pattern.restDays}R · ${pattern.offDays}O',
                icon: Icons.calendar_today_outlined,
                isDark: isDark,
              ),
            ],
          ),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canViewWorkPattern)
                AppMobileButton.primary(
                  svgPath: Assets.icons.viewIconBlue.path,
                  onPressed: () => WorkPatternDetailsDialog.show(context, pattern, enterpriseId: enterpriseId),
                ),
              if (canUpdateWorkPattern) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.editIconGreen.path,
                  backgroundColor: AppColors.editIconGreen,
                  type: AppButtonType.secondary,
                  onPressed: () => EditWorkPatternDialog.show(context, enterpriseId, pattern),
                ),
              ],
              if (canDeleteWorkPattern) ...[
                Gap(8.w),
                AppMobileButton.danger(
                  svgPath: Assets.icons.deleteIconRed.path,
                  onPressed: () => DeleteWorkPatternDialog.show(context, pattern, enterpriseId),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.icon, required this.isDark});
  final String label;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark.withValues(alpha: 0.5) : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.textSecondary),
          Gap(4.w),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
