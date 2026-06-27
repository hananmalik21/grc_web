import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/work_pattern_mobile_list.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/work_patterns_table.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/create_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/delete_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/edit_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/work_pattern_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternsContentWidget extends ConsumerWidget {
  const WorkPatternsContentWidget({required this.enterpriseId, super.key});

  final int enterpriseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workPatternsNotifierProvider(enterpriseId));
    final notifier = ref.read(workPatternsNotifierProvider(enterpriseId).notifier);
    final isMobile = context.screenLayout.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildContent(context, state, notifier, isMobile)],
    );
  }

  Widget _buildContent(BuildContext context, WorkPatternState state, WorkPatternsNotifier notifier, bool isMobile) {
    if (state.isLoading) {
      if (isMobile) return const WorkPatternMobileListSkeleton();
      return WorkPatternsTable(workPatterns: const [], isLoading: true, onRetry: () => notifier.refresh());
    }

    if (state.hasError && state.items.isEmpty) {
      return DigifyErrorState(
        message: state.errorMessage ?? 'Failed to load work patterns',
        onRetry: () => notifier.refresh(),
      );
    }

    if (state.items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_view_week_outlined,
        title: 'No Work Patterns Found',
        message: 'There are no work patterns available for this enterprise. Create one to get started.',
        actionLabel: 'Create Work Pattern',
        onAction: () => CreateWorkPatternDialog.show(context, enterpriseId),
      );
    }

    if (isMobile) {
      return WorkPatternMobileList(
        patterns: state.items,
        enterpriseId: enterpriseId,
        currentPage: state.currentPage,
        pageSize: state.pageSize,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        hasNextPage: state.hasNextPage,
        hasPreviousPage: state.hasPreviousPage,
        onNext: state.hasNextPage ? () => notifier.goToPage(state.currentPage + 1) : null,
        onPrevious: state.hasPreviousPage ? () => notifier.goToPage(state.currentPage - 1) : null,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkPatternsTable(
          workPatterns: state.items,
          isLoading: state.isLoading,
          isLoadingMore: state.isLoadingMore,
          hasError: state.hasError,
          errorMessage: state.errorMessage,
          onRetry: () => notifier.refresh(),
          onEdit: (pattern) => EditWorkPatternDialog.show(context, enterpriseId, pattern),
          onDelete: (pattern) => DeleteWorkPatternDialog.show(context, pattern, enterpriseId),
          onView: (pattern) => WorkPatternDetailsDialog.show(context, pattern, enterpriseId: enterpriseId),
          paginationInfo: PaginationInfo(
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            totalItems: state.totalItems,
            pageSize: state.pageSize,
            hasNext: state.hasNextPage,
            hasPrevious: state.hasPreviousPage,
          ),
          currentPage: state.currentPage,
          pageSize: state.pageSize,
          onPrevious: state.hasPreviousPage ? () => notifier.goToPage(state.currentPage - 1) : null,
          onNext: state.hasNextPage ? () => notifier.goToPage(state.currentPage + 1) : null,
        ),
        Gap(24.h),
      ],
    );
  }
}
