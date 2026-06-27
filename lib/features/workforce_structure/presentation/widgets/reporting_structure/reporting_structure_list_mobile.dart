import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportingStructureListMobile extends ConsumerWidget {
  const ReportingStructureListMobile({
    super.key,
    required this.localizations,
    required this.isDark,
    this.onView,
    this.onEdit,
  });

  final AppLocalizations localizations;
  final bool isDark;
  final void Function(ReportingPosition)? onView;
  final void Function(ReportingPosition)? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportingStructureNotifierProvider);
    final hasPaginationData = state.totalPages > 0 || state.items.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.isLoading)
            _ReportingStructureMobileSkeleton(localizations: localizations, isDark: isDark)
          else if (state.errorMessage != null && state.items.isEmpty && !state.isLoading)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: DigifyErrorState(
                message: state.errorMessage!,
                onRetry: () => ref.read(reportingStructureNotifierProvider.notifier).refresh(),
              ),
            )
          else if (state.items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
              child: _ReportingStructureMobileEmpty(localizations: localizations, isDark: isDark),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (_, index) => _ReportingPositionMobileCard(
                position: state.items[index],
                localizations: localizations,
                isDark: isDark,
                onView: onView,
                onEdit: onEdit,
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
                  ? () => ref.read(reportingStructureNotifierProvider.notifier).goToPage(state.currentPage - 1)
                  : null,
              onNext: state.hasNextPage && !state.isLoading
                  ? () => ref.read(reportingStructureNotifierProvider.notifier).goToPage(state.currentPage + 1)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportingStructureMobileEmpty extends StatelessWidget {
  const _ReportingStructureMobileEmpty({required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.account_tree_outlined, size: 48.sp, color: secondaryColor),
        Gap(12.h),
        Text(
          localizations.noResultsFound,
          textAlign: TextAlign.center,
          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(8.h),
        Text(
          localizations.tryAdjustingFilters,
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall?.copyWith(color: secondaryColor),
        ),
      ],
    );
  }
}

class _ReportingPositionMobileCard extends StatelessWidget {
  const _ReportingPositionMobileCard({
    required this.position,
    required this.localizations,
    required this.isDark,
    this.onView,
    this.onEdit,
  });

  final ReportingPosition position;
  final AppLocalizations localizations;
  final bool isDark;
  final void Function(ReportingPosition)? onView;
  final void Function(ReportingPosition)? onEdit;

  @override
  Widget build(BuildContext context) {
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final isTopLevel = position.reportsToTitle == null || position.reportsToTitle!.trim().isEmpty;

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
                      position.titleEnglish,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(4.h),
                    Text(
                      position.positionCode.toUpperCase(),
                      style: context.textTheme.bodySmall?.copyWith(color: secondaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: position.status),
            ],
          ),
          Gap(10.h),
          _MobileMetaRow(
            label: localizations.department,
            value: position.department.toUpperCase(),
            labelColor: secondaryColor,
            valueColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          Gap(6.h),
          _MobileMetaRow(
            label: localizations.jobLevel,
            value: position.level,
            labelColor: secondaryColor,
            valueColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          Gap(6.h),
          _MobileMetaRow(
            label: localizations.gradeStep,
            value: position.gradeStep,
            labelColor: secondaryColor,
            valueColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          Gap(6.h),
          _MobileMetaRow(
            label: localizations.reportsTo,
            value: isTopLevel ? localizations.topLevel : position.reportsToTitle!,
            labelColor: secondaryColor,
            valueColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          if (position.directReportsCount > 0) ...[
            Gap(6.h),
            Text(
              '${position.directReportsCount} ${localizations.directReports}',
              style: context.textTheme.bodySmall?.copyWith(color: secondaryColor),
            ),
          ],
          Gap(10.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppMobileButton.primary(svgPath: Assets.icons.blueEyeIcon.path, onPressed: () => onView?.call(position)),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.editIconGreen.path,
                backgroundColor: AppColors.editIconGreen,
                type: AppButtonType.secondary,
                onPressed: () => onEdit?.call(position),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileMetaRow extends StatelessWidget {
  const _MobileMetaRow({required this.label, required this.value, required this.labelColor, required this.valueColor});

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 104.w,
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(color: labelColor, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(color: valueColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ReportingStructureMobileSkeleton extends StatelessWidget {
  const _ReportingStructureMobileSkeleton({required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

  static final List<ReportingPosition> _dummyPositions = [
    const ReportingPosition(
      positionId: '1',
      positionCode: 'CEO-01',
      titleEnglish: 'Chief Executive Officer',
      titleArabic: 'Chief Executive Officer',
      department: 'Executive',
      level: 'Level 1',
      gradeStep: 'Grade 1 / Step 5',
      reportsToTitle: null,
      reportsToCode: null,
      directReportsCount: 6,
      status: 'ACTIVE',
    ),
    const ReportingPosition(
      positionId: '2',
      positionCode: 'ENG-02',
      titleEnglish: 'Engineering Director',
      titleArabic: 'Engineering Director',
      department: 'Technology',
      level: 'Level 2',
      gradeStep: 'Grade 2 / Step 4',
      reportsToTitle: 'Chief Executive Officer',
      reportsToCode: 'CEO-01',
      directReportsCount: 4,
      status: 'ACTIVE',
    ),
    const ReportingPosition(
      positionId: '3',
      positionCode: 'HR-03',
      titleEnglish: 'HR Business Partner',
      titleArabic: 'HR Business Partner',
      department: 'People',
      level: 'Level 3',
      gradeStep: 'Grade 3 / Step 2',
      reportsToTitle: 'Engineering Director',
      reportsToCode: 'ENG-02',
      directReportsCount: 2,
      status: 'ACTIVE',
    ),
    const ReportingPosition(
      positionId: '4',
      positionCode: 'OPS-04',
      titleEnglish: 'Operations Specialist',
      titleArabic: 'Operations Specialist',
      department: 'Operations',
      level: 'Level 4',
      gradeStep: 'Grade 4 / Step 1',
      reportsToTitle: 'HR Business Partner',
      reportsToCode: 'HR-03',
      directReportsCount: 0,
      status: 'ACTIVE',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: _dummyPositions.length,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, index) => _ReportingPositionMobileCard(
          position: _dummyPositions[index],
          localizations: localizations,
          isDark: isDark,
          onView: (_) {},
          onEdit: (_) {},
        ),
      ),
    );
  }
}
