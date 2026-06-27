import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkPatternSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;
  final int enterpriseId;
  final WorkPattern? selectedWorkPattern;
  final ValueChanged<WorkPattern?> onChanged;

  const WorkPatternSelectionField({
    super.key,
    required this.label,
    this.isRequired = true,
    required this.enterpriseId,
    this.selectedWorkPattern,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workPatternsState = ref.watch(workPatternsNotifierProvider(enterpriseId));
    final notifier = ref.read(workPatternsNotifierProvider(enterpriseId).notifier);

    return DigifySelectionFieldWithLabel(
      label: label,
      hint: 'Select Work Pattern',
      value: selectedWorkPattern?.patternNameEn,
      isRequired: isRequired,
      onTap: () async {
        notifier.setEnterpriseId(enterpriseId);
        if (workPatternsState.items.isEmpty && !workPatternsState.isLoading) {
          await notifier.loadFirstPage();
        }

        if (!context.mounted) return;
        final latestState = ref.read(workPatternsNotifierProvider(enterpriseId));

        final selected = await DigifySingleSelectDialog.show<WorkPattern>(
          context: context,
          title: 'Select Work Pattern',
          subtitle: 'Choose a work pattern from the list',
          items: latestState.items,
          selectedId: selectedWorkPattern?.workPatternId.toString(),
          idBuilder: (pattern) => pattern.workPatternId.toString(),
          labelBuilder: (pattern) => pattern.patternNameEn,
          descriptionBuilder: (pattern) => pattern.patternCode,
          searchHint: 'Search work patterns...',
          emptyMessage: 'No Work Patterns found',
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
