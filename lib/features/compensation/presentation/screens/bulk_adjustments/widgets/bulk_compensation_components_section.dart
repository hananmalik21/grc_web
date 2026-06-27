import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_sync.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_new_components_section.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_employee_components_provider.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_common_components_skeleton.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_component_adjustment_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BulkCompensationComponentsSection extends ConsumerWidget {
  const BulkCompensationComponentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final componentsAsync = ref.watch(bulkEmployeeComponentsProvider);

    ref.listen(bulkEmployeeComponentsProvider, (previous, next) {
      next.whenData((page) => syncBulkAdjustmentsFormFromComponentsPage(ref, page));
    });

    return _SectionCard(
      isDark: isDark,
      icon: Assets.icons.departmentMetric3Icon.path,
      title: localizations.bulkAdjustmentsComponentsSectionTitle,
      subtitle: localizations.bulkAdjustmentsCommonComponentsTitle,
      child: componentsAsync.when(
        loading: () => BulkCommonComponentsSkeleton(isDark: isDark),
        error: (error, _) => _ComponentsError(
          message: localizations.bulkAdjustmentsComponentsFetchError,
          details: error.toString(),
          onRetry: () => ref.invalidate(bulkEmployeeComponentsProvider),
        ),
        data: (page) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            syncBulkAdjustmentsFormFromComponentsPage(ref, page);
          });
          return _ComponentsContent(
            page: page,
            isDark: isDark,
            localizations: localizations,
            onPreviousPage: page.pagination.hasPrevious
                ? () => ref.read(bulkEmployeeComponentsPageIndexProvider.notifier).state--
                : null,
            onNextPage: page.pagination.hasNext
                ? () => ref.read(bulkEmployeeComponentsPageIndexProvider.notifier).state++
                : null,
          );
        },
      ),
    );
  }
}

class _ComponentsContent extends ConsumerWidget {
  const _ComponentsContent({
    required this.page,
    required this.isDark,
    required this.localizations,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  final BulkEmployeeComponentsPage page;
  final bool isDark;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGroups = ref.watch(bulkAdjustmentsFormProvider.select((state) => state.existingActiveGroups));
    final selectedCount = ref.watch(bulkEmployeeComponentsQueryProvider)?.employeeGuids.length ?? 0;
    final hasApiEmployees = page.employees.isNotEmpty;

    if (hasApiEmployees && activeGroups.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        syncBulkAdjustmentsFormFromComponentsPage(ref, page);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasApiEmployees && activeGroups.isEmpty)
          BulkCommonComponentsSkeleton(isDark: isDark)
        else if (activeGroups.isEmpty)
          TableEmptyState(
            title: localizations.bulkAdjustmentsNoCommonComponentsTitle,
            message: localizations.bulkAdjustmentsNoCommonComponentsMessage,
            iconPath: Assets.icons.compensation.components.path,
            height: 220.h,
          )
        else
          Column(
            children: activeGroups
                .map(
                  (group) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: BulkComponentAdjustmentCard(group: group, isDark: isDark),
                  ),
                )
                .toList(),
          ),
        if (selectedCount > 1) ...[
          Gap(8.h),
          Text(
            localizations.bulkAdjustmentsComponentsSelectedEmployees(selectedCount),
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
        ],
        if (page.pagination.totalPages > 1 || page.pagination.total > page.pagination.pageSize) ...[
          Gap(16.h),
          PaginationControls(
            currentPage: page.pagination.page,
            totalPages: page.pagination.totalPages,
            totalItems: page.pagination.total,
            pageSize: page.pagination.pageSize,
            hasNext: page.pagination.hasNext,
            hasPrevious: page.pagination.hasPrevious,
            onPrevious: onPreviousPage,
            onNext: onNextPage,
            isLoading: false,
          ),
        ],
        const BulkNewComponentsSection(),
      ],
    );
  }
}

class _ComponentsError extends StatelessWidget {
  const _ComponentsError({required this.message, required this.details, required this.onRetry});

  final String message;
  final String details;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          Gap(8.h),
          Text(
            details,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textTertiary),
          ),
          Gap(16.h),
          ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.child,
    required this.subtitle,
  });

  final bool isDark;
  final String icon;
  final String title;
  final Widget child;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyAsset(assetPath: icon, width: 20.w, height: 20.w, color: AppColors.primary),
              Gap(8.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 18.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          Text(
            subtitle,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(16.h),
          child,
        ],
      ),
    );
  }
}
