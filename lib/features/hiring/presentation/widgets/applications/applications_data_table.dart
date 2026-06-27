import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/hiring/application/applications/controllers/applications_controller.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_controller_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:grc/features/hiring/application/applications/providers/applications_table_width_provider.dart';
import 'applications_table_config.dart';
import 'applications_table_header.dart';
import 'applications_table_row.dart';

class ApplicationsDataTable extends ConsumerWidget {
  const ApplicationsDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(applicationsControllerProvider);
    final controller = ref.read(applicationsControllerProvider.notifier);
    final rows = state.displayRows;
    final tableState = ref.watch(applicationsTableWidthsProvider);

    final baseWidth =
        (ApplicationsTableConfig.showActions ? ApplicationsTableConfig.actionsWidth.w : 0) +
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
                constraints: BoxConstraints(minHeight: 400.h),
                child: ScrollableSingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: totalWidth,
                    child: state.error != null && state.items.isEmpty
                        ? _buildErrorState(context, state.error!, controller, totalWidth)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ApplicationsTableHeader(isDark: isDark),
                              Skeletonizer(
                                enabled: state.isLoading,
                                child: Column(
                                  children: [for (final row in rows) ApplicationsTableRow(row: row, isDark: isDark)],
                                ),
                              ),
                              if (!state.isLoading && rows.isEmpty)
                                TableEmptyState(
                                  width: totalWidth,
                                  iconPath: Assets.icons.hiring.assignments.path,
                                  title: 'No Applications Found',
                                  message: 'There are no applications matching your search or filters.',
                                ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
          PaginationControls(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            totalItems: state.totalItems,
            pageSize: ApplicationsTableConfig.pageSize,
            hasNext: state.hasNext,
            hasPrevious: state.hasPrevious,
            isLoading: false,
            onPrevious: state.hasPrevious && !state.isLoading ? controller.previousPage : null,
            onNext: state.hasNext && !state.isLoading ? controller.nextPage : null,
            showBorder: true,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage, ApplicationsNotifier controller, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Failed to load applications', style: context.textTheme.titleMedium?.copyWith(color: AppColors.error)),
            Gap(8.h),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            Gap(16.h),
            AppButton.outline(label: 'Retry', onPressed: controller.retryFetch),
          ],
        ),
      ),
    );
  }
}
