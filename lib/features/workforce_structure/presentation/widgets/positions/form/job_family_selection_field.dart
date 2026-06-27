import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/job_family_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobFamilySelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const JobFamilySelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJobFamily = ref.watch(positionFormNotifierProvider.select((state) => state.jobFamily));
    ref.watch(jobFamilyNotifierForPositionProvider);

    return DigifySelectionFieldWithLabel(
      label: label,
      hint: 'Select Job Family',
      isRequired: isRequired,
      value: selectedJobFamily?.nameEnglish,
      onTap: () async {
        if (ref.read(jobFamilyNotifierForPositionProvider).isEmpty) {
          ref.read(jobFamilyNotifierForPositionProvider.notifier).loadFirstPage();
        }

        final selected = await JobFamilySelectionDialog.show(context: context, selectedJobFamily: selectedJobFamily);

        if (selected != null) {
          ref.read(positionFormNotifierProvider.notifier).setJobFamily(selected);
        }
      },
    );
  }
}
