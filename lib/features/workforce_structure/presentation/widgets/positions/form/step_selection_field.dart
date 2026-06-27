import 'package:grc/core/widgets/forms/digify_consecutive_range_select_field.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/position_form_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _stepLabel(GradeStep step) => 'Step ${step.step}';

String _stepSublabel(GradeStep step, String currencyCode) => '${step.salary.toStringAsFixed(0)} $currencyCode';

class StepSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const StepSelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(positionFormNotifierProvider);
    final grade = formState.grade;
    final gradesInRangeAsync = ref.watch(gradesInRangeForPositionFormProvider);

    if (grade == null) {
      return PositionLabeledField(
        label: label,
        isRequired: isRequired,
        child: PositionFormHelpers.buildDropdownField<GradeStep>(
          value: null,
          items: const [],
          onChanged: null,
          itemLabelProvider: (s) => '',
          hint: 'Select grade first',
          readOnly: true,
        ),
      );
    }

    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: gradesInRangeAsync.when(
        data: (grades) {
          final resolvedGrade = grades.where((g) => g.id == grade.id).firstOrNull;
          final gradeHasSteps = resolvedGrade != null && resolvedGrade.minSalary > 0;
          final steps = gradeHasSteps ? resolvedGrade.steps : <GradeStep>[];
          final selectedSteps = ref.watch(selectedStepsForPositionFormProvider);
          final currencyCode = (resolvedGrade ?? grade).currencyCode;

          return DigifyConsecutiveRangeSelectField<GradeStep>(
            items: steps,
            itemLabelBuilder: _stepLabel,
            itemSublabelBuilder: (s) => _stepSublabel(s, currencyCode),
            selectedItems: selectedSteps,
            areItemsEqual: (a, b) => a.step == b.step,
            hint: steps.isEmpty ? 'No steps available' : 'Select step',
            onChanged: steps.isEmpty
                ? null
                : (selected) => ref.read(positionFormNotifierProvider.notifier).setSelectedSteps(selected),
          );
        },
        loading: () => PositionFormHelpers.buildDropdownField<GradeStep>(
          value: null,
          items: const [],
          onChanged: null,
          itemLabelProvider: (s) => '',
          hint: 'Loading...',
          readOnly: true,
        ),
        error: (_, _) => PositionFormHelpers.buildDropdownField<GradeStep>(
          value: null,
          items: const [],
          onChanged: null,
          itemLabelProvider: (s) => '',
          hint: 'Error loading steps',
          readOnly: true,
        ),
      ),
    );
  }
}
