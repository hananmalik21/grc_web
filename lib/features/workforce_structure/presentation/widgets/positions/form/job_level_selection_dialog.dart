import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobLevelSelectionDialog extends ConsumerWidget {
  final JobLevel? selectedJobLevel;

  const JobLevelSelectionDialog({super.key, this.selectedJobLevel});

  static Future<JobLevel?> show({required BuildContext context, JobLevel? selectedJobLevel}) {
    return DigifySingleSelectDialog.showAdaptive<JobLevel>(
      context: context,
      child: JobLevelSelectionDialog(selectedJobLevel: selectedJobLevel),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobLevelNotifierForPositionProvider);

    return DigifySingleSelectDialog<JobLevel>(
      title: 'Select Job Level',
      subtitle: 'Choose a job level from the list',
      headerIcon: Icons.layers,
      items: state.items,
      selectedId: selectedJobLevel?.id.toString(),
      idBuilder: (item) => item.id.toString(),
      labelBuilder: (item) => item.nameEn,
      searchHint: 'Search job levels...',
      emptyMessage: 'No job levels found',
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      onRetry: () => ref.read(jobLevelNotifierForPositionProvider.notifier).refresh(),
      pagination: DigifySingleSelectPagination(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        pageSize: state.pageSize,
        hasNext: state.hasNextPage,
        hasPrevious: state.hasPreviousPage,
      ),
      onPreviousPage: () => ref.read(jobLevelNotifierForPositionProvider.notifier).goToPage(state.currentPage - 1),
      onNextPage: () => ref.read(jobLevelNotifierForPositionProvider.notifier).goToPage(state.currentPage + 1),
      onPageTap: (page) => ref.read(jobLevelNotifierForPositionProvider.notifier).goToPage(page),
    );
  }
}
