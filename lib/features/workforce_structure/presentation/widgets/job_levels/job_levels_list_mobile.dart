import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_level_detail_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JobLevelsListMobile extends ConsumerWidget with JobLevelsPermissionMixin {
  const JobLevelsListMobile({super.key, required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobLevelNotifierProvider);
    final hasPaginationData = state.totalPages > 0 || state.items.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          if (state.isLoading)
            _JobLevelsMobileSkeleton(localizations: localizations, isDark: isDark)
          else if (state.hasError && state.items.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                state.errorMessage ?? localizations.somethingWentWrong,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            )
          else if (state.items.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                localizations.noResultsFound,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (_, index) => _JobLevelMobileCard(
                level: state.items[index],
                localizations: localizations,
                isDark: isDark,
                onView: canViewJobLevel ? () => JobLevelDetailDialog.show(context, state.items[index]) : null,
                onEdit: canUpdateJobLevel
                    ? () => JobLevelFormDialog.show(context, jobLevel: state.items[index], isEdit: true, onSave: (_) {})
                    : null,
                onDelete: canDeleteJobLevel
                    ? () async {
                        final confirmed = await DeleteConfirmationDialog.show(
                          context,
                          title: localizations.deleteJobLevel,
                          message: localizations.deleteJobLevelConfirmationMessage,
                          itemName: state.items[index].nameEn,
                        );
                        if (confirmed == true) {
                          try {
                            await ref.read(jobLevelNotifierProvider.notifier).deleteJobLevel(state.items[index].id);
                            if (context.mounted) {
                              ToastService.success(context, localizations.jobLevelDeletedSuccessfully);
                            }
                          } catch (_) {
                            if (context.mounted) {
                              ToastService.error(context, localizations.errorDeletingJobLevel);
                            }
                          }
                        }
                      }
                    : null,
              ),
            ),
          if (hasPaginationData) ...[
            const DigifyDivider.horizontal(),
            MobilePaginationControls(
              isDark: isDark,
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              hasPrevious: state.hasPreviousPage,
              hasNext: state.hasNextPage,
              onPrevious: state.hasPreviousPage && !state.isLoading
                  ? () => ref.read(jobLevelNotifierProvider.notifier).goToPage(state.currentPage - 1)
                  : null,
              onNext: state.hasNextPage && !state.isLoading
                  ? () => ref.read(jobLevelNotifierProvider.notifier).goToPage(state.currentPage + 1)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _JobLevelMobileCard extends StatelessWidget {
  const _JobLevelMobileCard({
    required this.level,
    required this.localizations,
    required this.isDark,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final JobLevel level;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                level.nameEn,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              DigifyStatusCapsule(status: level.status),
            ],
          ),
          Gap(4.h),
          Text(
            level.code,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(10.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onView != null) AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: onView),
              if (onEdit != null) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.editIconGreen.path,
                  backgroundColor: AppColors.editIconGreen,
                  type: AppButtonType.secondary,
                  onPressed: onEdit,
                ),
              ],
              if (onDelete != null) ...[
                Gap(8.w),
                AppMobileButton.danger(svgPath: Assets.icons.deleteIconRed.path, onPressed: onDelete),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _JobLevelsMobileSkeleton extends StatelessWidget {
  const _JobLevelsMobileSkeleton({required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  static final Grade _dummyGrade = Grade(
    id: 1,
    gradeNumber: '1',
    gradeCategory: 'Entry',
    currencyCode: 'KWD',
    step1Salary: 0,
    step2Salary: 0,
    step3Salary: 0,
    step4Salary: 0,
    step5Salary: 0,
    description: 'Skeleton grade',
    status: 'ACTIVE',
    createdBy: 'system',
    createdDate: DateTime(2024),
    lastUpdatedBy: 'system',
    lastUpdatedDate: DateTime(2024),
    lastUpdateLogin: 'system',
  );

  static final List<JobLevel> _dummyLevels = [
    JobLevel(
      id: 1,
      nameEn: 'Senior Software Engineer',
      code: 'SSE-01',
      description: 'Lead engineering delivery across teams.',
      minGradeId: 1,
      maxGradeId: 1,
      status: 'ACTIVE',
      minGrade: _dummyGrade,
      maxGrade: _dummyGrade,
      totalPositions: 12,
      filledPositions: 9,
    ),
    JobLevel(
      id: 2,
      nameEn: 'Engineering Manager',
      code: 'EM-02',
      description: 'Manage team operations and growth.',
      minGradeId: 1,
      maxGradeId: 1,
      status: 'ACTIVE',
      minGrade: _dummyGrade,
      maxGrade: _dummyGrade,
      totalPositions: 6,
      filledPositions: 4,
    ),
    JobLevel(
      id: 3,
      nameEn: 'Product Designer',
      code: 'PD-03',
      description: 'Design end-to-end product experiences.',
      minGradeId: 1,
      maxGradeId: 1,
      status: 'ACTIVE',
      minGrade: _dummyGrade,
      maxGrade: _dummyGrade,
      totalPositions: 8,
      filledPositions: 5,
    ),
    JobLevel(
      id: 4,
      nameEn: 'HR Business Partner',
      code: 'HRBP-04',
      description: 'Support workforce planning and operations.',
      minGradeId: 1,
      maxGradeId: 1,
      status: 'ACTIVE',
      minGrade: _dummyGrade,
      maxGrade: _dummyGrade,
      totalPositions: 5,
      filledPositions: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
        itemCount: _dummyLevels.length,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, index) => _JobLevelMobileCard(
          level: _dummyLevels[index],
          localizations: localizations,
          isDark: isDark,
          onView: () {},
          onEdit: () {},
          onDelete: () {},
        ),
      ),
    );
  }
}
