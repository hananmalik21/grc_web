import 'package:grc/features/employee_management/presentation/providers/manage_employees_org_structure_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final manageEmployeesFilterOrgParamProvider =
    Provider.family<({List<OrgStructureLevel> levels, String structureId})?, int>((ref, enterpriseId) {
      final state = ref.watch(manageEmployeesOrgStructureNotifierProvider(enterpriseId));
      final org = state.orgStructure;
      if (org == null) return null;
      return (levels: org.activeLevels, structureId: org.structureId);
    });
