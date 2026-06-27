import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/features/security_manager/data/config/roles_management/job_role_form_config.dart';

class JobRoleStepperConfig {
  static List<StepperStepConfig> steps({required int dutyCount, required int dataCount, required int inheritedCount}) {
    return [
      StepperStepConfig(assetPath: JobRoleFormConfig.basicInfoIconPath, label: 'Basic Information'),
      StepperStepConfig(assetPath: JobRoleFormConfig.dutyRolesIconPath, label: 'Duty Roles ($dutyCount)'),
      StepperStepConfig(assetPath: JobRoleFormConfig.dataRolesIconPath, label: 'Data Roles ($dataCount)'),
      StepperStepConfig(
        assetPath: JobRoleFormConfig.inheritedRolesIconPath,
        label: 'Inherited Roles${inheritedCount > 0 ? ' ($inheritedCount)' : ''}',
      ),
    ];
  }
}
