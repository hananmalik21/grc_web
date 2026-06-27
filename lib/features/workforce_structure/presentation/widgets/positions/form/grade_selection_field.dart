import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GradeSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const GradeSelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(positionFormNotifierProvider);
    final selectedJobLevel = formState.jobLevel;
    final selectedGrade = formState.grade;
    final gradesAsync = ref.watch(gradesInRangeForPositionFormProvider);
    final isEnabled = selectedJobLevel != null;

    return gradesAsync.when(
      data: (grades) => DigifySelectFieldWithLabel<Grade>(
        label: label,
        isRequired: isRequired,
        items: grades,
        itemLabelBuilder: (g) => g.gradeLabel,
        value: selectedGrade != null && grades.any((g) => g.id == selectedGrade.id) ? selectedGrade : null,
        onChanged: isEnabled ? (v) => ref.read(positionFormNotifierProvider.notifier).setGrade(v) : null,
        hint: !isEnabled ? 'Select job level first' : (grades.isEmpty ? 'No grades in range' : 'Select grade'),
      ),
      loading: () => DigifySelectFieldWithLabel<Grade>(
        label: label,
        isRequired: isRequired,
        items: const [],
        itemLabelBuilder: (_) => '',
        hint: 'Loading grades...',
      ),
      error: (_, _) => DigifySelectFieldWithLabel<Grade>(
        label: label,
        isRequired: isRequired,
        items: const [],
        itemLabelBuilder: (_) => '',
        hint: isEnabled ? 'Error loading grades' : 'Select job level first',
      ),
    );
  }
}
