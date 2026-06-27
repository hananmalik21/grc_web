import 'package:grc/gen/assets.gen.dart';

class EnterpriseStructureTabItem {
  final String id;
  final String labelKey;
  final String iconPath;

  const EnterpriseStructureTabItem({required this.id, required this.labelKey, required this.iconPath});
}

class EnterpriseStructureTabsConfig {
  EnterpriseStructureTabsConfig._();

  static List<EnterpriseStructureTabItem> getTabs() {
    return [
      EnterpriseStructureTabItem(
        id: 'manageEnterpriseStructure',
        labelKey: 'manageEnterpriseStructure',
        iconPath: Assets.icons.manageEnterpriseIcon.path,
      ),
      EnterpriseStructureTabItem(
        id: 'manageComponentValues',
        labelKey: 'manageComponentValues',
        iconPath: Assets.icons.manageComponentIcon.path,
      ),
      EnterpriseStructureTabItem(id: 'company', labelKey: 'company', iconPath: Assets.icons.companyIcon.path),
      EnterpriseStructureTabItem(id: 'division', labelKey: 'division', iconPath: Assets.icons.divisionIcon.path),
      EnterpriseStructureTabItem(
        id: 'businessUnit',
        labelKey: 'businessUnit',
        iconPath: Assets.icons.businessUnitIcon.path,
      ),
      EnterpriseStructureTabItem(id: 'department', labelKey: 'department', iconPath: Assets.icons.departmentIcon.path),
      EnterpriseStructureTabItem(id: 'section', labelKey: 'section', iconPath: Assets.icons.sectionIcon.path),
    ];
  }
}
