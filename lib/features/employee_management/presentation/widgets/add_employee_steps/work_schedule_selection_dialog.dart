import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeWorkScheduleSelectionDialog extends ConsumerStatefulWidget {
  const EmployeeWorkScheduleSelectionDialog({super.key, required this.enterpriseId, this.selectedScheduleId});

  final int enterpriseId;
  final int? selectedScheduleId;

  static Future<WorkSchedule?> show({
    required BuildContext context,
    required int enterpriseId,
    int? selectedScheduleId,
  }) async {
    final widget = EmployeeWorkScheduleSelectionDialog(
      enterpriseId: enterpriseId,
      selectedScheduleId: selectedScheduleId,
    );

    if (context.isMobile) {
      final mq = MediaQuery.of(context);
      final availableHeight = mq.size.height - mq.padding.top - mq.padding.bottom;

      return DigifyBottomSheet.show<WorkSchedule>(
        context,
        type: DigifyBottomSheetType.custom,
        barrierDismissible: false,
        maxHeight: availableHeight * 0.88,
        child: widget,
      );
    }

    return showDialog<WorkSchedule>(context: context, barrierDismissible: false, builder: (context) => widget);
  }

  @override
  ConsumerState<EmployeeWorkScheduleSelectionDialog> createState() => _EmployeeWorkScheduleSelectionDialogState();
}

class _EmployeeWorkScheduleSelectionDialogState extends ConsumerState<EmployeeWorkScheduleSelectionDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(employeeWorkSchedulesNotifierProvider(widget.enterpriseId).notifier);
      notifier.setEnterpriseId(widget.enterpriseId);
      notifier.reset();
      notifier.loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeWorkSchedulesNotifierProvider(widget.enterpriseId));
    final notifier = ref.read(employeeWorkSchedulesNotifierProvider(widget.enterpriseId).notifier);

    final items = state.items.where((s) => s.isActive).toList();
    final errorMessage = state.hasError ? state.errorMessage : null;

    return DigifySingleSelectDialog<WorkSchedule>(
      title: 'Work Schedule',
      subtitle: 'Select a work schedule',
      headerIcon: Icons.calendar_today_rounded,
      items: items,
      selectedId: widget.selectedScheduleId?.toString(),
      idBuilder: (s) => s.workScheduleId.toString(),
      labelBuilder: (s) => s.scheduleNameEn,
      descriptionBuilder: (s) => s.scheduleCode,
      searchHint: 'Search work schedules...',
      emptyMessage: 'No work schedules found',
      isLoading: state.isLoading,
      errorMessage: errorMessage,
      onRetry: () => notifier.refresh(),
      pagination: DigifySingleSelectPagination(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        pageSize: state.pageSize,
        hasNext: state.hasNextPage,
        hasPrevious: state.hasPreviousPage,
      ),
      onPreviousPage: state.hasPreviousPage ? () => notifier.goToPage(state.currentPage - 1) : null,
      onNextPage: state.hasNextPage ? () => notifier.goToPage(state.currentPage + 1) : null,
      onPageTap: (page) => notifier.goToPage(page),
    );
  }
}
