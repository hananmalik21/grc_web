import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_controller_provider.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_table_width_provider.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_table_provider.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_tab_config.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_config.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_header.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_table_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CandidatesListDesktop extends ConsumerWidget {
  const CandidatesListDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

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
    final tableState = ref.watch(candidatesTableWidthsProvider);
    final baseWidth =
        (CandidatesTableConfig.showActions ? CandidatesTableConfig.actionsWidth.w : 0) +
        tableState.columnOrder.fold<double>(0, (sum, column) => sum + tableState.widthFor(column));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final widthMultiplier = availableWidth > baseWidth ? availableWidth / baseWidth : 1.0;
              final totalWidth = baseWidth * widthMultiplier;

              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: 500.h),
                child: ScrollableSingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: errorMessage != null && liveRows.isEmpty
                        ? _buildErrorState(context, errorMessage, ref, totalWidth)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CandidatesTableHeader(isDark: isDark),
                              Skeletonizer(
                                enabled: isLoading,
                                child: Column(
                                  children: [
                                    for (final candidate in rows)
                                      CandidatesTableRow(candidate: candidate, isDark: isDark),
                                  ],
                                ),
                              ),
                              if (!isLoading && rows.isEmpty)
                                TableEmptyState(
                                  width: totalWidth,
                                  iconPath: Assets.icons.employeeListIcon.path,
                                  title: loc.hiringCandidatesTableEmptyTitle,
                                  message: loc.hiringCandidatesTableEmptyMessage,
                                ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
          if (errorMessage == null || liveRows.isNotEmpty)
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
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage, WidgetRef ref, double width) {
    return SizedBox(
      width: width,
      child: Padding(
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
      ),
    );
  }
}
