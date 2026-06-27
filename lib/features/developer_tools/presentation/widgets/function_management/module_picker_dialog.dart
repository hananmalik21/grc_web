import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/developer_tools/data/models/module_item.dart';
import 'package:grc/features/developer_tools/presentation/providers/function_picker_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModulePickerDialog extends ConsumerWidget {
  const ModulePickerDialog({super.key, this.selectedId});

  final String? selectedId;

  static Future<ModuleItem?> show(BuildContext context, {String? selectedId}) {
    return DigifySingleSelectDialog.showAdaptive<ModuleItem>(
      context: context,
      child: ModulePickerDialog(selectedId: selectedId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(modulesProvider);
    final notifier = ref.read(modulesProvider.notifier);

    return DigifySingleSelectDialog<ModuleItem>(
      title: 'Select Module',
      subtitle: 'Choose one module',
      items: state.items,
      selectedId: selectedId,
      idBuilder: (item) => item.moduleGuid,
      labelBuilder: (item) => item.moduleName,
      descriptionBuilder: (item) => item.moduleCode,
      searchHint: 'Search modules...',
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
