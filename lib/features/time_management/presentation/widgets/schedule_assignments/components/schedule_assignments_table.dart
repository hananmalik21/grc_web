import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_header.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleAssignmentsTable extends ConsumerWidget {
  final List<ScheduleAssignmentTableRowData> assignments;
  final Function(ScheduleAssignmentTableRowData)? onView;
  final Function(ScheduleAssignmentTableRowData)? onEdit;
  final Function(ScheduleAssignmentTableRowData)? onDelete;
  final int? deletingAssignmentId;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool paginationIsLoading;

  const ScheduleAssignmentsTable({
    super.key,
    required this.assignments,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.deletingAssignmentId,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = 10,
    this.onPrevious,
    this.onNext,
    this.paginationIsLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScheduleAssignmentTableHeader(isDark: isDark, localizations: localizations),
                  Skeletonizer(enabled: isLoading, child: _buildRows(isDark, localizations)),
                ],
              ),
            ),
          ),
          if (paginationInfo != null) ...[
            PaginationControls.fromPaginationInfo(
              paginationInfo: paginationInfo!,
              currentPage: currentPage,
              pageSize: pageSize,
              onPrevious: onPrevious,
              onNext: onNext,
              style: PaginationStyle.simple,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRows(bool isDark, AppLocalizations localizations) {
    if (isLoading && assignments.isEmpty) {
      return const ScheduleAssignmentsTableSkeleton(itemCount: 5);
    }
    if (hasError && assignments.isEmpty) {
      return _buildErrorState(isDark);
    }
    if (assignments.isEmpty) {
      return _buildEmptyState(isDark, localizations);
    }
    return Column(
      children: [
        ...assignments.map(
          (assignment) => ScheduleAssignmentTableRow(
            data: assignment,
            onView: onView != null ? () => onView!(assignment) : null,
            onEdit: onEdit != null ? () => onEdit!(assignment) : null,
            onDelete: onDelete != null ? () => onDelete!(assignment) : null,
            isDeleting: deletingAssignmentId == assignment.scheduleAssignmentId,
          ),
        ),
        if (isLoadingMore) _buildLoadingMoreState(),
      ],
    );
  }

  Widget _buildErrorState(bool isDark) {
    return SizedBox(
      width: 900.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage ?? 'Something went wrong',
                style: TextStyle(fontSize: 16.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[Gap(16.h), ElevatedButton(onPressed: onRetry, child: const Text('Retry'))],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, AppLocalizations localizations) {
    return SizedBox(
      width: 900.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            localizations.noResultsFound,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreState() {
    return SizedBox(
      width: 900.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
