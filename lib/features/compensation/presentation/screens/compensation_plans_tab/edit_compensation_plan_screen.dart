import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plan_detail_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_component_frequency_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_owner_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_scope_selection_providers.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/edit_compensation_plan/edit_backed_compensation_plan_notifier.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/edit_compensation_plan/edit_compensation_plan_api_provider.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_config.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_header.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_step_body.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditCompensationPlanScreen extends ConsumerWidget {
  static const String routeName = 'compensation-plans-edit';

  final String planGuid;

  const EditCompensationPlanScreen({super.key, required this.planGuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(compensationPlanDetailProvider(planGuid));
    return planAsync.when(
      loading: () => const _LoadingState(),
      error: (err, _) => _ErrorState(error: err.toString()),
      data: (plan) => _EditCompensationPlanScoped(plan: plan),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(size: 48.r),
            Gap(16.h),
            Text(
              'Loading plan details...',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Center(
        child: Text(
          'Failed to load plan: $error',
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}

class _EditCompensationPlanScoped extends StatelessWidget {
  final CompensationPlan plan;

  const _EditCompensationPlanScoped({required this.plan});

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
      child: _EditCompensationPlanBody(planGuid: plan.planGuid),
    );
  }

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
}

class _EditCompensationPlanBody extends ConsumerWidget {
  final String planGuid;

  const _EditCompensationPlanBody({required this.planGuid});

  void _resetOrgState(WidgetRef ref) {
    ref.read(compensationPlanCompanyScopeSelectionProvider.notifier).reset();
    ref.invalidate(compensationPlanEnterpriseSelectionNotifierProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);
    final apiState = ref.watch(editCompensationPlanApiProvider);
    final isLastStep = state.currentStep == CreateCompensationPlanConfig.steps.length - 1;
    final canGoBack = state.currentStep > 0;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreateCompensationPlanHeader(
              title: 'Edit Compensation Plan',
              description: 'Update the details of your compensation plan.',
              submitLabel: 'Save Changes',
              canGoBack: canGoBack,
              isLastStep: isLastStep,
              isSubmitting: apiState.isLoading,
              onBack: notifier.previousStep,
              onCancel: () {
                _resetOrgState(ref);
                context.pop();
              },
              onContinue: () {
                if (!isLastStep) {
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
                  return;
                }

                if (apiState.isLoading) return;

                ref.read(editCompensationPlanApiProvider.notifier).submit(planGuid: planGuid).then((apiError) {
                  if (!context.mounted) return;
                  if (apiError != null) {
                    ToastService.error(context, apiError);
                    return;
                  }
                  _resetOrgState(ref);
                  ToastService.success(context, 'Compensation plan updated successfully!');
                  context.pop(true);
                });
              },
            ),
            Gap(24.h),
            CreateCompensationPlanStepper(currentStep: state.currentStep),
            Gap(24.h),
            CreateCompensationPlanStepBody(currentStep: state.currentStep),
            Gap(48.h),
          ],
        ),
      ),
    );
  }
}
