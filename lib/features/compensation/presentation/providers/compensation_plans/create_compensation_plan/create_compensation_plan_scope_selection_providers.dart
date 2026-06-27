import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_selection_notifier.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_notifier.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final compensationPlanJobFamilyNotifierProvider =
    StateNotifierProvider.autoDispose<JobFamilyNotifier, PaginationState<JobFamily>>((ref) {
      final tenantId = ref.watch(compensationPlansTabEnterpriseIdProvider);
      final notifier = JobFamilyNotifier(
        ref.watch(getJobFamiliesUseCaseProvider),
        ref.watch(createJobFamilyUseCaseProvider),
        tenantId,
      );
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

final compensationPlanGradeNotifierProvider = StateNotifierProvider.autoDispose<GradeNotifier, GradeState>((ref) {
  final tenantId = ref.watch(compensationPlansTabEnterpriseIdProvider);
  final notifier = GradeNotifier(
    ref.watch(getGradesUseCaseProvider),
    ref.watch(createGradeUseCaseProvider),
    ref.watch(deleteGradeUseCaseProvider),
    ref.watch(updateGradeUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final compensationPlanPositionNotifierProvider =
    StateNotifierProvider.autoDispose<PositionNotifier, PaginationState<Position>>((ref) {
      final tenantId = ref.watch(compensationPlansTabEnterpriseIdProvider);
      final notifier = PositionNotifier(
        ref.watch(getPositionsUseCaseProvider),
        ref.watch(createPositionUseCaseProvider),
        ref.watch(updatePositionUseCaseProvider),
        ref.watch(deletePositionUseCaseProvider),
        tenantId,
      );
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

final compensationPlanOrgStructureNotifierProvider =
    StateNotifierProvider.autoDispose<OrgStructureNotifier, OrgStructureState>((ref) {
      final tenantId = ref.watch(compensationPlansTabEnterpriseIdProvider);
      return OrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: ref.read(getActiveOrgStructureLevelsUseCaseProvider),
        tenantId: tenantId,
      );
    });

final compensationPlanScopedLevelsProvider = Provider.autoDispose<List<OrgStructureLevel>>((ref) {
  final levels = ref.watch(compensationPlanOrgStructureNotifierProvider).orgStructure?.activeLevels ?? const [];
  final businessUnitIndex = levels.indexWhere((level) => level.levelCode.toUpperCase() == 'BUSINESS_UNIT');
  if (businessUnitIndex == -1) return levels;
  return levels.sublist(0, businessUnitIndex + 1);
});

final compensationPlanEnterpriseSelectionNotifierProvider =
    StateNotifierProvider.family<
      ManageSalaryStructureEnterpriseSelectionNotifier,
      ManageSalaryStructureEnterpriseSelectionState,
      ({List<OrgStructureLevel> levels, String structureId, String? companyId})
    >((ref, params) {
      final tenantId = ref.watch(compensationPlansTabEnterpriseIdProvider);
      return ManageSalaryStructureEnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: params.levels,
        structureId: params.structureId,
        tenantId: tenantId,
      );
    });
