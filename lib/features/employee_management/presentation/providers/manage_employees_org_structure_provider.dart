import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageEmployeesOrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final bool hasAttemptedLoad;
  final String? error;

  const ManageEmployeesOrgStructureState({
    this.orgStructure,
    this.isLoading = false,
    this.hasAttemptedLoad = false,
    this.error,
  });

  List<OrgStructureLevel> get activeLevels => orgStructure?.activeLevels ?? [];

  ManageEmployeesOrgStructureState copyWith({
    OrgStructure? orgStructure,
    bool? isLoading,
    bool? hasAttemptedLoad,
    String? error,
  }) {
    return ManageEmployeesOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      hasAttemptedLoad: hasAttemptedLoad ?? this.hasAttemptedLoad,
      error: error ?? this.error,
    );
  }
}

class ManageEmployeesOrgStructureNotifier extends StateNotifier<ManageEmployeesOrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;

  ManageEmployeesOrgStructureNotifier({required this.getActiveOrgStructureLevelsUseCase})
    : super(const ManageEmployeesOrgStructureState());

  Future<void> fetchLevelsByEnterpriseId(int enterpriseId) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final orgStructure = await getActiveOrgStructureLevelsUseCase(tenantId: enterpriseId);
      state = state.copyWith(orgStructure: orgStructure, isLoading: false, hasAttemptedLoad: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, hasAttemptedLoad: true, error: e.toString());
    }
  }

  void reset() {
    state = const ManageEmployeesOrgStructureState();
  }
}

final manageEmployeesOrgStructureNotifierProvider =
    StateNotifierProvider.family<ManageEmployeesOrgStructureNotifier, ManageEmployeesOrgStructureState, int>((
      ref,
      enterpriseId,
    ) {
      return ManageEmployeesOrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: ref.read(employeeGetActiveOrgStructureLevelsUseCaseProvider),
      );
    });
