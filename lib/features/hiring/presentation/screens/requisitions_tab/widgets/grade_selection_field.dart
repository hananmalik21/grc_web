import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/grade_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionGradeSelectionField extends ConsumerWidget {
  const CreateRequisitionGradeSelectionField({super.key, this.isRequired = true});

  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGrade = ref.watch(createRequisitionProvider.select((state) => state.selectedGrade));
    ref.watch(createRequisitionGradeNotifierProvider);

    return DigifySelectionFieldWithLabel(
      label: 'Grade/Level',
      hint: 'Select grade/level',
      isRequired: isRequired,
      value: selectedGrade?.gradeLabel,
      onTap: () async {
        if (ref.read(createRequisitionGradeNotifierProvider).isEmpty) {
          ref.read(createRequisitionGradeNotifierProvider.notifier).loadFirstPage();
        }

        final selected = await CreateRequisitionGradeSelectionDialog.show(
          context: context,
          selectedGrade: selectedGrade,
        );

        if (selected != null) {
          ref.read(createRequisitionProvider.notifier).setSelectedGrade(selected);
        }
      },
    );
  }
}
