import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_contract_type_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferContractTypeSelectionField extends ConsumerWidget {
  const CreateOfferContractTypeSelectionField({super.key, this.isRequired = true});

  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContractType = ref.watch(createOfferProvider.select((state) => state.selectedContractType));
    ref.watch(createOfferContractTypeLookupValuesProvider);

    return DigifySelectionFieldWithLabel(
      label: 'Contract Type',
      hint: 'Select contract type',
      isRequired: isRequired,
      value: selectedContractType?.meaningEn,
      onTap: () async {
        final selected = await CreateOfferContractTypeSelectionDialog.show(
          context: context,
          selectedContractType: selectedContractType,
        );

        if (selected != null) {
          ref.read(createOfferProvider.notifier).setSelectedContractType(selected);
        }
      },
    );
  }
}
