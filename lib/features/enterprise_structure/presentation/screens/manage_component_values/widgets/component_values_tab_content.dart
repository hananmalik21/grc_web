import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/business_unit_values_view.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/company_values_view.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/level_org_units_view.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/component_values_tree_view.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/department_values_view.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/division_values_view.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/section_values_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentValuesTabContent extends ConsumerWidget {
  const ComponentValuesTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState = ref.watch(manageComponentValuesScreenProvider);
    final selectedLevel = screenState.selectedLevel;
    final selectedLevelCode = screenState.selectedLevelCode;

    if (screenState.isTreeView && selectedLevel == null) {
      return const ComponentValuesTreeView();
    }

    if (selectedLevel != null) {
      return _buildLevelView(selectedLevel, selectedLevelCode);
    }

    return const ComponentValuesTreeView();
  }

  Widget _buildLevelView(OrganizationLevel level, String levelCode) {
    switch (level) {
      case OrganizationLevel.company:
        return const CompanyValuesView();
      case OrganizationLevel.division:
        return const DivisionValuesView();
      case OrganizationLevel.businessUnit:
        return const BusinessUnitValuesView();
      case OrganizationLevel.department:
        return const DepartmentValuesView();
      case OrganizationLevel.section:
        return const SectionValuesView();
      case OrganizationLevel.unknown:
        return LevelOrgUnitsView(
          level: OrganizationLevel.unknown,
          searchHint: 'Search org units...',
          levelCodeOverride: levelCode.isNotEmpty ? levelCode : null,
        );
    }
  }
}
