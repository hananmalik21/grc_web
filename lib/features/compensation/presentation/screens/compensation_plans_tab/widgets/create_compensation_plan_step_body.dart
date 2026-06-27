import 'package:flutter/material.dart';

import 'create_compensation_plan_assignment_step.dart';
import 'create_compensation_plan_components_step.dart';
import 'create_compensation_plan_details_step.dart';
import 'create_compensation_plan_eligibility_step.dart';
import 'create_compensation_plan_placeholder_step.dart';

class CreateCompensationPlanStepBody extends StatelessWidget {
  final int currentStep;

  const CreateCompensationPlanStepBody({super.key, required this.currentStep});

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
        return const CreateCompensationPlanDetailsStep(key: ValueKey(0));
      case 1:
        return const CreateCompensationPlanComponentsStep(key: ValueKey(1));
      case 2:
        return const CreateCompensationPlanEligibilityStep(key: ValueKey(2));
      case 3:
        return const CreateCompensationPlanPlaceholderStep(
          key: ValueKey(3),
          title: 'Approval Workflow',
          subtitle: 'Set approvers and plan governance rules.',
        );
      case 4:
        return const CreateCompensationPlanAssignmentStep(key: ValueKey(4));
      case 5:
        return const CreateCompensationPlanPlaceholderStep(
          key: ValueKey(5),
          title: 'Advanced Settings',
          subtitle: 'Finalize integrations and administrative options.',
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
