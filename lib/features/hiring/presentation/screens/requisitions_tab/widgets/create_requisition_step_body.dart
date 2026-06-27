import 'package:flutter/material.dart';
import 'create_requisition_basic_info_step.dart';
import 'create_requisition_justification_step.dart';
import 'create_requisition_position_details_step.dart';
import 'create_requisition_skills_quals_step.dart';
import 'create_requisition_hiring_team_step.dart';
import 'create_requisition_budget_comp_step.dart';

class CreateRequisitionStepBody extends StatelessWidget {
  final int currentStep;

  const CreateRequisitionStepBody({super.key, required this.currentStep});

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
        return const CreateRequisitionBasicInfoStep(key: ValueKey(0));
      case 1:
        return const CreateRequisitionJustificationStep(key: ValueKey(1));
      case 2:
        return const CreateRequisitionPositionDetailsStep(key: ValueKey(2));
      case 3:
        return const CreateRequisitionSkillsQualsStep(key: ValueKey(3));
      case 4:
        return const CreateRequisitionHiringTeamStep(key: ValueKey(4));
      case 5:
        return const CreateRequisitionBudgetCompStep(key: ValueKey(5));
      default:
        return const SizedBox.shrink();
    }
  }
}
