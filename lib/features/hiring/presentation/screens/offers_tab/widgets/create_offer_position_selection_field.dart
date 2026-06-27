import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_position_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferPositionSelectionField extends ConsumerWidget {
  const CreateOfferPositionSelectionField({super.key, this.isRequired = true});

  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPosition = ref.watch(createOfferProvider.select((state) => state.selectedPosition));
    ref.watch(createOfferPositionNotifierProvider);

    return DigifySelectionFieldWithLabel(
      label: 'Job Title',
      hint: 'Select job title',
      isRequired: isRequired,
      value: selectedPosition?.titleEnglish,
      onTap: () async {
        if (ref.read(createOfferPositionNotifierProvider).isEmpty) {
          ref.read(createOfferPositionNotifierProvider.notifier).loadFirstPage();
        }

        final selected = await CreateOfferPositionSelectionDialog.show(
          context: context,
          selectedPosition: selectedPosition,
        );

        if (selected != null) {
          ref.read(createOfferProvider.notifier).setSelectedPosition(selected);
        }
      },
    );
  }
}
