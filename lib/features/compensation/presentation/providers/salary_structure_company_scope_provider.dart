import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyScopeSelectionState {
  static const String companyLevelCode = 'COMPANY';
  static const String businessUnitLevelCode = 'BUSINESS_UNIT';

  final List<String> selectedCompanyIds;
  final Map<String, String> selectedCompanyNames;
  final Map<String, Map<String, List<String>>> selectedOrgUnitIdsByCompany;

  CompanyScopeSelectionState({
    this.selectedCompanyIds = const [],
    this.selectedCompanyNames = const {},
    this.selectedOrgUnitIdsByCompany = const {},
  });

  CompanyScopeSelectionState copyWith({
    List<String>? selectedCompanyIds,
    Map<String, String>? selectedCompanyNames,
    Map<String, Map<String, List<String>>>? selectedOrgUnitIdsByCompany,
  }) {
    return CompanyScopeSelectionState(
      selectedCompanyIds: selectedCompanyIds ?? this.selectedCompanyIds,
      selectedCompanyNames: selectedCompanyNames ?? this.selectedCompanyNames,
      selectedOrgUnitIdsByCompany: selectedOrgUnitIdsByCompany ?? this.selectedOrgUnitIdsByCompany,
    );
  }

  factory CompanyScopeSelectionState.fromOrgScopeMap(Map<String, List<String>> companyToOrgUnitsMap) {
    return CompanyScopeSelectionState.fromCompanyScopeRestore(companyToBusinessUnitIds: companyToOrgUnitsMap);
  }

  factory CompanyScopeSelectionState.fromCompanyScopeRestore({
    required Map<String, List<String>> companyToBusinessUnitIds,
    Map<String, String> companyNamesById = const {},
  }) {
    if (companyToBusinessUnitIds.isEmpty) return CompanyScopeSelectionState();

    final selectedCompanyIds = <String>[];
    final selectedOrgUnitIdsByCompany = <String, Map<String, List<String>>>{};
    final selectedCompanyNames = Map<String, String>.from(companyNamesById);

    for (final entry in companyToBusinessUnitIds.entries) {
      final companyId = entry.key.trim();
      if (companyId.isEmpty) continue;

      selectedCompanyIds.add(companyId);
      final businessUnitIds = entry.value.map((id) => id.trim()).where((id) => id.isNotEmpty).toList();
      selectedOrgUnitIdsByCompany[companyId] = {
        companyLevelCode: [companyId],
        if (businessUnitIds.isNotEmpty) businessUnitLevelCode: businessUnitIds,
      };
    }

    if (selectedCompanyIds.isEmpty) return CompanyScopeSelectionState();

    return CompanyScopeSelectionState(
      selectedCompanyIds: selectedCompanyIds,
      selectedCompanyNames: selectedCompanyNames,
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

class CompanyScopeSelectionNotifier extends StateNotifier<CompanyScopeSelectionState> {
  CompanyScopeSelectionNotifier() : super(CompanyScopeSelectionState());

  void applyState(CompanyScopeSelectionState newState) {
    state = newState;
  }

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
    state = CompanyScopeSelectionState();
  }

  List<String> getSelectedOrgUnits(String companyId, String levelCode) {
    return state.selectedOrgUnitIdsByCompany[companyId]?[levelCode] ?? const [];
  }
}

final companyScopeSelectionProvider = StateNotifierProvider<CompanyScopeSelectionNotifier, CompanyScopeSelectionState>((
  ref,
) {
  return CompanyScopeSelectionNotifier();
});
