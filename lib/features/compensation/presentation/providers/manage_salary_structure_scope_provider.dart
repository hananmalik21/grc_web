import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_selection_notifier.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final manageSalaryStructureOrgStructureNotifierProvider =
    StateNotifierProvider.autoDispose<OrgStructureNotifier, OrgStructureState>((ref) {
      final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
      return OrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: ref.read(getActiveOrgStructureLevelsUseCaseProvider),
        tenantId: tenantId,
      );
    });

final manageSalaryStructureScopedLevelsProvider = Provider.autoDispose<List<OrgStructureLevel>>((ref) {
  final levels = ref.watch(manageSalaryStructureOrgStructureNotifierProvider).orgStructure?.activeLevels ?? const [];
  final businessUnitIndex = levels.indexWhere((level) => level.levelCode.toUpperCase() == 'BUSINESS_UNIT');
  if (businessUnitIndex == -1) return levels;
  return levels.sublist(0, businessUnitIndex + 1);
});

final manageSalaryStructureEnterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<
      ManageSalaryStructureEnterpriseSelectionNotifier,
      ManageSalaryStructureEnterpriseSelectionState,
      ({List<OrgStructureLevel> levels, String structureId, String? companyId})
    >((ref, params) {
      final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
      return ManageSalaryStructureEnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: params.levels,
        structureId: params.structureId,
        tenantId: tenantId,
      );
    });
