import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgStructureState {
  final OrgStructure? orgStructure;
  final bool isLoading;
  final String? error;

  const OrgStructureState({this.orgStructure, this.isLoading = false, this.error});

  OrgStructureState copyWith({OrgStructure? orgStructure, bool? isLoading, String? error}) {
    return OrgStructureState(
      orgStructure: orgStructure ?? this.orgStructure,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OrgStructureNotifier extends StateNotifier<OrgStructureState> {
  final GetActiveOrgStructureLevelsUseCase getActiveOrgStructureLevelsUseCase;
  final int? tenantId;

  OrgStructureNotifier({required this.getActiveOrgStructureLevelsUseCase, this.tenantId})
    : super(const OrgStructureState());

  Future<void> fetchOrgStructureLevels() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orgStructure = await getActiveOrgStructureLevelsUseCase(tenantId: tenantId);
      state = state.copyWith(orgStructure: orgStructure, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Get active levels sorted by display order
  List<OrgStructureLevel> get activeLevels => state.orgStructure?.activeLevels ?? [];

  /// Check if a specific level code is active
  bool hasLevel(String levelCode) {
    return activeLevels.any((level) => level.levelCode.toUpperCase() == levelCode.toUpperCase());
  }

  /// Get level by code
  OrgStructureLevel? getLevelByCode(String levelCode) {
    try {
      return activeLevels.firstWhere((level) => level.levelCode.toUpperCase() == levelCode.toUpperCase());
    } catch (e) {
      return null;
    }
  }
}
