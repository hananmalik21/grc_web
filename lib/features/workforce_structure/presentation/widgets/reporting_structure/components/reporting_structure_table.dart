import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_table_header.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_table_row.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportingStructureTable extends ConsumerWidget {
  final bool isDark;
  final AppLocalizations localizations;
  final Function(ReportingPosition)? onView;
  final Function(ReportingPosition)? onEdit;

  const ReportingStructureTable({
    super.key,
    required this.isDark,
    required this.localizations,
    this.onView,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportingStructureNotifierProvider);
    final positions = state.items;
    final isLoading = state.isLoading;

    if (state.errorMessage != null && positions.isEmpty && !isLoading) {
      return DigifyErrorState(
        message: state.errorMessage!,
        onRetry: () => ref.read(reportingStructureNotifierProvider.notifier).refresh(),
      );
    }

    final pagination = (state.totalPages > 0 || positions.isNotEmpty)
        ? PaginationInfo(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            totalItems: state.totalItems,
            pageSize: state.pageSize,
            hasNext: state.hasNextPage,
            hasPrevious: state.hasPreviousPage,
          )
        : null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReportingTableHeader(isDark: isDark, localizations: localizations),
                    if (isLoading && positions.isEmpty)
                      ReportingTableSkeleton(localizations: localizations)
                    else if (positions.isEmpty && !isLoading)
                      _buildEmptyState(context)
                    else
                      ...positions.asMap().entries.map(
                        (entry) => ReportingTableRow(
                          position: entry.value,
                          isDark: isDark,
                          localizations: localizations,
                          onView: onView,
                          onEdit: onEdit,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (pagination != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: pagination,
              currentPage: state.currentPage,
              pageSize: state.pageSize,
              onPrevious: state.hasPreviousPage
                  ? () => ref.read(reportingStructureNotifierProvider.notifier).goToPage(state.currentPage - 1)
                  : null,
              onNext: state.hasNextPage
                  ? () => ref.read(reportingStructureNotifierProvider.notifier).goToPage(state.currentPage + 1)
                  : null,
              isLoading: false,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      width: 900.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_tree_outlined, size: 48.sp, color: AppColors.textSecondary),
              Gap(16.h),
              Text(
                localizations.noResultsFound,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Gap(8.h),
              Text(
                localizations.tryAdjustingFilters,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
