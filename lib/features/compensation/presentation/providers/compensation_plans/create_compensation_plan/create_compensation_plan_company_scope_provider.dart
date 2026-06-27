import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompensationPlanCompanyScopeSelectionState {
  static const String companyLevelCode = 'COMPANY';
  static const String businessUnitLevelCode = 'BUSINESS_UNIT';
  final List<String> selectedCompanyIds;
  final Map<String, String> selectedCompanyNames;
  final Map<String, Map<String, List<String>>> selectedOrgUnitIdsByCompany;

  CompensationPlanCompanyScopeSelectionState({
    this.selectedCompanyIds = const [],
    this.selectedCompanyNames = const {},
    this.selectedOrgUnitIdsByCompany = const {},
  });

  CompensationPlanCompanyScopeSelectionState copyWith({
    List<String>? selectedCompanyIds,
    Map<String, String>? selectedCompanyNames,
    Map<String, Map<String, List<String>>>? selectedOrgUnitIdsByCompany,
  }) {
    return CompensationPlanCompanyScopeSelectionState(
      selectedCompanyIds: selectedCompanyIds ?? this.selectedCompanyIds,
      selectedCompanyNames: selectedCompanyNames ?? this.selectedCompanyNames,
      selectedOrgUnitIdsByCompany: selectedOrgUnitIdsByCompany ?? this.selectedOrgUnitIdsByCompany,
    );
  }

  factory CompensationPlanCompanyScopeSelectionState.fromPlanBusinessUnits(List<PlanBusinessUnit> businessUnits) {
    if (businessUnits.isEmpty) return CompensationPlanCompanyScopeSelectionState();

    final selectedCompanyIds = <String>[];
    final selectedOrgUnitIdsByCompany = <String, Map<String, List<String>>>{};

    void ensureCompany(String companyId) {
      if (companyId.isEmpty || selectedCompanyIds.contains(companyId)) return;
      selectedCompanyIds.add(companyId);
      selectedOrgUnitIdsByCompany.putIfAbsent(
        companyId,
        () => {
          companyLevelCode: [companyId],
        },
      );
    }

    for (final entry in businessUnits) {
      final orgUnitId = entry.orgUnitId.trim();
      if (orgUnitId.isEmpty) continue;

      final parentCompanyId = entry.orgUnit?.parentOrgUnitId?.trim() ?? '';
      final isBusinessUnitUnderCompany = parentCompanyId.isNotEmpty && parentCompanyId != orgUnitId;

      if (isBusinessUnitUnderCompany) {
        ensureCompany(parentCompanyId);
        final perCompany = selectedOrgUnitIdsByCompany[parentCompanyId]!;
        final buIds = List<String>.from(perCompany[businessUnitLevelCode] ?? const []);
        if (!buIds.contains(orgUnitId)) {
          buIds.add(orgUnitId);
        }
        perCompany[businessUnitLevelCode] = buIds;
        continue;
      }

      ensureCompany(orgUnitId);
    }

    if (selectedCompanyIds.isEmpty) return CompensationPlanCompanyScopeSelectionState();

    return CompensationPlanCompanyScopeSelectionState(
      selectedCompanyIds: selectedCompanyIds,
      selectedOrgUnitIdsByCompany: selectedOrgUnitIdsByCompany,
    );
  }

  List<String> extractOrgUnitIdsForSubmission() {
    final ids = <String>{};

    for (final companyId in selectedCompanyIds) {
      final perCompany = selectedOrgUnitIdsByCompany[companyId] ?? const {};
      final buIds = (perCompany[businessUnitLevelCode] ?? const <String>[])
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty);

      if (buIds.isNotEmpty) {
        ids.addAll(buIds);
        continue;
      }

      final companyOrgUnitIds = (perCompany[companyLevelCode] ?? const <String>[])
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty);
      if (companyOrgUnitIds.isNotEmpty) {
        ids.add(companyOrgUnitIds.first);
        continue;
      }

      if (companyId.trim().isNotEmpty) {
        ids.add(companyId.trim());
      }
    }

    return ids.toList();
  }
}

class CompensationPlanCompanyScopeSelectionNotifier extends StateNotifier<CompensationPlanCompanyScopeSelectionState> {
  CompensationPlanCompanyScopeSelectionNotifier() : super(CompensationPlanCompanyScopeSelectionState());

  CompensationPlanCompanyScopeSelectionNotifier.withInitialState(super.initialState);

  void updateOrgUnitSelection({
    required String companyId,
    required String levelCode,
    required List<String> selectedIds,
  }) {
    final current = Map<String, List<String>>.from(state.selectedOrgUnitIdsByCompany[companyId] ?? const {});
    current[levelCode] = selectedIds;

    final updatedMap = Map<String, Map<String, List<String>>>.from(state.selectedOrgUnitIdsByCompany);
    updatedMap[companyId] = current;

    state = state.copyWith(selectedOrgUnitIdsByCompany: updatedMap);
  }

  void updateCompanySelection({
    required List<String> companyIds,
    required String companyLevelCode,
    Map<String, String>? companyNamesById,
  }) {
    final updatedMap = Map<String, Map<String, List<String>>>.from(state.selectedOrgUnitIdsByCompany);
    final updatedNames = Map<String, String>.from(state.selectedCompanyNames);

    final toRemove = updatedMap.keys.where((id) => !companyIds.contains(id)).toList();
    for (final id in toRemove) {
      updatedMap.remove(id);
      updatedNames.remove(id);
    }

    for (final id in companyIds) {
      updatedMap.putIfAbsent(
        id,
        () => {
          companyLevelCode: <String>[id],
        },
      );
      final incomingName = companyNamesById?[id];
      if (incomingName != null && incomingName.trim().isNotEmpty) {
        updatedNames[id] = incomingName;
      }
    }

    state = state.copyWith(
      selectedCompanyIds: companyIds,
      selectedCompanyNames: updatedNames,
      selectedOrgUnitIdsByCompany: updatedMap,
    );
  }

  void upsertCompanyName({required String companyId, required String companyName}) {
    if (companyName.trim().isEmpty) return;
    final updatedNames = Map<String, String>.from(state.selectedCompanyNames);
    updatedNames[companyId] = companyName;
    state = state.copyWith(selectedCompanyNames: updatedNames);
  }

  void reset() {
    state = CompensationPlanCompanyScopeSelectionState();
  }

  List<String> getSelectedOrgUnits(String companyId, String levelCode) {
    return state.selectedOrgUnitIdsByCompany[companyId]?[levelCode] ?? const [];
  }
}

final compensationPlanCompanyScopeSelectionProvider =
    StateNotifierProvider<CompensationPlanCompanyScopeSelectionNotifier, CompensationPlanCompanyScopeSelectionState>((
      ref,
    ) {
      return CompensationPlanCompanyScopeSelectionNotifier();
    });
