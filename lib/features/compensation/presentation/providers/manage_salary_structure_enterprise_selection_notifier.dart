import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageSalaryStructureEnterpriseSelectionState {
  final Map<String, OrgUnit?> selections;
  final Map<String, List<OrgUnit>> availableOptions;
  final Map<String, bool> loadingStates;
  final Map<String, bool> fetchingMoreStates;
  final Map<String, String?> errors;
  final Map<String, int> pages;
  final Map<String, bool> hasNextStates;
  final Map<String, String> searchQueries;
  final Map<String, String> lastRequestKeys;
  final String? structureId;

  const ManageSalaryStructureEnterpriseSelectionState({
    this.selections = const {},
    this.availableOptions = const {},
    this.loadingStates = const {},
    this.fetchingMoreStates = const {},
    this.errors = const {},
    this.pages = const {},
    this.hasNextStates = const {},
    this.searchQueries = const {},
    this.lastRequestKeys = const {},
    this.structureId,
  });

  ManageSalaryStructureEnterpriseSelectionState copyWith({
    Map<String, OrgUnit?>? selections,
    Map<String, List<OrgUnit>>? availableOptions,
    Map<String, bool>? loadingStates,
    Map<String, bool>? fetchingMoreStates,
    Map<String, String?>? errors,
    Map<String, int>? pages,
    Map<String, bool>? hasNextStates,
    Map<String, String>? searchQueries,
    Map<String, String>? lastRequestKeys,
    String? structureId,
  }) {
    return ManageSalaryStructureEnterpriseSelectionState(
      selections: selections ?? this.selections,
      availableOptions: availableOptions ?? this.availableOptions,
      loadingStates: loadingStates ?? this.loadingStates,
      fetchingMoreStates: fetchingMoreStates ?? this.fetchingMoreStates,
      errors: errors ?? this.errors,
      pages: pages ?? this.pages,
      hasNextStates: hasNextStates ?? this.hasNextStates,
      searchQueries: searchQueries ?? this.searchQueries,
      lastRequestKeys: lastRequestKeys ?? this.lastRequestKeys,
      structureId: structureId ?? this.structureId,
    );
  }

  OrgUnit? getSelection(String levelCode) => selections[levelCode];

  List<OrgUnit> getOptions(String levelCode) => availableOptions[levelCode] ?? [];

  bool isLoading(String levelCode) => loadingStates[levelCode] ?? false;

  bool isFetchingMore(String levelCode) => fetchingMoreStates[levelCode] ?? false;

  String? getError(String levelCode) => errors[levelCode];

  int getPage(String levelCode) => pages[levelCode] ?? 1;

  bool hasNext(String levelCode) => hasNextStates[levelCode] ?? false;

  String getSearchQuery(String levelCode) => searchQueries[levelCode] ?? '';
}

class ManageSalaryStructureEnterpriseSelectionNotifier
    extends StateNotifier<ManageSalaryStructureEnterpriseSelectionState> {
  final GetOrgUnitsByLevelUseCase getOrgUnitsByLevelUseCase;
  final List<OrgStructureLevel> levels;
  final _debouncer = Debouncer();
  final int? tenantId;

  ManageSalaryStructureEnterpriseSelectionNotifier({
    required this.getOrgUnitsByLevelUseCase,
    required this.levels,
    required String structureId,
    this.tenantId,
  }) : super(ManageSalaryStructureEnterpriseSelectionState(structureId: structureId));

  Future<void> loadOptionsForLevel(String levelCode) async {
    if (state.structureId == null) return;

    final levelIndex = levels.indexWhere((l) => l.levelCode == levelCode);
    String? parentOrgUnitId;

    if (levelIndex > 0) {
      final parentLevel = levels[levelIndex - 1];
      final parentSelection = state.getSelection(parentLevel.levelCode);
      parentOrgUnitId = parentSelection?.orgUnitId;
    }

    final requestKey = '$levelCode|${parentOrgUnitId ?? 'root'}|${state.getSearchQuery(levelCode)}';
    final hasLoadedSameRequest =
        state.lastRequestKeys[levelCode] == requestKey && state.availableOptions.containsKey(levelCode);
    if (hasLoadedSameRequest) return;

    final newPages = Map<String, int>.from(state.pages);
    newPages[levelCode] = 1;

    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[levelCode] = true;

    final newLastRequestKeys = Map<String, String>.from(state.lastRequestKeys);
    newLastRequestKeys[levelCode] = requestKey;

    state = state.copyWith(loadingStates: newLoadingStates, pages: newPages, lastRequestKeys: newLastRequestKeys);

    try {
      final response = await getOrgUnitsByLevelUseCase(
        structureId: state.structureId!,
        levelCode: levelCode,
        parentOrgUnitId: parentOrgUnitId,
        search: state.getSearchQuery(levelCode),
        tenantId: tenantId,
        page: 1,
        pageSize: 10,
      );

      final activeUnits = response.data.where((unit) => unit.isActive).toList();
      _updateStateAfterSuccess(levelCode, activeUnits, response.hasNext);
    } catch (e) {
      _updateStateAfterError(levelCode, e.toString());
    }
  }

  void _updateStateAfterSuccess(String levelCode, List<OrgUnit> options, bool hasNext) {
    final newOptions = Map<String, List<OrgUnit>>.from(state.availableOptions);
    newOptions[levelCode] = options;

    final newHasNextStates = Map<String, bool>.from(state.hasNextStates);
    newHasNextStates[levelCode] = hasNext;

    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[levelCode] = false;

    final newErrors = Map<String, String?>.from(state.errors);
    newErrors[levelCode] = null;

    state = state.copyWith(
      availableOptions: newOptions,
      hasNextStates: newHasNextStates,
      loadingStates: newLoadingStates,
      errors: newErrors,
    );
  }

  void _updateStateAfterError(String levelCode, String error) {
    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[levelCode] = false;

    final newErrors = Map<String, String?>.from(state.errors);
    newErrors[levelCode] = error;

    state = state.copyWith(loadingStates: newLoadingStates, errors: newErrors);
  }

  void setSearchQuery(String levelCode, String query) {
    if (state.getSearchQuery(levelCode) == query) return;

    final newSearchQueries = Map<String, String>.from(state.searchQueries);
    newSearchQueries[levelCode] = query;
    state = state.copyWith(searchQueries: newSearchQueries);

    _debouncer.run(() {
      loadOptionsForLevel(levelCode);
    });
  }

  void selectUnit(String levelCode, OrgUnit? unit) {
    final newSelections = Map<String, OrgUnit?>.from(state.selections);
    newSelections[levelCode] = unit;

    final levelIndex = levels.indexWhere((l) => l.levelCode == levelCode);

    final newOptions = Map<String, List<OrgUnit>>.from(state.availableOptions);
    final newPages = Map<String, int>.from(state.pages);
    final newHasNextStates = Map<String, bool>.from(state.hasNextStates);
    final newLastRequestKeys = Map<String, String>.from(state.lastRequestKeys);

    for (int i = levelIndex + 1; i < levels.length; i++) {
      final childLevelCode = levels[i].levelCode;
      newSelections[childLevelCode] = null;
      newOptions[childLevelCode] = [];
      newPages[childLevelCode] = 1;
      newHasNextStates[childLevelCode] = false;
      newLastRequestKeys.remove(childLevelCode);
    }

    state = state.copyWith(
      selections: newSelections,
      availableOptions: newOptions,
      pages: newPages,
      hasNextStates: newHasNextStates,
      lastRequestKeys: newLastRequestKeys,
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
