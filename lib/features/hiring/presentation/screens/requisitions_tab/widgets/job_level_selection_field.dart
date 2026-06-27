import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/job_level_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionJobLevelSelectionField extends ConsumerWidget {
  const CreateRequisitionJobLevelSelectionField({super.key, this.isRequired = true});

  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJobLevel = ref.watch(createRequisitionProvider.select((state) => state.selectedJobLevel));
    ref.watch(createRequisitionJobLevelNotifierProvider);

    return DigifySelectionFieldWithLabel(
      label: 'Job Level',
      hint: 'Select Job Level',
      isRequired: isRequired,
      value: selectedJobLevel?.nameEn,
      onTap: () async {
        if (ref.read(createRequisitionJobLevelNotifierProvider).isEmpty) {
          ref.read(createRequisitionJobLevelNotifierProvider.notifier).loadFirstPage();
        }

        final selected = await CreateRequisitionJobLevelSelectionDialog.show(
          context: context,
          selectedJobLevel: selectedJobLevel,
        );

        if (selected != null) {
          ref.read(createRequisitionProvider.notifier).setSelectedJobLevel(selected);
        }
      },
    );
  }
}
