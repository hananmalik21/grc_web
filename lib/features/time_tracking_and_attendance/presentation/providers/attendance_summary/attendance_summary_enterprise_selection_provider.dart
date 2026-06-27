import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'attendance_summary_enterprise_provider.dart';
import 'attendance_summary_org_structure_provider.dart';

final attendanceSummaryEnterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<EnterpriseSelectionNotifier, EnterpriseSelectionState, String>((ref, structureId) {
      final enterpriseId = ref.watch(attendanceSummaryEnterpriseIdProvider);
      final orgState = ref.watch(attendanceSummaryOrgStructureNotifierProvider);
      final levels = orgState.orgStructure?.activeLevels ?? <OrgStructureLevel>[];

      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: levels,
        structureId: structureId,
        tenantId: enterpriseId,
      );
    });
