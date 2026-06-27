import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/screens/grade_structure/grade_structure_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/update_grade_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GradeStructureListMobile extends ConsumerWidget with GradeStructurePermissionMixin {
  const GradeStructureListMobile({super.key, required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gradeNotifierProvider);
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
            _GradeStructureMobileSkeleton(localizations: localizations, isDark: isDark)
          else if (state.errorMessage != null && state.items.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                state.errorMessage!,
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
              itemBuilder: (_, index) => _GradeMobileCard(
                grade: state.items[index],
                localizations: localizations,
                isDark: isDark,
                onEdit: canUpdateGrade ? () => UpdateGradeDialog.show(context, grade: state.items[index]) : null,
                onDelete: canDeleteGrade
                    ? () async {
                        final confirmed = await AppConfirmationDialog.show(
                          context,
                          title: localizations.delete,
                          message: 'Are you sure you want to delete this grade? This action cannot be undone.',
                          itemName: state.items[index].gradeLabel,
                          confirmLabel: localizations.delete,
                          cancelLabel: localizations.cancel,
                          type: ConfirmationType.danger,
                        );

                        if (confirmed == true && context.mounted) {
                          try {
                            await ref.read(gradeNotifierProvider.notifier).deleteGrade(state.items[index].id);
                            if (context.mounted) {
                              ToastService.success(context, 'Grade deleted successfully');
                            }
                          } catch (_) {
                            if (context.mounted) {
                              ToastService.error(context, 'Error deleting grade');
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
                  ? () => ref.read(gradeNotifierProvider.notifier).goToPage(state.currentPage - 1)
                  : null,
              onNext: state.hasNextPage && !state.isLoading
                  ? () => ref.read(gradeNotifierProvider.notifier).goToPage(state.currentPage + 1)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _GradeMobileCard extends StatelessWidget {
  const _GradeMobileCard({
    required this.grade,
    required this.localizations,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
  });

  final Grade grade;
  final AppLocalizations localizations;
  final bool isDark;
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
                grade.gradeLabel,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              DigifyStatusCapsule(status: grade.status),
            ],
          ),
          Gap(4.h),
          Text(
            grade.gradeCategoryLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          if (grade.description.isNotEmpty) ...[
            Gap(8.h),
            Text(
              grade.description,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          Gap(10.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onEdit != null)
                AppMobileButton(
                  svgPath: Assets.icons.editIconGreen.path,
                  backgroundColor: AppColors.editIconGreen,
                  type: AppButtonType.secondary,
                  onPressed: onEdit,
                ),
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

class _GradeStructureMobileSkeleton extends StatelessWidget {
  const _GradeStructureMobileSkeleton({required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  static final List<Grade> _dummyGrades = [
    Grade(
      id: 1,
      gradeNumber: '1',
      gradeNumberMeaningEn: 'Grade 1',
      gradeCategory: 'ENTRY',
      gradeCategoryMeaningEn: 'Entry Level',
      currencyCode: 'KWD',
      step1Salary: 1000,
      step2Salary: 1100,
      step3Salary: 1200,
      step4Salary: 1300,
      step5Salary: 1400,
      description: 'Supports foundational responsibilities across the team.',
      status: 'ACTIVE',
      createdBy: 'system',
      createdDate: DateTime(2024),
      lastUpdatedBy: 'system',
      lastUpdatedDate: DateTime(2024),
      lastUpdateLogin: 'system',
    ),
    Grade(
      id: 2,
      gradeNumber: '2',
      gradeNumberMeaningEn: 'Grade 2',
      gradeCategory: 'MID',
      gradeCategoryMeaningEn: 'Mid Level',
      currencyCode: 'KWD',
      step1Salary: 1500,
      step2Salary: 1600,
      step3Salary: 1700,
      step4Salary: 1800,
      step5Salary: 1900,
      description: 'Handles broader ownership and cross-functional delivery.',
      status: 'ACTIVE',
      createdBy: 'system',
      createdDate: DateTime(2024),
      lastUpdatedBy: 'system',
      lastUpdatedDate: DateTime(2024),
      lastUpdateLogin: 'system',
    ),
    Grade(
      id: 3,
      gradeNumber: '3',
      gradeNumberMeaningEn: 'Grade 3',
      gradeCategory: 'SENIOR',
      gradeCategoryMeaningEn: 'Senior Level',
      currencyCode: 'KWD',
      step1Salary: 2200,
      step2Salary: 2300,
      step3Salary: 2400,
      step4Salary: 2500,
      step5Salary: 2600,
      description: 'Leads strategic execution and mentoring responsibilities.',
      status: 'ACTIVE',
      createdBy: 'system',
      createdDate: DateTime(2024),
      lastUpdatedBy: 'system',
      lastUpdatedDate: DateTime(2024),
      lastUpdateLogin: 'system',
    ),
    Grade(
      id: 4,
      gradeNumber: '4',
      gradeNumberMeaningEn: 'Grade 4',
      gradeCategory: 'LEAD',
      gradeCategoryMeaningEn: 'Lead Level',
      currencyCode: 'KWD',
      step1Salary: 2800,
      step2Salary: 2900,
      step3Salary: 3000,
      step4Salary: 3100,
      step5Salary: 3200,
      description: 'Drives leadership decisions and enterprise-level direction.',
      status: 'ACTIVE',
      createdBy: 'system',
      createdDate: DateTime(2024),
      lastUpdatedBy: 'system',
      lastUpdatedDate: DateTime(2024),
      lastUpdateLogin: 'system',
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
        itemCount: _dummyGrades.length,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, index) => _GradeMobileCard(
          grade: _dummyGrades[index],
          localizations: localizations,
          isDark: isDark,
          onEdit: () {},
          onDelete: () {},
        ),
      ),
    );
  }
}
