import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:grc/features/enterprise_structure/domain/models/component_value.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_tree_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ComponentType _levelToComponentType(OrganizationLevel level) {
  switch (level) {
    case OrganizationLevel.company:
      return ComponentType.company;
    case OrganizationLevel.division:
      return ComponentType.division;
    case OrganizationLevel.businessUnit:
      return ComponentType.businessUnit;
    case OrganizationLevel.department:
      return ComponentType.department;
    case OrganizationLevel.section:
      return ComponentType.section;
    case OrganizationLevel.unknown:
      return ComponentType.company;
  }
}

void _countNodes(OrgUnitTreeNode node, Map<ComponentType, int> counts) {
  final type = _levelToComponentType(node.level);
  counts[type] = (counts[type] ?? 0) + 1;
  for (final child in node.children) {
    _countNodes(child, counts);
  }
}

final manageComponentValuesStatCountsProvider = Provider<Map<ComponentType, int>>((ref) {
  final treeState = ref.watch(orgUnitsTreeProvider);
  final tree = treeState.tree.valueOrNull;

  if (tree == null) {
    return const {
      ComponentType.company: 0,
      ComponentType.division: 0,
      ComponentType.businessUnit: 0,
      ComponentType.department: 0,
      ComponentType.section: 0,
    };
  }

  final counts = <ComponentType, int>{
    ComponentType.company: 0,
    ComponentType.division: 0,
    ComponentType.businessUnit: 0,
    ComponentType.department: 0,
    ComponentType.section: 0,
  };

  for (final node in tree.tree) {
    _countNodes(node, counts);
  }

  return counts;
});
