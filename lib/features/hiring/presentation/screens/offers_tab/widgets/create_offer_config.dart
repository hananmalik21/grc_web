import 'package:grc/gen/assets.gen.dart';

class CreateOfferStepMeta {
  final String label;
  final String iconPath;

  const CreateOfferStepMeta({required this.label, required this.iconPath});
}

class CreateOfferConfig {
  CreateOfferConfig._();

  static final steps = <CreateOfferStepMeta>[
    CreateOfferStepMeta(label: 'Basic Details', iconPath: Assets.icons.basicInfoIcon.path),
    CreateOfferStepMeta(label: 'Compensation', iconPath: Assets.icons.budgetIcon.path),
    CreateOfferStepMeta(label: 'Benefits', iconPath: Assets.icons.websiteIcon.path),
    CreateOfferStepMeta(label: 'Terms & Conditions', iconPath: Assets.icons.descriptionSectionIcon.path),
  ];
}
