import 'package:grc/gen/assets.gen.dart';

class CreateCompensationPlanStepMeta {
  final String label;
  final String iconPath;

  const CreateCompensationPlanStepMeta({required this.label, required this.iconPath});
}

class CreateCompensationPlanConfig {
  CreateCompensationPlanConfig._();

  static const statuses = <String>['ACTIVE', 'INACTIVE'];

  static final steps = <CreateCompensationPlanStepMeta>[
    CreateCompensationPlanStepMeta(label: 'Plan Details', iconPath: Assets.icons.registrationCardIcon.path),
    CreateCompensationPlanStepMeta(label: 'Components', iconPath: Assets.icons.compensation.box.path),
    CreateCompensationPlanStepMeta(label: 'Eligibility Rules', iconPath: Assets.icons.employeesSmallIcon.path),
    CreateCompensationPlanStepMeta(label: 'Approval Workflow', iconPath: Assets.icons.activeCheckIcon.path),
    CreateCompensationPlanStepMeta(label: 'Employee Assignments', iconPath: Assets.icons.employeesSmallIcon.path),
    CreateCompensationPlanStepMeta(label: 'Advanced Settings', iconPath: Assets.icons.manageEnterpriseIcon.path),
  ];
}
