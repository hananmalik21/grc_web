import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_org_structure_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final overtimeEnterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<EnterpriseSelectionNotifier, EnterpriseSelectionState, String>((ref, structureId) {
      final enterpriseId = ref.watch(overtimeEnterpriseIdProvider);
      final orgState = ref.watch(overtimeOrgStructureNotifierProvider);
      final levels = orgState.orgStructure?.activeLevels ?? <OrgStructureLevel>[];

      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: levels,
        structureId: structureId,
        tenantId: enterpriseId,
      );
    });
