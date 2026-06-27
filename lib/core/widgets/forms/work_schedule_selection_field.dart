import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkScheduleSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;
  final int enterpriseId;
  final WorkSchedule? selectedWorkSchedule;
  final ValueChanged<WorkSchedule?> onChanged;

  const WorkScheduleSelectionField({
    super.key,
    required this.label,
    this.isRequired = true,
    required this.enterpriseId,
    this.selectedWorkSchedule,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesState = ref.watch(workSchedulesNotifierProvider(enterpriseId));
    final notifier = ref.read(workSchedulesNotifierProvider(enterpriseId).notifier);

    return DigifySelectionFieldWithLabel(
      label: label,
      hint: 'Select Work Schedule',
      value: selectedWorkSchedule?.scheduleNameEn,
      isRequired: isRequired,
      onTap: () async {
        notifier.setEnterpriseId(enterpriseId);
        if (schedulesState.items.isEmpty && !schedulesState.isLoading) {
          await notifier.loadFirstPage();
        }

        if (!context.mounted) return;
        final latestState = ref.read(workSchedulesNotifierProvider(enterpriseId));

        final selected = await DigifySingleSelectDialog.show<WorkSchedule>(
          context: context,
          title: 'Select Work Schedule',
          subtitle: 'Choose a work schedule from the list',
          items: latestState.items,
          selectedId: selectedWorkSchedule?.workScheduleId.toString(),
          idBuilder: (schedule) => schedule.workScheduleId.toString(),
          labelBuilder: (schedule) => schedule.scheduleNameEn,
          descriptionBuilder: (schedule) => schedule.scheduleCode,
          searchHint: 'Search work schedules...',
          emptyMessage: 'No Work Schedules found',
          isLoading: latestState.isLoading,
          errorMessage: latestState.errorMessage,
          onRetry: notifier.refresh,
          pagination: DigifySingleSelectPagination(
            currentPage: latestState.currentPage,
            totalPages: latestState.totalPages,
            totalItems: latestState.totalItems,
            pageSize: latestState.pageSize,
            hasNext: latestState.hasNextPage,
            hasPrevious: latestState.hasPreviousPage,
          ),
          onPreviousPage: latestState.hasPreviousPage ? () => notifier.goToPage(latestState.currentPage - 1) : null,
          onNextPage: latestState.hasNextPage ? () => notifier.goToPage(latestState.currentPage + 1) : null,
        );

        if (selected != null) {
          onChanged(selected);
        }
      },
    );
  }
}
