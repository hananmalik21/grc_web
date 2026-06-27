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

import '../../providers/components_table_rows_provider.dart';
import '../../providers/components_table_width_provider.dart';
import 'components_table_config.dart';
import 'components_table_header.dart';
import 'components_table_row.dart';

class ComponentsDataTable extends ConsumerWidget {
  const ComponentsDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final tableState = ref.watch(componentsTableWidthsProvider);
    final liveRowsAsync = ref.watch(componentsTableRowsProvider);
    final liveRows = liveRowsAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(componentsTableIsLoadingProvider);
    final errorMessage = ref.watch(componentsTableErrorProvider);
    final skeletonRows = ref.watch(componentsSkeletonRowsProvider);
    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;
    final currentPage = ref.watch(componentsCurrentPageProvider);
    final totalPages = ref.watch(componentsTotalPagesProvider);
    final totalItems = ref.watch(componentsTotalItemsProvider);
    final hasNext = ref.watch(componentsHasNextProvider);
    final hasPrevious = ref.watch(componentsHasPreviousProvider);

    final baseWidth =
        (ComponentsTableConfig.showActions ? ComponentsTableConfig.actionsWidth.w : 0) +
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
                              ComponentsTableHeader(isDark: isDark),
                              Skeletonizer(
                                enabled: isLoading,
                                child: Column(
                                  children: [for (final row in rows) ComponentsTableRow(row: row, isDark: isDark)],
                                ),
                              ),
                              if (!isLoading && rows.isEmpty)
                                TableEmptyState(
                                  width: totalWidth,
                                  iconPath: Assets.icons.compensation.components.path,
                                  title: 'No Components Found',
                                  message: 'There are no compensation components matching your search or filters.',
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
            pageSize: ComponentsTableConfig.pageSize,
            hasNext: hasNext,
            hasPrevious: hasPrevious,
            isLoading: false,
            onPrevious: hasPrevious && !isLoading
                ? () => ref.read(componentsCurrentPageProvider.notifier).state = currentPage - 1
                : null,
            onNext: hasNext && !isLoading
                ? () => ref.read(componentsCurrentPageProvider.notifier).state = currentPage + 1
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
            Text('Failed to load components', style: context.textTheme.titleMedium?.copyWith(color: AppColors.error)),
            Gap(8.h),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            Gap(16.h),
            AppButton.outline(label: 'Retry', onPressed: () => ref.invalidate(componentsPageProvider)),
          ],
        ),
      ),
    );
  }
}
