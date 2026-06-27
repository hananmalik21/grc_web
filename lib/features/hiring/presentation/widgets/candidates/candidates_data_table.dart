import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_controller_provider.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_table_provider.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_tab_config.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidate_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CandidatesDataTable extends ConsumerWidget {
  const CandidatesDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final layout = context.screenLayout;
    final isDark = context.isDark;
    final crossAxisCount = switch (layout) {
      ScreenLayout.mobile => 1,
      ScreenLayout.tabletSmall || ScreenLayout.tabletMedium => 2,
      ScreenLayout.tabletLarge || ScreenLayout.desktop => 3,
    };

    final liveRowsAsync = ref.watch(candidatesListProvider);
    final liveRows = liveRowsAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(candidatesTableIsLoadingProvider);
    final errorMessage = ref.watch(candidatesTableErrorProvider);
    final skeletonRows = ref.watch(candidatesSkeletonRowsProvider);

    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;

    final currentPage = ref.watch(candidatesCurrentPageProvider);
    final totalPages = ref.watch(candidatesTotalPagesProvider);
    final totalItems = ref.watch(candidatesTotalItemsProvider);
    final hasNext = ref.watch(candidatesHasNextProvider);
    final hasPrevious = ref.watch(candidatesHasPreviousProvider);
    final controller = ref.read(candidatesControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          if (errorMessage != null && liveRows.isEmpty)
            _buildErrorState(context, errorMessage, ref)
          else ...[
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24.w,
                        mainAxisSpacing: 24.h,
                        mainAxisExtent: 475.h,
                      ),
                      itemCount: rows.length,
                      itemBuilder: (context, index) {
                        return CandidateCard(candidate: rows[index]);
                      },
                    ),
                    if (!isLoading && rows.isEmpty)
                      TableEmptyState(
                        width: double.infinity,
                        iconPath: Assets.icons.employeeListIcon.path,
                        title: loc.hiringCandidatesTableEmptyTitle,
                        message: loc.hiringCandidatesTableEmptyMessage,
                      ),
                  ],
                ),
              ),
            ),
            PaginationControls(
              currentPage: currentPage,
              totalPages: totalPages,
              totalItems: totalItems,
              pageSize: CandidatesTabConfig.pageSize,
              hasNext: hasNext,
              hasPrevious: hasPrevious,
              isLoading: false,
              onPrevious: hasPrevious && !isLoading ? controller.previousPage : null,
              onNext: hasNext && !isLoading ? controller.nextPage : null,
              showBorder: true,
              style: PaginationStyle.simple,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.hiringCandidatesTableEmptyTitle,
            style: context.textTheme.titleMedium?.copyWith(color: AppColors.error),
          ),
          Gap(8.h),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          Gap(16.h),
          AppButton.outline(
            label: AppLocalizations.of(context)!.retry,
            onPressed: ref.read(candidatesControllerProvider).retryFetch,
          ),
        ],
      ),
    );
  }
}
