import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_detail_table_config.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_tasks_provider.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_table_width_provider.dart';
import 'package:grc/features/payroll/application/person_result_detail/providers/person_result_detail_ui_provider.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/payroll_process_results_table_header.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/payroll_process_results_table_row.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/payroll_process_results_section_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PayrollProcessResultsDataTable extends ConsumerWidget {
  const PayrollProcessResultsDataTable({required this.employee, super.key});

  final PersonResultEmployee employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final personNumber = employee.personNumber;
    final tasks = ref.watch(personResultDetailPaginatedTasksProvider(personNumber));
    final totalItems = ref.watch(personResultDetailTotalItemsProvider(personNumber));
    final currentPage = ref.watch(personResultDetailUiProvider.select((state) => state.currentPage));
    final totalPages = ref.watch(personResultDetailTotalPagesProvider(personNumber));
    final hasNext = ref.watch(personResultDetailHasNextProvider(personNumber));
    final hasPrevious = ref.watch(personResultDetailHasPreviousProvider(personNumber));
    final uiNotifier = ref.read(personResultDetailUiProvider.notifier);
    final tableState = ref.watch(personResultDetailTableWidthsProvider);
    final baseWidth =
        tableState.columnOrder.fold<double>(0, (sum, column) => sum + tableState.widthFor(column)) +
        (PersonResultDetailTableConfig.showActions ? PersonResultDetailTableConfig.actionsWidth.w : 0);

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
          PayrollProcessResultsSectionHeader(personNumber: personNumber),
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
                        PayrollProcessResultsTableHeader(isDark: isDark),
                        if (tasks.isEmpty)
                          TableEmptyState(
                            width: totalWidth,
                            iconPath: Assets.icons.payrollIcon.path,
                            title: loc.payrollPersonResultsNoTasksFound,
                            message: loc.payrollPersonResultsNoTasksMessage,
                          )
                        else
                          Column(
                            children: [
                              for (final task in tasks)
                                PayrollProcessResultsTableRow(employee: employee, task: task, isDark: isDark),
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
            pageSize: PersonResultDetailTableConfig.pageSize,
            hasNext: hasNext,
            hasPrevious: hasPrevious,
            isLoading: false,
            onPrevious: hasPrevious ? () => uiNotifier.setCurrentPage(currentPage - 1) : null,
            onNext: hasNext ? () => uiNotifier.setCurrentPage(currentPage + 1) : null,
            showBorder: true,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }
}
