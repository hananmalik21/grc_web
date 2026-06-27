import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_org_structure_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceEnterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<EnterpriseSelectionNotifier, EnterpriseSelectionState, String>((ref, structureId) {
      final enterpriseId = ref.watch(attendanceEnterpriseIdProvider);
      final orgState = ref.watch(attendanceOrgStructureNotifierProvider);
      final levels = orgState.orgStructure?.activeLevels ?? <OrgStructureLevel>[];

      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: levels,
        structureId: structureId,
        tenantId: enterpriseId,
      );
    });
