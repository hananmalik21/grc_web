import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_detail_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/delete_job_family_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JobFamiliesListMobile extends ConsumerWidget with JobFamiliesPermissionMixin {
  const JobFamiliesListMobile({super.key, required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobFamilyNotifierProvider);
    final jobLevels = ref.watch(jobLevelListProvider);

    final hasPaginationData = state.totalPages > 0 || state.items.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.isLoading)
            const _JobFamiliesMobileSkeleton()
          else if (state.hasError && state.items.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  state.errorMessage ?? localizations.somethingWentWrong,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (state.items.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  localizations.noResultsFound,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
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
              itemBuilder: (_, index) => _JobFamilyMobileCard(
                jobFamily: state.items[index],
                localizations: localizations,
                isDark: isDark,
                onView: canViewJobFamily
                    ? () => JobFamilyDetailDialog.show(context, jobFamily: state.items[index], jobLevels: jobLevels)
                    : null,
                onEdit: canUpdateJobFamily
                    ? () =>
                          JobFamilyFormDialog.show(context, jobFamily: state.items[index], isEdit: true, onSave: (_) {})
                    : null,
                onDelete: canDeleteJobFamily
                    ? () => DeleteJobFamilyDialog.show(context, jobFamily: state.items[index])
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
                  ? () => ref.read(jobFamilyNotifierProvider.notifier).goToPage(state.currentPage - 1)
                  : null,
              onNext: state.hasNextPage && !state.isLoading
                  ? () => ref.read(jobFamilyNotifierProvider.notifier).goToPage(state.currentPage + 1)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _JobFamilyMobileCard extends StatelessWidget {
  const _JobFamilyMobileCard({
    required this.jobFamily,
    required this.localizations,
    required this.isDark,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final JobFamily jobFamily;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final status = jobFamily.isActive == true ? 'ACTIVE' : 'INACTIVE';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobFamily.nameEnglish,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(4.h),
                    Text(
                      jobFamily.code,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: status),
            ],
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

class _JobFamiliesMobileSkeleton extends StatelessWidget {
  const _JobFamiliesMobileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
        itemCount: 6,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, _) => Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.dashboardCardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 180.w,
                height: 14.h,
                decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6.r)),
              ),
              Gap(6.h),
              Container(
                width: 110.w,
                height: 12.h,
                decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6.r)),
              ),
              Gap(10.h),
              Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 70.w,
                    height: 24.h,
                    decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(999.r)),
                  ),
                ],
              ),
              Gap(10.h),
              const DigifyDivider.thin(),
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsetsDirectional.only(start: 8.w),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(10.r)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
