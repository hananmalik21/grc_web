import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionJobFamilySelectionDialog extends ConsumerWidget {
  const CreateRequisitionJobFamilySelectionDialog({super.key, this.selectedJobFamily});

  final JobFamily? selectedJobFamily;

  static Future<JobFamily?> show({required BuildContext context, JobFamily? selectedJobFamily}) {
    return DigifySingleSelectDialog.showAdaptive<JobFamily>(
      context: context,
      child: CreateRequisitionJobFamilySelectionDialog(selectedJobFamily: selectedJobFamily),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createRequisitionJobFamilyNotifierProvider);

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
      onRetry: () => ref.read(createRequisitionJobFamilyNotifierProvider.notifier).refresh(),
      pagination: DigifySingleSelectPagination(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        pageSize: state.pageSize,
        hasNext: state.hasNextPage,
        hasPrevious: state.hasPreviousPage,
      ),
      onPreviousPage: () =>
          ref.read(createRequisitionJobFamilyNotifierProvider.notifier).goToPage(state.currentPage - 1),
      onNextPage: () => ref.read(createRequisitionJobFamilyNotifierProvider.notifier).goToPage(state.currentPage + 1),
      onPageTap: (page) => ref.read(createRequisitionJobFamilyNotifierProvider.notifier).goToPage(page),
    );
  }
}
