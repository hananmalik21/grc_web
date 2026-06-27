import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeManagementActiveOrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final String? error;

  const TimeManagementActiveOrgStructureState({this.orgStructure, this.isLoading = false, this.error});

  TimeManagementActiveOrgStructureState copyWith({OrgStructure? orgStructure, bool? isLoading, String? error}) {
    return TimeManagementActiveOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TimeManagementActiveOrgStructureNotifier extends StateNotifier<TimeManagementActiveOrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;
  final int? enterpriseId;

  TimeManagementActiveOrgStructureNotifier({required this.getActiveOrgStructureLevelsUseCase, this.enterpriseId})
    : super(const TimeManagementActiveOrgStructureState());

  Future<void> fetchActiveOrgStructure() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orgStructure = await getActiveOrgStructureLevelsUseCase(tenantId: enterpriseId);
      state = state.copyWith(orgStructure: orgStructure, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final scheduleAssignmentActiveOrgStructureProvider =
    StateNotifierProvider.family<TimeManagementActiveOrgStructureNotifier, TimeManagementActiveOrgStructureState, int>((
      ref,
      enterpriseId,
    ) {
      return TimeManagementActiveOrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: ref.read(getActiveOrgStructureLevelsUseCaseProvider),
        enterpriseId: enterpriseId,
      );
    });

final scheduleAssignmentEnterpriseSelectionProvider =
    StateNotifierProvider.family<
      EnterpriseSelectionNotifier,
      EnterpriseSelectionState,
      ({List<OrgStructureLevel> levels, String structureId, int enterpriseId})
    >((ref, params) {
      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: params.levels,
        structureId: params.structureId,
        tenantId: params.enterpriseId,
      );
    });
