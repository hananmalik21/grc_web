import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/contract_type_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionContractTypeSelectionField extends ConsumerWidget {
  const CreateRequisitionContractTypeSelectionField({super.key, this.isRequired = true});

  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContractType = ref.watch(createRequisitionProvider.select((state) => state.selectedContractType));
    ref.watch(createRequisitionContractTypeLookupValuesProvider);

    return DigifySelectionFieldWithLabel(
      label: 'Contract Type',
      hint: 'Select contract type',
      isRequired: isRequired,
      value: selectedContractType?.meaningEn,
      onTap: () async {
        final selected = await CreateRequisitionContractTypeSelectionDialog.show(
          context: context,
          selectedContractType: selectedContractType,
        );

        if (selected != null) {
          ref.read(createRequisitionProvider.notifier).setSelectedContractType(selected);
        }
      },
    );
  }
}
