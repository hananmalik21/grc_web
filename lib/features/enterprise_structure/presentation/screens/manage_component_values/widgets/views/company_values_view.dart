import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/views/level_org_units_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyValuesView extends ConsumerWidget {
  const CompanyValuesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LevelOrgUnitsView(level: OrganizationLevel.company, searchHint: 'Search companies...');
  }
}
