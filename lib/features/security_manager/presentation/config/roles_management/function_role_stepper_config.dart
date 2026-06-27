import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/features/security_manager/data/config/roles_management/function_role_form_config.dart';

class FunctionRoleStepperConfig {
  static List<StepperStepConfig> steps({required int functionsCount, required int inheritedCount}) {
    return [
      StepperStepConfig(
        assetPath: FunctionRoleFormConfig.basicInfoIconPath,
        label: FunctionRoleFormConfig.stepLabels[0],
      ),
      StepperStepConfig(
        assetPath: FunctionRoleFormConfig.functionsIconPath,
        label: functionsCount > 0
            ? '${FunctionRoleFormConfig.stepLabels[1]} ($functionsCount)'
            : FunctionRoleFormConfig.stepLabels[1],
      ),
      StepperStepConfig(
        assetPath: FunctionRoleFormConfig.inheritedRolesIconPath,
        label: inheritedCount > 0
            ? '${FunctionRoleFormConfig.stepLabels[2]} ($inheritedCount)'
            : FunctionRoleFormConfig.stepLabels[2],
      ),
    ];
  }
}
