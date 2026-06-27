import 'package:grc/features/compensation/presentation/widgets/manage_salary_structure/creation/advanced_settings_step.dart';
import 'package:grc/features/compensation/presentation/widgets/manage_salary_structure/creation/basic_info_step.dart';
import 'package:grc/features/compensation/presentation/widgets/manage_salary_structure/creation/components_step.dart';
import 'package:grc/features/compensation/presentation/widgets/manage_salary_structure/creation/financial_details_step.dart';
import 'package:grc/features/compensation/presentation/widgets/manage_salary_structure/creation/scope_assignment_step.dart';
import 'package:flutter/material.dart';

class SalaryStructureCreationStepBody extends StatelessWidget {
  final int currentStep;

  const SalaryStructureCreationStepBody({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
      child: _stepWidget(currentStep),
    );
  }

  Widget _stepWidget(int step) {
    switch (step) {
      case 0:
        return const BasicInfoStep(key: ValueKey(0));
      case 1:
        return const ScopeAssignmentStep(key: ValueKey(1));
      case 2:
        return const ComponentsStep(key: ValueKey(2));
      case 3:
        return const FinancialDetailsStep(key: ValueKey(3));
      case 4:
        return const AdvancedSettingsStep(key: ValueKey(4));
      default:
        return const SizedBox.shrink();
    }
  }
}
