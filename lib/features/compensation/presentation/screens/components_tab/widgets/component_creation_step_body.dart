import 'package:grc/features/compensation/presentation/providers/create_new_component_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_creation/advanced_settings_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_creation/basic_information_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_creation/calculation_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_creation/eligibility_tab.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_creation/payroll_accounting_tab.dart';
import 'package:flutter/material.dart';

class ComponentCreationStepBody extends StatelessWidget {
  final CreateNewComponentStep step;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final TextEditingController minController;
  final TextEditingController maxController;
  final TextEditingController formulaNameController;
  final TextEditingController payrollCodeController;
  final TextEditingController glAccountController;
  final TextEditingController costCenterController;
  final TextEditingController displayOrderController;

  const ComponentCreationStepBody({
    super.key,
    required this.step,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.minController,
    required this.maxController,
    required this.formulaNameController,
    required this.payrollCodeController,
    required this.glAccountController,
    required this.costCenterController,
    required this.displayOrderController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey(step),
        child: switch (step) {
          CreateNewComponentStep.basicInformation => BasicInformationStep(
            nameController: nameController,
            codeController: codeController,
            descriptionController: descriptionController,
          ),
          CreateNewComponentStep.calculation => CalculationStep(
            minController: minController,
            maxController: maxController,
            formulaNameController: formulaNameController,
          ),
          CreateNewComponentStep.payrollAccounting => PayrollAccountingStep(
            payrollCodeController: payrollCodeController,
            glAccountController: glAccountController,
            costCenterController: costCenterController,
            displayOrderController: displayOrderController,
          ),
          CreateNewComponentStep.advancedSettings => const AdvancedSettingsStep(),
          CreateNewComponentStep.eligibility => const EligibilityStep(),
        },
      ),
    );
  }
}
