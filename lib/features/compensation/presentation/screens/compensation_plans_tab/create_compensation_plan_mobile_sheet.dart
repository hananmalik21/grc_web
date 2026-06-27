import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_api_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_component_frequency_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_scope_selection_providers.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_config.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_step_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCompensationPlanMobileSheet extends ConsumerWidget {
  const CreateCompensationPlanMobileSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Create New Plan',
      barrierDismissible: false,
      child: ProviderScope(child: const CreateCompensationPlanMobileSheet()),
    );
    return result == true;
  }

  void _resetOrgState(WidgetRef ref) {
    ref.read(compensationPlanCompanyScopeSelectionProvider.notifier).reset();
    ref.invalidate(compensationPlanEnterpriseSelectionNotifierProvider);
  }

  void _onNext(BuildContext context, WidgetRef ref) {
    final state = ref.read(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);

    if (state.currentStep == 1) {
      final hasMissingFrequency = state.selectedComponents.any(
        (c) => state.componentFrequencies[c.componentId] == null,
      );
      if (hasMissingFrequency) {
        ref.read(componentFrequencyValidationTriggeredProvider.notifier).state = true;
        ToastService.error(context, 'Select a frequency for every component before continuing.');
        return;
      }
      ref.read(componentFrequencyValidationTriggeredProvider.notifier).state = false;
    }

    final error = notifier.tryGoNext();
    if (error != null) ToastService.error(context, error);
  }

  void _onSave(BuildContext context, WidgetRef ref) {
    final createApiState = ref.read(createCompensationPlanApiProvider);
    if (createApiState.isLoading) return;

    ref.read(createCompensationPlanApiProvider.notifier).submit().then((apiError) {
      if (!context.mounted) return;
      if (apiError != null) {
        ToastService.error(context, apiError);
        return;
      }
      _resetOrgState(ref);
      ToastService.success(context, 'Compensation plan created successfully!');
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);
    final createApiState = ref.watch(createCompensationPlanApiProvider);
    final stepCount = CreateCompensationPlanConfig.steps.length;

    return DigifyStepperSheetContent(
      currentStep: state.currentStep,
      totalSteps: stepCount,
      stepLabel: CreateCompensationPlanConfig.steps[state.currentStep].label,
      isDark: context.isDark,
      canGoPrevious: state.currentStep > 0,
      isLastStep: state.currentStep == stepCount - 1,
      isLoading: createApiState.isLoading,
      previousLabel: 'Back',
      nextLabel: 'Continue',
      saveLabel: 'Create Plan',
      onPrevious: notifier.previousStep,
      onNext: () => _onNext(context, ref),
      onSave: () => _onSave(context, ref),
      body: CreateCompensationPlanStepBody(currentStep: state.currentStep),
    );
  }
}
