import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeAllPositionsSelectionDialog extends ConsumerStatefulWidget {
  const EmployeeAllPositionsSelectionDialog({super.key, required this.enterpriseId, this.selectedPosition});

  final int enterpriseId;
  final Position? selectedPosition;

  static Future<Position?> show(BuildContext context, {required int enterpriseId, Position? selectedPosition}) async {
    if (context.isMobile) {
      final mq = MediaQuery.of(context);
      final availableHeight = mq.size.height - mq.padding.top - mq.padding.bottom;

      return DigifyBottomSheet.show<Position>(
        context,
        type: DigifyBottomSheetType.custom,
        barrierDismissible: false,
        maxHeight: availableHeight * 0.88,
        child: EmployeeAllPositionsSelectionDialog(enterpriseId: enterpriseId, selectedPosition: selectedPosition),
      );
    }

    return showDialog<Position>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          EmployeeAllPositionsSelectionDialog(enterpriseId: enterpriseId, selectedPosition: selectedPosition),
    );
  }

  @override
  ConsumerState<EmployeeAllPositionsSelectionDialog> createState() => _EmployeeAllPositionsSelectionDialogState();
}

class _EmployeeAllPositionsSelectionDialogState extends ConsumerState<EmployeeAllPositionsSelectionDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeePositionNotifierProvider(widget.enterpriseId).notifier).loadFirstPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeePositionNotifierProvider(widget.enterpriseId));
    final notifier = ref.read(employeePositionNotifierProvider(widget.enterpriseId).notifier);
    final errorMessage = state.hasError ? state.errorMessage : null;

    return DigifySingleSelectDialog<Position>(
      title: 'Position',
      subtitle: 'Select Position',
      items: state.items,
      selectedId: widget.selectedPosition?.id,
      idBuilder: (position) => position.id,
      labelBuilder: (position) => position.titleEnglish,
      descriptionBuilder: (position) => position.code,
      isLoading: state.isLoading,
      errorMessage: errorMessage,
      onRetry: notifier.loadFirstPage,
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
      onPageTap: notifier.goToPage,
    );
  }
}
