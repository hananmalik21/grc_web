import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/developer_tools/data/models/action_item.dart';
import 'package:grc/features/developer_tools/presentation/providers/function_picker_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionPickerDialog extends ConsumerWidget {
  const ActionPickerDialog({super.key, required this.subModuleGuid, this.selectedId});

  final String subModuleGuid;
  final String? selectedId;

  static Future<ActionItem?> show(
    BuildContext context, {
    required String subModuleGuid,
    String? selectedId,
  }) {
    return DigifySingleSelectDialog.showAdaptive<ActionItem>(
      context: context,
      child: ActionPickerDialog(subModuleGuid: subModuleGuid, selectedId: selectedId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(actionsProvider(subModuleGuid));
    final notifier = ref.read(actionsProvider(subModuleGuid).notifier);

    return DigifySingleSelectDialog<ActionItem>(
      title: 'Select Action',
      subtitle: 'Choose one action',
      items: state.items,
      selectedId: selectedId,
      idBuilder: (item) => item.actionGuid,
      labelBuilder: (item) => item.actionName,
      descriptionBuilder: (item) => item.actionCode,
      searchHint: 'Search actions...',
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      onRetry: () => notifier.loadPage(1),
      pagination: state.totalPages > 1
          ? DigifySingleSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNext,
              hasPrevious: state.hasPrevious,
            )
          : null,
      onPreviousPage: state.hasPrevious ? () => notifier.loadPage(state.currentPage - 1) : null,
      onNextPage: state.hasNext ? () => notifier.loadPage(state.currentPage + 1) : null,
    );
  }
}
