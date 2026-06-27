import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_api_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_component_frequency_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_scope_selection_providers.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_config.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_header.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_step_body.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateCompensationPlanScreen extends StatelessWidget {
  static const String routeName = 'compensation-plans-create';

  const CreateCompensationPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: _CreateCompensationPlanScreenBody());
  }
}

class _CreateCompensationPlanScreenBody extends ConsumerWidget {
  const _CreateCompensationPlanScreenBody();

  void _resetOrgState(WidgetRef ref) {
    ref.read(compensationPlanCompanyScopeSelectionProvider.notifier).reset();
    ref.invalidate(compensationPlanEnterpriseSelectionNotifierProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);
    final createApiState = ref.watch(createCompensationPlanApiProvider);
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
              canGoBack: canGoBack,
              isLastStep: isLastStep,
              isSubmitting: createApiState.isLoading,
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
                  if (error != null) {
                    ToastService.error(context, error);
                  }
                  return;
                }

                if (createApiState.isLoading) {
                  return;
                }

                ref.read(createCompensationPlanApiProvider.notifier).submit().then((apiError) {
                  if (!context.mounted) return;

                  if (apiError != null) {
                    ToastService.error(context, apiError);
                    return;
                  }

                  _resetOrgState(ref);
                  ToastService.success(context, 'Compensation plan created successfully!');
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
