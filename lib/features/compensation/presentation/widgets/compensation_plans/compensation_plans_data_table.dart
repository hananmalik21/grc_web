import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../providers/compensation_plans/compensation_plans_table_rows_provider.dart';
import '../../providers/compensation_plans/compensation_plans_table_width_provider.dart';
import 'compensation_plans_table_config.dart';
import 'compensation_plans_table_header.dart';
import 'compensation_plans_table_row.dart';

class CompensationPlansDataTable extends ConsumerWidget {
  const CompensationPlansDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final tableState = ref.watch(compensationPlansTableWidthsProvider);
    final liveRows = ref.watch(compensationPlansPagedRowsProvider);
    final isLoading = ref.watch(compensationPlansTableIsLoadingProvider);
    final errorMessage = ref.watch(compensationPlansTableErrorProvider);
    final skeletonRows = ref.watch(compensationPlansSkeletonRowsProvider);
    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;
    final currentPage = ref.watch(compensationPlansCurrentPageProvider);
    final totalPages = ref.watch(compensationPlansTotalPagesProvider);
    final totalItems = ref.watch(compensationPlansTotalItemsProvider);
    final hasNext = ref.watch(compensationPlansHasNextProvider);
    final hasPrevious = ref.watch(compensationPlansHasPreviousProvider);

    final baseWidth =
        (CompensationPlansTableConfig.showActions ? CompensationPlansTableConfig.actionsWidth : 0) +
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
                constraints: BoxConstraints(minHeight: 540.h),
                child: ScrollableSingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: errorMessage != null && liveRows.isEmpty
                        ? _buildErrorState(context, errorMessage, ref, totalWidth)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CompensationPlansTableHeader(isDark: isDark, widthMultiplier: widthMultiplier),
                              Skeletonizer(
                                enabled: isLoading,
                                child: Column(
                                  children: [
                                    for (final row in rows)
                                      CompensationPlansTableRow(
                                        row: row,
                                        isDark: isDark,
                                        widthMultiplier: widthMultiplier,
                                      ),
                                  ],
                                ),
                              ),
                              if (!isLoading && rows.isEmpty)
                                TableEmptyState(
                                  width: totalWidth,
                                  iconPath: Assets.icons.compensation.fileList.path,
                                  title: 'No Plans Found',
                                  message: 'There are no compensation plans matching your search or filters.',
                                ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
          PaginationControls(
            currentPage: currentPage,
            totalPages: totalPages,
            totalItems: totalItems,
            pageSize: CompensationPlansTableConfig.pageSize,
            hasNext: hasNext,
            hasPrevious: hasPrevious,
            isLoading: false,
            onPrevious: hasPrevious && !isLoading
                ? () => ref.read(compensationPlansCurrentPageProvider.notifier).state = currentPage - 1
                : null,
            onNext: hasNext && !isLoading
                ? () => ref.read(compensationPlansCurrentPageProvider.notifier).state = currentPage + 1
                : null,
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
              'Failed to load compensation plans',
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
              label: 'Retry',
              onPressed: () {
                ref.invalidate(compensationPlansPageProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}
