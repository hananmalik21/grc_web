import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_config.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_table_width_provider.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_ui_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_table_header.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/element_entries_table_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElementEntriesDataTable extends ConsumerWidget {
  const ElementEntriesDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final uiState = ref.watch(elementEntriesUiProvider);
    final entries = uiState.entries;
    final tableState = ref.watch(elementEntriesTableWidthsProvider);

    final baseWidth =
        ElementEntriesTableConfig.selectWidth.w +
        (ElementEntriesTableConfig.showActions ? ElementEntriesTableConfig.actionsWidth.w : 0) +
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElementEntriesTableHeader(isDark: isDark),
                        Column(
                          children: [
                            for (var i = 0; i < entries.length; i++)
                              ElementEntriesTableRow(
                                row: entries[i],
                                index: i,
                                isDark: isDark,
                                isSelected: uiState.selectedIndices.contains(i),
                              ),
                          ],
                        ),
                        if (entries.isEmpty)
                          TableEmptyState(
                            width: totalWidth,
                            iconPath: Assets.icons.payrollIcon.path,
                            title: 'No Element Entries Found',
                            message: 'There are no element entries for the selected employee.',
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          PaginationControls(
            currentPage: 1,
            totalPages: 1,
            totalItems: entries.length,
            pageSize: ElementEntriesTableConfig.pageSize,
            hasNext: false,
            hasPrevious: false,
            isLoading: false,
            showBorder: true,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }
}
