import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeOrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final bool hasAttemptedLoad;
  final String? error;

  const AddEmployeeOrgStructureState({
    this.orgStructure,
    this.isLoading = false,
    this.hasAttemptedLoad = false,
    this.error,
  });

  List<OrgStructureLevel> get activeLevels => orgStructure?.activeLevels ?? [];

  AddEmployeeOrgStructureState copyWith({
    OrgStructure? orgStructure,
    bool? isLoading,
    bool? hasAttemptedLoad,
    String? error,
  }) {
    return AddEmployeeOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      hasAttemptedLoad: hasAttemptedLoad ?? this.hasAttemptedLoad,
      error: error,
    );
  }
}

class AddEmployeeOrgStructureNotifier extends StateNotifier<AddEmployeeOrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;

  AddEmployeeOrgStructureNotifier({required this.getActiveOrgStructureLevelsUseCase})
    : super(const AddEmployeeOrgStructureState());

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
}

final addEmployeeOrgStructureNotifierProvider =
    StateNotifierProvider.family<AddEmployeeOrgStructureNotifier, AddEmployeeOrgStructureState, int>((
      ref,
      enterpriseId,
    ) {
      return AddEmployeeOrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: ref.read(employeeGetActiveOrgStructureLevelsUseCaseProvider),
      );
    });
