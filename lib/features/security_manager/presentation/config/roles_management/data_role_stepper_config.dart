import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';

class DataRoleStepperConfig {
  static List<StepperStepConfig> steps() {
    return [
      StepperStepConfig(assetPath: DataRoleFormConfig.tabsSettingsIconPath, label: 'Basic Information'),
      StepperStepConfig(assetPath: DataRoleFormConfig.tabsBusinessUnitIconPath, label: 'Workforce Structure'),
      StepperStepConfig(assetPath: DataRoleFormConfig.tabsCompanyIconPath, label: 'Enterprise Structure'),
    ];
  }
}
