import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/payroll/application/person_results/config/person_results_table_config.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_list_provider.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_table_width_provider.dart';
import 'package:grc/features/payroll/application/person_results/providers/person_results_ui_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_table_header.dart';
import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_table_row.dart';
// import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_table_toolbar.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonResultsDataTable extends ConsumerWidget {
  const PersonResultsDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final employees = ref.watch(personResultsPaginatedEmployeesProvider);
    final totalItems = ref.watch(personResultsTotalItemsProvider);
    final currentPage = ref.watch(personResultsUiProvider.select((state) => state.currentPage));
    final totalPages = ref.watch(personResultsTotalPagesProvider);
    final hasNext = ref.watch(personResultsHasNextProvider);
    final hasPrevious = ref.watch(personResultsHasPreviousProvider);
    final uiNotifier = ref.read(personResultsUiProvider.notifier);
    final tableState = ref.watch(personResultsTableWidthsProvider);
    final baseWidth = tableState.columnOrder.fold<double>(0, (sum, column) => sum + tableState.widthFor(column));

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar disabled for now — re-enable when filter/sort in-table controls are needed.
          // const PersonResultsTableToolbar(),
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
                        PersonResultsTableHeader(isDark: isDark),
                        if (employees.isEmpty)
                          TableEmptyState(
                            width: totalWidth,
                            iconPath: Assets.icons.payrollIcon.path,
                            title: loc.payrollPersonResultsNoEmployeesFound,
                            message: loc.payrollPersonResultsNoEmployeesMessage,
                          )
                        else
                          Column(
                            children: [
                              for (final employee in employees)
                                PersonResultsTableRow(employee: employee, isDark: isDark),
                            ],
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
            pageSize: PersonResultsTableConfig.pageSize,
            hasNext: hasNext,
            hasPrevious: hasPrevious,
            isLoading: false,
            onPrevious: hasPrevious ? () => uiNotifier.setCurrentPage(currentPage - 1) : null,
            onNext: hasNext ? () => uiNotifier.setCurrentPage(currentPage + 1) : null,
            showBorder: true,
          ),
        ],
      ),
    );
  }
}
