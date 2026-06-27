import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/utils/form_validators.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGradeFormState {
  final EmplLookupValue? selectedGradeNumber;
  final EmplLookupValue? selectedGradeCategory;
  final String step1Salary;
  final String step2Salary;
  final String step3Salary;
  final String step4Salary;
  final String step5Salary;
  final String description;

  const CreateGradeFormState({
    this.selectedGradeNumber,
    this.selectedGradeCategory,
    this.step1Salary = '',
    this.step2Salary = '',
    this.step3Salary = '',
    this.step4Salary = '',
    this.step5Salary = '',
    this.description = '',
  });
}

class CreateGradeFormNotifier extends StateNotifier<CreateGradeFormState> {
  CreateGradeFormNotifier() : super(const CreateGradeFormState());

  void setSelectedGradeNumber(EmplLookupValue? value) {
    state = CreateGradeFormState(
      selectedGradeNumber: value,
      selectedGradeCategory: state.selectedGradeCategory,
      step1Salary: state.step1Salary,
      step2Salary: state.step2Salary,
      step3Salary: state.step3Salary,
      step4Salary: state.step4Salary,
      step5Salary: state.step5Salary,
      description: state.description,
    );
  }

  void setSelectedGradeCategory(EmplLookupValue? value) {
    state = CreateGradeFormState(
      selectedGradeNumber: null,
      selectedGradeCategory: value,
      step1Salary: state.step1Salary,
      step2Salary: state.step2Salary,
      step3Salary: state.step3Salary,
      step4Salary: state.step4Salary,
      step5Salary: state.step5Salary,
      description: state.description,
    );
  }

  void setStepSalary(int index, String value) {
    final steps = [state.step1Salary, state.step2Salary, state.step3Salary, state.step4Salary, state.step5Salary];
    if (index < 0 || index >= 5) return;
    steps[index] = value;
    state = CreateGradeFormState(
      selectedGradeNumber: state.selectedGradeNumber,
      selectedGradeCategory: state.selectedGradeCategory,
      step1Salary: steps[0],
      step2Salary: steps[1],
      step3Salary: steps[2],
      step4Salary: steps[3],
      step5Salary: steps[4],
      description: state.description,
    );
  }

  void setDescription(String value) {
    state = CreateGradeFormState(
      selectedGradeNumber: state.selectedGradeNumber,
      selectedGradeCategory: state.selectedGradeCategory,
      step1Salary: state.step1Salary,
      step2Salary: state.step2Salary,
      step3Salary: state.step3Salary,
      step4Salary: state.step4Salary,
      step5Salary: state.step5Salary,
      description: value,
    );
  }

  String? _validateStepSalary(String? value, AppLocalizations l10n, int stepIndex) {
    if (value == null || value.trim().isEmpty) return l10n.stepSalaryRequired(stepIndex + 1);
    final numberError = FormValidators.number(value);
    if (numberError != null) return l10n.stepSalaryInvalid(stepIndex + 1);
    final numValue = num.tryParse(value);
    if (numValue == null || numValue < 0) return l10n.stepSalaryInvalid(stepIndex + 1);
    return null;
  }

  Future<bool> submit(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return false;

    if (state.selectedGradeNumber == null) {
      ToastService.error(context, l10n.gradeNumberRequired);
      return false;
    }

    if (state.selectedGradeCategory == null) {
      ToastService.error(context, l10n.gradeCategoryRequired);
      return false;
    }

    final steps = [state.step1Salary, state.step2Salary, state.step3Salary, state.step4Salary, state.step5Salary];
    double previousSalary = -1.0;
    for (var i = 0; i < steps.length; i++) {
      final err = _validateStepSalary(steps[i], l10n, i);
      if (err != null) {
        ToastService.error(context, err);
        return false;
      }
      final numValue = double.parse(steps[i]);
      if (i > 0 && numValue <= previousSalary) {
        ToastService.error(context, 'Step ${i + 1} salary must be greater than Step $i');
        return false;
      }
      previousSalary = numValue;
    }

    try {
      final grade = Grade(
        id: 0,
        gradeNumber: state.selectedGradeNumber!.lookupCode,
        gradeCategory: state.selectedGradeCategory!.lookupCode,
        currencyCode: 'KWD',
        step1Salary: double.parse(state.step1Salary),
        step2Salary: double.parse(state.step2Salary),
        step3Salary: double.parse(state.step3Salary),
        step4Salary: double.parse(state.step4Salary),
        step5Salary: double.parse(state.step5Salary),
        description: state.description,
        status: 'ACTIVE',
        createdBy: 'ADMIN',
        createdDate: DateTime.now(),
        lastUpdatedBy: 'ADMIN',
        lastUpdatedDate: DateTime.now(),
        lastUpdateLogin: 'ADMIN',
      );

      await ref.read(gradeNotifierProvider.notifier).createGrade(grade);

      if (context.mounted) {
        ToastService.success(context, l10n.gradeCreatedSuccessfully);
        return true;
      }
    } catch (_) {
      if (context.mounted) ToastService.error(context, l10n.errorCreatingGrade);
    }
    return false;
  }
}

final createGradeFormStateProvider = StateNotifierProvider.autoDispose<CreateGradeFormNotifier, CreateGradeFormState>((
  ref,
) {
  return CreateGradeFormNotifier();
});

final gradeNumbersForCreateGradeFormProvider = Provider.autoDispose<List<EmplLookupValue>>((ref) {
  final all = ref.watch(gradeNumberLookupValuesProvider).value ?? [];
  final category = ref.watch(createGradeFormStateProvider).selectedGradeCategory;
  if (category == null) return [];
  final prefix = category.lookupCode.trim().toUpperCase();
  if (prefix.isEmpty) return all;
  return all.where((g) => g.lookupCode.trim().toUpperCase().startsWith(prefix)).toList();
});
