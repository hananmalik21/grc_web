import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionGradeSelectionDialog extends ConsumerWidget {
  const CreateRequisitionGradeSelectionDialog({super.key, this.selectedGrade});

  final Grade? selectedGrade;

  static Future<Grade?> show({required BuildContext context, Grade? selectedGrade}) {
    return DigifySingleSelectDialog.showAdaptive<Grade>(
      context: context,
      child: CreateRequisitionGradeSelectionDialog(selectedGrade: selectedGrade),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createRequisitionGradeNotifierProvider);

    return DigifySingleSelectDialog<Grade>(
      title: 'Select Grade',
      subtitle: 'Choose a grade from the list',
      headerIcon: Icons.grade_rounded,
      items: state.items,
      selectedId: selectedGrade?.id.toString(),
      idBuilder: (item) => item.id.toString(),
      labelBuilder: (item) => item.gradeLabel,
      searchHint: 'Search grades...',
      emptyMessage: 'No grades found',
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      onRetry: () => ref.read(createRequisitionGradeNotifierProvider.notifier).refresh(),
      pagination: DigifySingleSelectPagination(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        pageSize: state.pageSize,
        hasNext: state.hasNextPage,
        hasPrevious: state.hasPreviousPage,
      ),
      onPreviousPage: () => ref.read(createRequisitionGradeNotifierProvider.notifier).goToPage(state.currentPage - 1),
      onNextPage: () => ref.read(createRequisitionGradeNotifierProvider.notifier).goToPage(state.currentPage + 1),
      onPageTap: (page) => ref.read(createRequisitionGradeNotifierProvider.notifier).goToPage(page),
    );
  }
}
