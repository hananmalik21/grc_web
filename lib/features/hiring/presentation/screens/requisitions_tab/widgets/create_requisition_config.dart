import 'package:grc/gen/assets.gen.dart';

class CreateRequisitionStepMeta {
  final String label;
  final String iconPath;

  const CreateRequisitionStepMeta({required this.label, required this.iconPath});
}

class CreateRequisitionConfig {
  CreateRequisitionConfig._();

  static final steps = <CreateRequisitionStepMeta>[
    CreateRequisitionStepMeta(label: 'Basic Info', iconPath: Assets.icons.basicInfoIcon.path),
    CreateRequisitionStepMeta(label: 'Justification', iconPath: Assets.icons.descriptionSectionIcon.path),
    CreateRequisitionStepMeta(label: 'Position Details', iconPath: Assets.icons.positionsIcon.path),
    CreateRequisitionStepMeta(label: 'Skills & Quals', iconPath: Assets.icons.employeeManagement.assignment.path),
    CreateRequisitionStepMeta(label: 'Hiring Team', iconPath: Assets.icons.usersIcon.path),
    CreateRequisitionStepMeta(label: 'Budget & Comp', iconPath: Assets.icons.budgetIcon.path),
  ];
}
