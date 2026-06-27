import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedules_list.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedules_list_skeleton.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/create_work_schedule_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/update_work_schedule_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/view_work_schedule_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkSchedulesContentWidget extends ConsumerWidget {
  const WorkSchedulesContentWidget({super.key, required this.enterpriseId, required this.onDelete});

  final int enterpriseId;
  final ValueChanged<WorkSchedule> onDelete;

  WorkScheduleItem _convertToItem(WorkSchedule schedule) {
    return WorkScheduleItem(
      title: schedule.scheduleNameEn,
      titleArabic: schedule.scheduleNameAr,
      year: schedule.year,
      code: schedule.scheduleCode,
      isActive: schedule.isActive,
      workPatternName: schedule.patternNameEn ?? '',
      assignmentMode: schedule.assignmentMode,
      effectiveStartDate: schedule.formattedStartDate,
      effectiveEndDate: schedule.formattedEndDate,
      weeklySchedule: schedule.weeklySchedule,
      workScheduleId: schedule.workScheduleId,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workSchedulesState = ref.watch(workSchedulesNotifierProvider(enterpriseId));
    final notifier = ref.read(workSchedulesNotifierProvider(enterpriseId).notifier);

    return _buildContent(context, workSchedulesState, notifier);
  }

  Widget _buildContent(BuildContext context, WorkScheduleState workSchedulesState, WorkSchedulesNotifier notifier) {
    if (workSchedulesState.isLoading) {
      return const WorkSchedulesListSkeleton(itemCount: 3);
    }

    if (workSchedulesState.hasError && workSchedulesState.items.isEmpty) {
      return DigifyErrorState(
        message: workSchedulesState.errorMessage ?? 'Failed to load work schedules',
        onRetry: () => notifier.refresh(),
      );
    }

    if (workSchedulesState.items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_today_outlined,
        title: 'No Work Schedules Found',
        message: 'There are no work schedules available for this enterprise. Create a new schedule to get started.',
        actionLabel: 'Create Work Schedule',
        onAction: () => CreateWorkScheduleDialog.show(context, enterpriseId),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkSchedulesList(
          schedules: workSchedulesState.items.map(_convertToItem).toList(),
          deletingScheduleIds: workSchedulesState.deletingScheduleIds,
          onViewDetails: (item) {
            final schedule = workSchedulesState.items.firstWhere((s) => s.scheduleCode == item.code);
            ViewWorkScheduleDialog.show(context, schedule: schedule);
          },
          onEdit: (item) {
            final schedule = workSchedulesState.items.firstWhere((s) => s.scheduleCode == item.code);
            UpdateWorkScheduleDialog.show(context, enterpriseId, schedule);
          },
          onDelete: (item) {
            final schedule = workSchedulesState.items.firstWhere((s) => s.workScheduleId == item.workScheduleId);
            onDelete(schedule);
          },
          paginationInfo: workSchedulesState.totalPages > 0
              ? PaginationInfo(
                  currentPage: workSchedulesState.currentPage,
                  totalPages: workSchedulesState.totalPages,
                  totalItems: workSchedulesState.totalItems,
                  pageSize: workSchedulesState.pageSize,
                  hasNext: workSchedulesState.hasNextPage,
                  hasPrevious: workSchedulesState.hasPreviousPage,
                )
              : null,
          currentPage: workSchedulesState.currentPage,
          pageSize: workSchedulesState.pageSize,
          onPrevious: workSchedulesState.hasPreviousPage
              ? () => notifier.goToPage(workSchedulesState.currentPage - 1)
              : null,
          onNext: workSchedulesState.hasNextPage ? () => notifier.goToPage(workSchedulesState.currentPage + 1) : null,
          paginationIsLoading: workSchedulesState.isLoading || workSchedulesState.isLoadingMore,
        ),
      ],
    );
  }
}
