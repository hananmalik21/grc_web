import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_org_structures_by_enterprise_id_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseOrgStructureState {
  final OrgStructure? orgStructure;
  final List<OrgStructure> allStructures;
  final bool isLoading;
  final bool hasAttemptedLoad;
  final String? error;

  const EnterpriseOrgStructureState({
    this.orgStructure,
    this.allStructures = const [],
    this.isLoading = false,
    this.hasAttemptedLoad = false,
    this.error,
  });

  EnterpriseOrgStructureState copyWith({
    OrgStructure? orgStructure,
    List<OrgStructure>? allStructures,
    bool? isLoading,
    bool? hasAttemptedLoad,
    String? error,
  }) {
    return EnterpriseOrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      allStructures: allStructures ?? this.allStructures,
      isLoading: isLoading ?? this.isLoading,
      hasAttemptedLoad: hasAttemptedLoad ?? this.hasAttemptedLoad,
      error: error,
    );
  }
}

class EnterpriseOrgStructureNotifier extends StateNotifier<EnterpriseOrgStructureState> {
  final GetOrgStructuresByEnterpriseIdUseCase getOrgStructuresByEnterpriseIdUseCase;
  int? _currentEnterpriseId;

  EnterpriseOrgStructureNotifier({required this.getOrgStructuresByEnterpriseIdUseCase})
    : super(const EnterpriseOrgStructureState());

  Future<void> fetchOrgStructureByEnterpriseId(int enterpriseId) async {
    if (state.isLoading) return;
    if (_currentEnterpriseId == enterpriseId && state.hasAttemptedLoad) {
      return;
    }

    _currentEnterpriseId = enterpriseId;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final structures = await getOrgStructuresByEnterpriseIdUseCase(enterpriseId);

      state = state.copyWith(orgStructure: null, allStructures: structures, isLoading: false, hasAttemptedLoad: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), hasAttemptedLoad: true);
    }
  }

  void selectStructure(String structureId) {
    final structure = state.allStructures.firstWhere((s) => s.structureId == structureId);
    state = state.copyWith(orgStructure: structure);
  }

  void reset() {
    _currentEnterpriseId = null;
    state = const EnterpriseOrgStructureState();
  }

  void setStructureDirectly(OrgStructure structure) {
    state = state.copyWith(orgStructure: structure, allStructures: [structure], isLoading: false);
  }

  List<OrgStructureLevel> get activeLevels => state.orgStructure?.activeLevels ?? [];
}

final enterpriseOrgStructureNotifierProvider =
    StateNotifierProvider.family<EnterpriseOrgStructureNotifier, EnterpriseOrgStructureState, int>((ref, enterpriseId) {
      return EnterpriseOrgStructureNotifier(
        getOrgStructuresByEnterpriseIdUseCase: ref.watch(getOrgStructuresByEnterpriseIdUseCaseProvider),
      );
    });
