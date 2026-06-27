import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_table.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/create_schedule_assignment_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/edit_schedule_assignment_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/view_schedule_assignment_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/mappers/schedule_assignment_mapper.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_mobile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentsContentWidget extends ConsumerWidget {
  const ScheduleAssignmentsContentWidget({super.key, required this.enterpriseId, required this.onDelete});

  final int enterpriseId;
  final ValueChanged<ScheduleAssignment> onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scheduleAssignmentsNotifierProvider(enterpriseId));
    final notifier = ref.read(scheduleAssignmentsNotifierProvider(enterpriseId).notifier);
    final isMobile = context.screenLayout.isMobile;

    if (state.hasError && state.items.isEmpty) {
      return DigifyErrorState(
        message: state.errorMessage ?? 'Failed to load schedule assignments',
        onRetry: notifier.refresh,
      );
    }

    if (!state.isLoading && !state.hasError && state.items.isEmpty) {
      if (isMobile) {
        return _MobileEmptyState(
          isDark: context.isDark,
          onAssign: () => CreateScheduleAssignmentDialog.show(context, enterpriseId),
        );
      }
      return EmptyStateWidget(
        icon: Icons.calendar_today_outlined,
        title: 'No Schedule Assignments Found',
        message: 'There are no schedule assignments for this enterprise. Assign a schedule to get started.',
        actionLabel: 'Assign Schedule',
        onAction: () => CreateScheduleAssignmentDialog.show(context, enterpriseId),
      );
    }

    if (isMobile) {
      return ScheduleAssignmentsMobileContent(
        state: state,
        notifier: notifier,
        onDelete: onDelete,
        onView: (a) => ViewScheduleAssignmentDialog.show(context, a),
        onEdit: (a) {
          final resolvedId = ref.read(timeManagementEnterpriseIdProvider) ?? enterpriseId;
          EditScheduleAssignmentDialog.show(context, resolvedId, a);
        },
      );
    }

    return ScheduleAssignmentsTable(
      assignments: ScheduleAssignmentMapper.toTableRowDataList(state.items),
      deletingAssignmentId: state.deletingAssignmentId,
      isLoading: state.isLoading && state.items.isEmpty,
      isLoadingMore: state.isLoadingMore,
      paginationIsLoading: state.isLoading || state.isLoadingMore,
      paginationInfo: PaginationInfo(
        currentPage: state.currentPage,
        pageSize: state.pageSize,
        totalItems: state.totalItems,
        totalPages: state.totalPages,
        hasNext: state.hasNextPage,
        hasPrevious: state.hasPreviousPage,
      ),
      currentPage: state.currentPage,
      pageSize: state.pageSize,
      onNext: () => notifier.loadNextPage(),
      onPrevious: () => notifier.goToPage(state.currentPage - 1),
      hasError: state.hasError && state.items.isEmpty,
      errorMessage: state.errorMessage,
      onRetry: notifier.refresh,
      onView: (item) => _onView(context, item, state),
      onEdit: (item) => _onEdit(context, ref, item, state),
      onDelete: (item) => _onDeleteRow(item, state),
    );
  }

  void _onView(BuildContext context, ScheduleAssignmentTableRowData item, ScheduleAssignmentState state) {
    final assignment = state.items.firstWhere((a) => a.scheduleAssignmentId == item.scheduleAssignmentId);
    ViewScheduleAssignmentDialog.show(context, assignment);
  }

  void _onEdit(
    BuildContext context,
    WidgetRef ref,
    ScheduleAssignmentTableRowData item,
    ScheduleAssignmentState state,
  ) {
    final assignment = state.items.firstWhere((a) => a.scheduleAssignmentId == item.scheduleAssignmentId);
    final resolvedEnterpriseId = ref.read(timeManagementEnterpriseIdProvider) ?? enterpriseId;
    EditScheduleAssignmentDialog.show(context, resolvedEnterpriseId, assignment);
  }

  void _onDeleteRow(ScheduleAssignmentTableRowData item, ScheduleAssignmentState state) {
    final assignment = state.items.firstWhere((a) => a.scheduleAssignmentId == item.scheduleAssignmentId);
    onDelete(assignment);
  }
}

class _MobileEmptyState extends StatelessWidget {
  const _MobileEmptyState({required this.isDark, required this.onAssign});

  final bool isDark;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    return MobileStateCard(
      isDark: isDark,
      borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
      iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
      icon: Icon(
        Icons.calendar_today_outlined,
        size: 32.sp,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      title: 'No Schedule Assignments Found',
      subtitle: 'There are no schedule assignments for this enterprise. Assign a schedule to get started.',
      action: AppButton(label: 'Assign Schedule', onPressed: onAssign, height: 40),
    );
  }
}
