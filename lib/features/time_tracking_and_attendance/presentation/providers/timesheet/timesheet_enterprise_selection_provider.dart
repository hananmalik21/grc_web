import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_org_structure_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timesheetEnterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<EnterpriseSelectionNotifier, EnterpriseSelectionState, String>((ref, structureId) {
      final enterpriseId = ref.watch(timesheetEnterpriseIdProvider);
      final orgState = ref.watch(timesheetOrgStructureNotifierProvider);
      final levels = orgState.orgStructure?.activeLevels ?? [];

      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: levels,
        structureId: structureId,
        tenantId: enterpriseId,
      );
    });
