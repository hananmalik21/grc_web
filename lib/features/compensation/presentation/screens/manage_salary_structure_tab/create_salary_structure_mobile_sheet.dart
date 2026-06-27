import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/providers/create_salary_structure_api_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_creation_provider.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/widgets/salary_structure_creation_step_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSalaryStructureMobileSheet extends ConsumerWidget {
  const CreateSalaryStructureMobileSheet({super.key});

  static const _stepLabels = [
    'Basic Information',
    'Scope & Assignment',
    'Components',
    'Financial Details',
    'Advanced Settings',
  ];

  static Future<bool> show(BuildContext context) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Create Salary Structure',
      barrierDismissible: false,
      child: ProviderScope(child: const CreateSalaryStructureMobileSheet()),
    );
    return result == true;
  }

  void _onNext(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final error = notifier.tryGoNext();
    if (error != null) ToastService.error(context, error);
  }

  void _onSave(BuildContext context, WidgetRef ref) {
    final submitState = ref.read(createSalaryStructureApiProvider);
    if (submitState.isLoading) return;

    final validationError = ref.read(salaryStructureCreationProvider.notifier).validateForSubmit();
    if (validationError != null) {
      ToastService.error(context, validationError);
      return;
    }

    ref.read(createSalaryStructureApiProvider.notifier).submit().then((apiError) {
      if (!context.mounted) return;
      if (apiError != null) {
        ToastService.error(context, apiError);
        return;
      }
      ref.read(companyScopeSelectionProvider.notifier).reset();
      ToastService.success(context, 'Salary Structure saved successfully!');
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final submitState = ref.watch(createSalaryStructureApiProvider);
    final totalSteps = _stepLabels.length;
    final isLastStep = state.currentStep == totalSteps - 1;

    return DigifyStepperSheetContent(
      currentStep: state.currentStep,
      totalSteps: totalSteps,
      stepLabel: _stepLabels[state.currentStep],
      isDark: context.isDark,
      canGoPrevious: state.currentStep > 0,
      isLastStep: isLastStep,
      isLoading: submitState.isLoading,
      previousLabel: 'Back',
      nextLabel: 'Continue',
      saveLabel: 'Save Structure',
      onPrevious: notifier.previousStep,
      onNext: () => _onNext(context, ref),
      onSave: () => _onSave(context, ref),
      body: SalaryStructureCreationStepBody(currentStep: state.currentStep),
    );
  }
}
