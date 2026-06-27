import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/compensation/presentation/models/employee_compensation_table_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:skeletonizer/skeletonizer.dart';
import 'employee_compensation_table_config.dart';
import 'employee_compensation_table_footer.dart';
import 'employee_compensation_table_header.dart';
import 'employee_compensation_table_row.dart';
import 'employee_compensation_table_types.dart';

class EmployeeCompensationTable extends ConsumerWidget {
  final List<EmployeeCompensationTableRowData> rows;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final bool isLoading;

  const EmployeeCompensationTable({
    super.key,
    required this.rows,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    this.onPreviousPage,
    this.onNextPage,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final tableMinHeight = 500.h;
    final footerReservedHeight = 72.h;
    final contentMinHeight = (tableMinHeight - footerReservedHeight).clamp(0.0, double.infinity);
    final tableState = ref.watch(employeeCompensationTableWidthsProvider);
    final totalWidth =
        EmployeeCompensationTableConfig.actionsWidth.w +
        tableState.columnOrder.fold<double>(0, (sum, column) => sum + tableState.widthFor(column));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: tableMinHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollableSingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: Container(
                      constraints: BoxConstraints(minHeight: contentMinHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EmployeeCompensationTableHeader(isDark: isDark),
                          if (rows.isEmpty && !isLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 56.h),
                              child: Center(
                                child: Text(
                                  'No employees found',
                                  style: context.textTheme.titleMedium?.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            Skeletonizer(
                              enabled: isLoading,
                              child: Column(
                                children: [
                                  for (final row in rows) EmployeeCompensationTableRow(row: row, isDark: isDark),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                EmployeeCompensationTableFooter(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  totalItems: totalItems,
                  pageSize: pageSize,
                  onPreviousPage: onPreviousPage,
                  onNextPage: onNextPage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static double defaultWidthFor(EmployeeCompensationTableColumn column) =>
      EmployeeCompensationTableConfig.widthFor(column);
}
