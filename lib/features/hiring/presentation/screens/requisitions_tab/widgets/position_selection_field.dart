import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/position_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionPositionSelectionField extends ConsumerWidget {
  const CreateRequisitionPositionSelectionField({super.key, this.isRequired = true});

  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPosition = ref.watch(createRequisitionProvider.select((state) => state.selectedPosition));
    ref.watch(createRequisitionPositionNotifierProvider);

    return DigifySelectionFieldWithLabel(
      label: 'Job Title',
      hint: 'Select job title',
      isRequired: isRequired,
      value: selectedPosition?.titleEnglish,
      onTap: () async {
        if (ref.read(createRequisitionPositionNotifierProvider).isEmpty) {
          ref.read(createRequisitionPositionNotifierProvider.notifier).loadFirstPage();
        }

        final selected = await CreateRequisitionPositionSelectionDialog.show(
          context: context,
          selectedPosition: selectedPosition,
        );

        if (selected != null) {
          ref.read(createRequisitionProvider.notifier).setSelectedPosition(selected);
        }
      },
    );
  }
}
