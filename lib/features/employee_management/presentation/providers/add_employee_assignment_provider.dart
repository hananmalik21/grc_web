import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LevelSelection {
  final String orgUnitId;
  final String displayNameEn;

  const LevelSelection({required this.orgUnitId, required this.displayNameEn});
}

class AddEmployeeAssignmentState {
  /// Org-structure level code for the business unit picker in assignment step.
  static const String businessUnitLevelCode = 'BUSINESS_UNIT';

  final Map<String, LevelSelection> levelSelections;

  /// Leaf / deepest org unit selected in the hierarchy (used for employee assignment API).
  final String? orgUnitIdHex;

  /// Not the last level id; updated when the user changes the BUSINESS_UNIT dropdown.
  final String? businessUnitOrgUnitId;

  final String? workLocation;
  final int? workLocationId;
  final DateTime? asgStart;
  final DateTime? asgEnd;

  const AddEmployeeAssignmentState({
    this.levelSelections = const {},
    this.orgUnitIdHex,
    this.businessUnitOrgUnitId,
    this.workLocation,
    this.workLocationId,
    this.asgStart,
    this.asgEnd,
  });

  String? getSelectedUnitId(String levelCode) => levelSelections[levelCode]?.orgUnitId;

  String? getDisplayName(String levelCode) => levelSelections[levelCode]?.displayNameEn;

  Map<String, String?> get selectedUnitIds =>
      Map.fromEntries(levelSelections.entries.map((e) => MapEntry(e.key, e.value.orgUnitId)));

  bool isStepValid(Iterable<String> requiredLevelCodes) {
    for (final code in requiredLevelCodes) {
      final id = getSelectedUnitId(code);
      if (id == null || id.trim().isEmpty) return false;
    }
    final loc = workLocation?.trim() ?? '';
    final end = asgEnd;
    final start = asgStart;
    final endValid = end == null || (start != null && !end.isBefore(start));
    return loc.isNotEmpty && start != null && endValid;
  }

  AddEmployeeAssignmentState copyWith({
    Map<String, LevelSelection>? levelSelections,
    String? orgUnitIdHex,
    String? businessUnitOrgUnitId,
    String? workLocation,
    int? workLocationId,
    DateTime? asgStart,
    DateTime? asgEnd,
    bool clearOrgUnitIdHex = false,
    bool clearBusinessUnitOrgUnitId = false,
    bool clearWorkLocation = false,
    bool clearWorkLocationId = false,
    bool clearAsgStart = false,
    bool clearAsgEnd = false,
  }) {
    return AddEmployeeAssignmentState(
      levelSelections: levelSelections ?? this.levelSelections,
      orgUnitIdHex: clearOrgUnitIdHex ? null : (orgUnitIdHex ?? this.orgUnitIdHex),
      businessUnitOrgUnitId: clearBusinessUnitOrgUnitId ? null : (businessUnitOrgUnitId ?? this.businessUnitOrgUnitId),
      workLocation: clearWorkLocation ? null : (workLocation ?? this.workLocation),
      workLocationId: clearWorkLocationId ? null : (workLocationId ?? this.workLocationId),
      asgStart: clearAsgStart ? null : (asgStart ?? this.asgStart),
      asgEnd: clearAsgEnd ? null : (asgEnd ?? this.asgEnd),
    );
  }
}

class AddEmployeeAssignmentNotifier extends StateNotifier<AddEmployeeAssignmentState> {
  AddEmployeeAssignmentNotifier() : super(const AddEmployeeAssignmentState());

  void setSelection(String levelCode, String unitId, String displayNameEn, {required List<String> orderedLevelCodes}) {
    final newSelections = Map<String, LevelSelection>.from(state.levelSelections);
    newSelections[levelCode] = LevelSelection(orgUnitId: unitId, displayNameEn: displayNameEn);

    final levelIndex = orderedLevelCodes.indexOf(levelCode);
    if (levelIndex >= 0) {
      for (var i = levelIndex + 1; i < orderedLevelCodes.length; i++) {
        newSelections.remove(orderedLevelCodes[i]);
      }
    }

    final businessUnitId = newSelections[AddEmployeeAssignmentState.businessUnitLevelCode]?.orgUnitId;

    state = state.copyWith(
      levelSelections: newSelections,
      orgUnitIdHex: unitId,
      businessUnitOrgUnitId: businessUnitId,
      clearBusinessUnitOrgUnitId: businessUnitId == null,
    );
  }

  void setWorkLocation(String? value) {
    state = state.copyWith(workLocation: value, clearWorkLocation: value == null || value.isEmpty);
  }

  void setWorkLocationFromLookup(String? code, int? id) {
    final clear = code == null || code.isEmpty;
    state = state.copyWith(
      workLocation: clear ? null : code,
      workLocationId: clear ? null : id,
      clearWorkLocation: clear,
      clearWorkLocationId: clear,
    );
  }

  void setAsgStart(DateTime? value) {
    state = state.copyWith(asgStart: value, clearAsgStart: value == null);
  }

  void setAsgEnd(DateTime? value) {
    state = state.copyWith(asgEnd: value, clearAsgEnd: value == null);
  }

  void setFromFullDetails({
    String? orgUnitIdHex,
    List<OrgStructureItem>? orgStructureList,
    DateTime? asgStart,
    DateTime? asgEnd,
    String? workLocation,
    int? workLocationId,
  }) {
    final levelSelections = <String, LevelSelection>{};
    if (orgStructureList != null) {
      for (final item in orgStructureList) {
        final code = item.levelCode ?? '';
        if (code.isNotEmpty) {
          levelSelections[code] = LevelSelection(orgUnitId: item.orgUnitId, displayNameEn: item.orgUnitNameEn ?? '');
        }
      }
    }
    final businessUnitId = levelSelections[AddEmployeeAssignmentState.businessUnitLevelCode]?.orgUnitId;

    state = state.copyWith(
      levelSelections: levelSelections,
      orgUnitIdHex: orgUnitIdHex ?? state.orgUnitIdHex,
      businessUnitOrgUnitId: businessUnitId,
      clearBusinessUnitOrgUnitId: businessUnitId == null,
      asgStart: asgStart,
      asgEnd: asgEnd,
      workLocation: workLocation,
      workLocationId: workLocationId,
    );
  }

  void reset() {
    state = const AddEmployeeAssignmentState();
  }
}

final addEmployeeAssignmentProvider = StateNotifierProvider<AddEmployeeAssignmentNotifier, AddEmployeeAssignmentState>((
  ref,
) {
  return AddEmployeeAssignmentNotifier();
});
