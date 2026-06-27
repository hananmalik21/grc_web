import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plan_detail_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_component_frequency_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_owner_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_scope_selection_providers.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/edit_compensation_plan/edit_backed_compensation_plan_notifier.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/edit_compensation_plan/edit_compensation_plan_api_provider.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_config.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_step_body.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCompensationPlanMobileSheet extends ConsumerWidget {
  final String planGuid;

  const EditCompensationPlanMobileSheet({super.key, required this.planGuid});

  static Future<bool> show(BuildContext context, {required String planGuid}) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Edit Compensation Plan',
      barrierDismissible: false,
      child: ProviderScope(child: _EditCompensationPlanSheetLoader(planGuid: planGuid)),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _EditCompensationPlanSheetLoader(planGuid: planGuid);
  }
}

class _EditCompensationPlanSheetLoader extends ConsumerWidget {
  final String planGuid;

  const _EditCompensationPlanSheetLoader({required this.planGuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(compensationPlanDetailProvider(planGuid));
    return planAsync.when(
      loading: () => const _SheetLoadingState(),
      error: (err, _) => _SheetErrorState(error: err.toString()),
      data: (plan) => _EditCompensationPlanSheetScoped(planGuid: planGuid, plan: plan),
    );
  }
}

class _SheetLoadingState extends StatelessWidget {
  const _SheetLoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.all(32), child: AppLoadingIndicator(size: 40)),
    );
  }
}

class _SheetErrorState extends StatelessWidget {
  final String error;

  const _SheetErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Failed to load plan: $error', style: context.textTheme.bodyMedium),
      ),
    );
  }
}

class _EditCompensationPlanSheetScoped extends StatelessWidget {
  final String planGuid;
  final CompensationPlan plan;

  const _EditCompensationPlanSheetScoped({required this.planGuid, required this.plan});

  static Employee? _ownerEmployee(CompensationPlan plan) {
    final owner = plan.owner;
    if (owner == null) return null;
    return Employee(
      id: owner.employeeId,
      guid: owner.employeeGuid,
      enterpriseId: owner.enterpriseId,
      firstName: owner.firstNameEn,
      lastName: owner.lastNameEn,
      email: owner.email ?? '',
      status: owner.status ?? '',
      isActive: owner.status?.toUpperCase() == 'ACTIVE',
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        createCompensationPlanProvider.overrideWith(() => EditBackedCompensationPlanNotifier(plan)),
        compensationPlanCompanyScopeSelectionProvider.overrideWith(
          (ref) => CompensationPlanCompanyScopeSelectionNotifier.withInitialState(
            CompensationPlanCompanyScopeSelectionState.fromPlanBusinessUnits(plan.businessUnits ?? const []),
          ),
        ),
        createCompensationPlanOwnerProvider.overrideWith(
          () => CreateCompensationPlanOwnerNotifier(initialEmployee: _ownerEmployee(plan)),
        ),
      ],
      child: _EditCompensationPlanSheetBody(planGuid: planGuid),
    );
  }
}

class _EditCompensationPlanSheetBody extends ConsumerWidget {
  final String planGuid;

  const _EditCompensationPlanSheetBody({required this.planGuid});

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
    final apiState = ref.read(editCompensationPlanApiProvider);
    if (apiState.isLoading) return;

    ref.read(editCompensationPlanApiProvider.notifier).submit(planGuid: planGuid).then((apiError) {
      if (!context.mounted) return;
      if (apiError != null) {
        ToastService.error(context, apiError);
        return;
      }
      _resetOrgState(ref);
      ToastService.success(context, 'Compensation plan updated successfully!');
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);
    final apiState = ref.watch(editCompensationPlanApiProvider);
    final stepCount = CreateCompensationPlanConfig.steps.length;

    return DigifyStepperSheetContent(
      currentStep: state.currentStep,
      totalSteps: stepCount,
      stepLabel: CreateCompensationPlanConfig.steps[state.currentStep].label,
      isDark: context.isDark,
      canGoPrevious: state.currentStep > 0,
      isLastStep: state.currentStep == stepCount - 1,
      isLoading: apiState.isLoading,
      previousLabel: 'Back',
      nextLabel: 'Continue',
      saveLabel: 'Save Changes',
      onPrevious: notifier.previousStep,
      onNext: () => _onNext(context, ref),
      onSave: () => _onSave(context, ref),
      body: CreateCompensationPlanStepBody(currentStep: state.currentStep),
    );
  }
}
