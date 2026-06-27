import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobFamilySelectionDialog extends ConsumerWidget {
  final JobFamily? selectedJobFamily;

  const JobFamilySelectionDialog({super.key, this.selectedJobFamily});

  static Future<JobFamily?> show({required BuildContext context, JobFamily? selectedJobFamily}) {
    return DigifySingleSelectDialog.showAdaptive<JobFamily>(
      context: context,
      child: JobFamilySelectionDialog(selectedJobFamily: selectedJobFamily),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobFamilyNotifierForPositionProvider);

    return DigifySingleSelectDialog<JobFamily>(
      title: 'Select Job Family',
      subtitle: 'Choose a job family from the list',
      headerIcon: Icons.work_rounded,
      items: state.items,
      selectedId: selectedJobFamily?.id.toString(),
      idBuilder: (item) => item.id.toString(),
      labelBuilder: (item) => item.nameEnglish,
      descriptionBuilder: (item) => item.code,
      searchHint: 'Search job families...',
      emptyMessage: 'No job families found',
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      onRetry: () => ref.read(jobFamilyNotifierForPositionProvider.notifier).refresh(),
      pagination: DigifySingleSelectPagination(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        pageSize: state.pageSize,
        hasNext: state.hasNextPage,
        hasPrevious: state.hasPreviousPage,
      ),
      onPreviousPage: () => ref.read(jobFamilyNotifierForPositionProvider.notifier).goToPage(state.currentPage - 1),
      onNextPage: () => ref.read(jobFamilyNotifierForPositionProvider.notifier).goToPage(state.currentPage + 1),
      onPageTap: (page) => ref.read(jobFamilyNotifierForPositionProvider.notifier).goToPage(page),
    );
  }
}
