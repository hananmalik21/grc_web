import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_table_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_table_width_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_config.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_header.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RequisitionsDataTable extends ConsumerWidget {
  const RequisitionsDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final liveRowsAsync = ref.watch(requisitionsTableRowsProvider);
    final liveRows = liveRowsAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(requisitionsTableIsLoadingProvider);
    final errorMessage = ref.watch(requisitionsTableErrorProvider);
    final skeletonRows = ref.watch(requisitionsSkeletonRowsProvider);
    final rows = isLoading && liveRows.isEmpty ? skeletonRows : liveRows;
    final currentPage = ref.watch(requisitionsCurrentPageProvider);
    final totalPages = ref.watch(requisitionsTotalPagesProvider);
    final totalItems = ref.watch(requisitionsTotalItemsProvider);
    final hasNext = ref.watch(requisitionsHasNextProvider);
    final hasPrevious = ref.watch(requisitionsHasPreviousProvider);
    final tableState = ref.watch(requisitionsTableWidthsProvider);
    final baseWidth =
        (RequisitionsTableConfig.showActions ? RequisitionsTableConfig.actionsWidth.w : 0) +
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
                    child: errorMessage != null && liveRows.isEmpty
                        ? _buildErrorState(context, errorMessage, ref, totalWidth)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RequisitionsTableHeader(isDark: isDark),
                              Skeletonizer(
                                enabled: isLoading,
                                child: Column(
                                  children: [for (final row in rows) RequisitionsTableRow(row: row, isDark: isDark)],
                                ),
                              ),
                              if (!isLoading && rows.isEmpty)
                                TableEmptyState(
                                  width: totalWidth,
                                  iconPath: Assets.icons.hiring.assignments.path,
                                  title: loc.hiringRequisitionsTableEmptyTitle,
                                  message: loc.hiringRequisitionsTableEmptyMessage,
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
            pageSize: RequisitionsTableConfig.pageSize,
            hasNext: hasNext,
            hasPrevious: hasPrevious,
            isLoading: false,
            onPrevious: hasPrevious && !isLoading
                ? () => ref.read(requisitionsCurrentPageProvider.notifier).state = currentPage - 1
                : null,
            onNext: hasNext && !isLoading
                ? () => ref.read(requisitionsCurrentPageProvider.notifier).state = currentPage + 1
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
              AppLocalizations.of(context)!.hiringRequisitionsTableErrorTitle,
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
              onPressed: () => ref.invalidate(requisitionsPageProvider),
            ),
          ],
        ),
      ),
    );
  }
}
