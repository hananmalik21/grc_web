import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_table_width_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_header.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_layout_config.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdjustmentsTableCard extends ConsumerWidget {
  final List<AdjustmentRowData> rows;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final bool isLoading;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final bool enableRowSelection;

  const AdjustmentsTableCard({
    super.key,
    required this.rows,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    this.isLoading = false,
    this.onPreviousPage,
    this.onNextPage,
    this.enableRowSelection = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final tableState = ref.watch(adjustmentsTableWidthsProvider);

    final baseWidth =
        (AdjustmentsTableLayoutConfig.showActions ? AdjustmentsTableLayoutConfig.actionsWidth : 0) +
        tableState.columnOrder.fold<double>(0, (sum, column) => sum + tableState.widthFor(column));

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdjustmentsTableHeader(
                          isDark: isDark,
                          widthMultiplier: widthMultiplier,
                          enableRowSelection: enableRowSelection,
                          selectableRows: rows,
                        ),
                        if (!isLoading && rows.isEmpty)
                          TableEmptyState(
                            width: totalWidth,
                            iconPath: Assets.icons.compensation.adjustment.path,
                            title: 'No Adjustments Found',
                            message: 'There are no salary adjustments recorded for the selected criteria.',
                          )
                        else
                          Skeletonizer(
                            enabled: isLoading,
                            child: Column(
                              children: [
                                for (final row in rows)
                                  AdjustmentsTableRow(
                                    row: row,
                                    isDark: isDark,
                                    widthMultiplier: widthMultiplier,
                                    enableRowSelection: enableRowSelection,
                                  ),
                              ],
                            ),
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
            pageSize: pageSize,
            hasNext: currentPage < totalPages,
            hasPrevious: currentPage > 1,
            onPrevious: onPreviousPage,
            onNext: onNextPage,
            showBorder: true,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }
}
