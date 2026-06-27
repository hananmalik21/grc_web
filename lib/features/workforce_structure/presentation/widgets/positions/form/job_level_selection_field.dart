import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/job_level_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobLevelSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const JobLevelSelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedJobLevel = ref.watch(positionFormNotifierProvider.select((state) => state.jobLevel));
    final jobLevelsState = ref.watch(jobLevelNotifierForPositionProvider);
    final error = jobLevelsState.errorMessage;

    return DigifySelectionFieldWithLabel(
      label: label,
      hint: 'Select Job Level',
      isRequired: isRequired,
      value: selectedJobLevel?.nameEn,
      borderColor: error != null ? AppColors.error : null,
      onTap: () async {
        if (ref.read(jobLevelNotifierForPositionProvider).isEmpty) {
          ref.read(jobLevelNotifierForPositionProvider.notifier).loadFirstPage();
        }

        final selected = await JobLevelSelectionDialog.show(context: context, selectedJobLevel: selectedJobLevel);

        if (selected != null) {
          ref.read(positionFormNotifierProvider.notifier).setJobLevel(selected);
        }
      },
    );
  }
}
