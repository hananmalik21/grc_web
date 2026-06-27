import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/job_family_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionJobFamilySelectionField extends ConsumerWidget {
  const CreateRequisitionJobFamilySelectionField({super.key, this.isRequired = true});

  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJobFamily = ref.watch(createRequisitionProvider.select((state) => state.selectedJobFamily));
    ref.watch(createRequisitionJobFamilyNotifierProvider);

    return DigifySelectionFieldWithLabel(
      label: 'Job Family',
      hint: 'Select Job Family',
      isRequired: isRequired,
      value: selectedJobFamily?.nameEnglish,
      onTap: () async {
        if (ref.read(createRequisitionJobFamilyNotifierProvider).isEmpty) {
          ref.read(createRequisitionJobFamilyNotifierProvider.notifier).loadFirstPage();
        }

        final selected = await CreateRequisitionJobFamilySelectionDialog.show(
          context: context,
          selectedJobFamily: selectedJobFamily,
        );

        if (selected != null) {
          ref.read(createRequisitionProvider.notifier).setSelectedJobFamily(selected);
        }
      },
    );
  }
}
