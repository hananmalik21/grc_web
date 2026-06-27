import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/gen/assets.gen.dart';

HierarchyLevel convertToHierarchyLevel(StructureLevelItem level) {
  final icons = getIconsForLevelCode(level.levelCode);

  return HierarchyLevel(
    id: level.levelId.toString(),
    name: level.levelName,
    icon: icons['icon']!,
    level: level.displayOrder,
    isMandatory: level.isMandatory,
    isActive: level.isActive,
    previewIcon: icons['previewIcon']!,
  );
}

Map<String, String> getIconsForLevelCode(String levelCode) {
  switch (levelCode.toUpperCase()) {
    case 'COMPANY':
    case 'COMP':
      return {'icon': Assets.icons.companyIconSmall.path, 'previewIcon': Assets.icons.companyIconPreview.path};
    case 'DIVISION':
    case 'DIV':
      return {'icon': Assets.icons.divisionIconSmall.path, 'previewIcon': Assets.icons.divisionIconPreview.path};
    case 'BUSINESS_UNIT':
    case 'BUSINESSUNIT':
    case 'BU':
      return {
        'icon': Assets.icons.businessUnitIconSmall.path,
        'previewIcon': Assets.icons.businessUnitIconPreview.path,
      };
    case 'DEPARTMENT':
    case 'DEPT':
      return {'icon': Assets.icons.departmentIconSmall.path, 'previewIcon': Assets.icons.departmentIconPreview.path};
    case 'SECTION':
    case 'SECT':
      return {'icon': Assets.icons.sectionIconSmall.path, 'previewIcon': Assets.icons.sectionIconPreview.path};
    default:
      return {'icon': Assets.icons.companyIconSmall.path, 'previewIcon': Assets.icons.companyIconPreview.path};
  }
}
