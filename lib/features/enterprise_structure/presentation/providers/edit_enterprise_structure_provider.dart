import 'package:grc/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HierarchyLevel {
  final String id;
  final String name;
  final String icon;
  final int level;
  final bool isMandatory;
  final bool isActive; // ✅ make immutable (important for clean state updates)
  final String previewIcon;

  const HierarchyLevel({
    required this.id,
    required this.name,
    required this.icon,
    required this.level,
    required this.isMandatory,
    required this.isActive,
    required this.previewIcon,
  });

  HierarchyLevel copyWith({
    String? id,
    String? name,
    String? icon,
    int? level,
    bool? isMandatory,
    bool? isActive,
    String? previewIcon,
  }) {
    return HierarchyLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      level: level ?? this.level,
      isMandatory: isMandatory ?? this.isMandatory,
      isActive: isActive ?? this.isActive,
      previewIcon: previewIcon ?? this.previewIcon,
    );
  }
}

class EditEnterpriseStructureState {
  final String structureName;
  final String description;
  final List<HierarchyLevel> levels;
  final int? selectedEnterpriseId;
  final bool isActive;

  const EditEnterpriseStructureState({
    required this.structureName,
    required this.description,
    required this.levels,
    this.selectedEnterpriseId,
    this.isActive = true,
  });

  EditEnterpriseStructureState copyWith({
    String? structureName,
    String? description,
    List<HierarchyLevel>? levels,
    int? selectedEnterpriseId,
    bool? isActive,
  }) {
    return EditEnterpriseStructureState(
      structureName: structureName ?? this.structureName,
      description: description ?? this.description,
      levels: levels ?? this.levels,
      selectedEnterpriseId: selectedEnterpriseId ?? this.selectedEnterpriseId,
      isActive: isActive ?? this.isActive,
    );
  }

  int get totalLevels => levels.length;
  int get activeLevels => levels.where((l) => l.isActive).length;
  int get hierarchyDepth => levels.where((l) => l.isActive).length;
  String get topLevel => levels.isNotEmpty ? levels.first.name : '';
}

class EditEnterpriseStructureNotifier
    extends StateNotifier<EditEnterpriseStructureState> {
  EditEnterpriseStructureNotifier({
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
    int? selectedEnterpriseId,
    bool isActive = true,
  }) : super(
    EditEnterpriseStructureState(
      structureName: structureName,
      description: description,
      levels: List<HierarchyLevel>.from(initialLevels),
      selectedEnterpriseId: selectedEnterpriseId,
      isActive: isActive,
    ),
  );

  /// ✅ IMPORTANT: only initialize from API once (prevents snap-back after reorder)
  bool _initializedFromApi = false;

  /// Sets levels from API data (ONE TIME by default)
  void setLevelsFromApiOnce(List<HierarchyLevel> apiLevels) {
    if (_initializedFromApi) return;
    _initializedFromApi = true;
    state = state.copyWith(levels: _normalizeLevels(List.from(apiLevels)));
  }

  /// If you really want to force replace levels (e.g. Reset button)
  void setLevels(List<HierarchyLevel> levels) {
    state = state.copyWith(levels: _normalizeLevels(List.from(levels)));
  }

  void reorderLevels(int oldIndex, int newIndex) {
    final current = state.levels;
    if (current.isEmpty) return;
    if (oldIndex < 0 || oldIndex >= current.length) return;

    final moving = current[oldIndex];
    if (moving.isMandatory) return;

    if (newIndex < 0 || newIndex >= current.length) return;
    if (current[newIndex].isMandatory) return; // extra safety

    final updated = List<HierarchyLevel>.from(current);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);

    state = state.copyWith(levels: _normalizeLevels(updated));
  }


  List<HierarchyLevel> _normalizeLevels(List<HierarchyLevel> list) {
    return List.generate(list.length, (i) => list[i].copyWith(level: i + 1));
  }

  void updateStructureName(String name) {
    state = state.copyWith(structureName: name);
  }

  void updateDescription(String desc) {
    state = state.copyWith(description: desc);
  }

  void updateSelectedEnterprise(int? enterpriseId) {
    state = state.copyWith(selectedEnterpriseId: enterpriseId);
  }

  void toggleLevelActive(int index) {
    if (index < 0 || index >= state.levels.length) return;

    final level = state.levels[index];
    if (level.isMandatory) return;

    final updated = List<HierarchyLevel>.from(state.levels);
    updated[index] = level.copyWith(isActive: !level.isActive);
    state = state.copyWith(levels: updated);
  }

  void moveLevelUp(int index) {
    if (index <= 0 || index >= state.levels.length) return;

    final level = state.levels[index];
    if (level.isMandatory) return;

    final prev = state.levels[index - 1];
    if (prev.isMandatory) return;

    final updated = List<HierarchyLevel>.from(state.levels);
    updated[index - 1] = level;
    updated[index] = prev;

    state = state.copyWith(levels: _normalizeLevels(updated));
  }

  void moveLevelDown(int index) {
    if (index < 0 || index >= state.levels.length - 1) return;

    final level = state.levels[index];
    if (level.isMandatory) return;

    final next = state.levels[index + 1];
    if (next.isMandatory) return;

    final updated = List<HierarchyLevel>.from(state.levels);
    updated[index + 1] = level;
    updated[index] = next;

    state = state.copyWith(levels: _normalizeLevels(updated));
  }

  /// Reset to default levels (from API) - force overwrite
  void resetToDefault(List<HierarchyLevel> defaultLevels) {
    _initializedFromApi = true; // keep it initialized after reset
    state = state.copyWith(levels: _normalizeLevels(List.from(defaultLevels)));
  }

  void updateIsActive(bool isActive) {
    state = state.copyWith(isActive: isActive);
  }
}

/// ✅ Provider (same pattern you already use)
final editEnterpriseStructureProvider = StateNotifierProvider.autoDispose.family<
    EditEnterpriseStructureNotifier,
    EditEnterpriseStructureState,
    EditDialogParams>(
      (ref, params) => EditEnterpriseStructureNotifier(
    structureName: params.structureName,
    description: params.description,
    initialLevels: params.initialLevels,
    selectedEnterpriseId: params.selectedEnterpriseId,
    isActive: params.isActive,
  ),
);
