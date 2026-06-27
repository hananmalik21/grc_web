import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/providers/submit_payroll_flow_provider.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/states/submit_payroll_flow_state.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/steps/flow_details_step.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/steps/parameters_step.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/steps/review_payroll_configuration_step.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SubmitPayrollFlowMainCard extends ConsumerWidget {
  const SubmitPayrollFlowMainCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(submitPayrollFlowProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.grayBorderDark.withValues(alpha: 0.12)),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubmitPayrollFlowStepper(currentStep: state.currentStep),
          Gap(24.h),
          _buildStepContent(state.currentStep),
        ],
      ),
    );
  }

  static Widget _buildStepContent(SubmitPayrollFlowStep step) {
    return switch (step) {
      SubmitPayrollFlowStep.flowDetails => const FlowDetailsStep(),
      SubmitPayrollFlowStep.parameters => const ParametersStep(),
      SubmitPayrollFlowStep.review => const ReviewPayrollConfigurationStep(),
    };
  }
}
