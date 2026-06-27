import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'roles_management_state.dart';

final rolesManagementPermissionMatrixFormProvider = StateNotifierProvider.autoDispose<
    RolesManagementPermissionMatrixFormNotifier,
    RolesManagementPermissionMatrixFormState>((ref) {
  return RolesManagementPermissionMatrixFormNotifier();
});

class RolesManagementPermissionMatrixFormNotifier extends StateNotifier<RolesManagementPermissionMatrixFormState> {
  RolesManagementPermissionMatrixFormNotifier() : super(const RolesManagementPermissionMatrixFormState());

  bool _initialized = false;

  void initialize(List<RolePermission> permissions) {
    if (_initialized) return;
    _initialized = true;

    final selectedCells = <String, Set<PermissionMatrixColumn>>{};
    for (final permission in permissions) {
      final selectedColumns = <PermissionMatrixColumn>{};
      if (permission.view) selectedColumns.add(PermissionMatrixColumn.view);
      if (permission.create) selectedColumns.add(PermissionMatrixColumn.create);
      if (permission.edit) selectedColumns.add(PermissionMatrixColumn.edit);
      if (permission.delete) selectedColumns.add(PermissionMatrixColumn.delete);
      if (permission.approve) selectedColumns.add(PermissionMatrixColumn.approve);
      if (permission.export) selectedColumns.add(PermissionMatrixColumn.export);
      if (permission.override) selectedColumns.add(PermissionMatrixColumn.overridePermission);
      if (permission.upload) selectedColumns.add(PermissionMatrixColumn.upload);
      if (permission.download) selectedColumns.add(PermissionMatrixColumn.download);
      selectedCells[permission.id] = selectedColumns;
    }

    state = state.copyWith(selectedCells: selectedCells, selectedPreset: PermissionMatrixPreset.custom);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateScope(String scope) {
    state = state.copyWith(scope: scope);
  }

  void applyPreset(PermissionMatrixPreset preset, List<RolePermission> permissions) {
    final selectedCells = <String, Set<PermissionMatrixColumn>>{};

    for (final permission in permissions) {
      switch (preset) {
        case PermissionMatrixPreset.fullAccess:
          selectedCells[permission.id] = PermissionMatrixColumn.values.toSet();
          break;
        case PermissionMatrixPreset.readOnly:
          selectedCells[permission.id] = {
            PermissionMatrixColumn.view,
            PermissionMatrixColumn.export,
            PermissionMatrixColumn.download,
          };
          break;
        case PermissionMatrixPreset.managerAccess:
          selectedCells[permission.id] = {
            PermissionMatrixColumn.view,
            PermissionMatrixColumn.create,
            PermissionMatrixColumn.edit,
            PermissionMatrixColumn.delete,
            PermissionMatrixColumn.approve,
            PermissionMatrixColumn.export,
          };
          break;
        case PermissionMatrixPreset.noAccess:
          selectedCells[permission.id] = <PermissionMatrixColumn>{};
          break;
        case PermissionMatrixPreset.custom:
          selectedCells[permission.id] = state.selectedCells[permission.id] ?? <PermissionMatrixColumn>{};
          break;
      }
    }

    state = state.copyWith(selectedPreset: preset, selectedCells: selectedCells);
  }

  void togglePermission(String permissionId, PermissionMatrixColumn column) {
    final updated = Map<String, Set<PermissionMatrixColumn>>.fromEntries(
      state.selectedCells.entries.map(
        (entry) => MapEntry(entry.key, {...entry.value}),
      ),
    );
    final columns = updated.putIfAbsent(permissionId, () => <PermissionMatrixColumn>{});
    if (columns.contains(column)) {
      columns.remove(column);
    } else {
      columns.add(column);
    }
    state = state.copyWith(selectedPreset: PermissionMatrixPreset.custom, selectedCells: updated);
  }

  void setGroupSelection(List<RolePermission> permissions, bool selected) {
    final updated = Map<String, Set<PermissionMatrixColumn>>.fromEntries(
      state.selectedCells.entries.map(
        (entry) => MapEntry(entry.key, {...entry.value}),
      ),
    );
    for (final permission in permissions) {
      updated[permission.id] = selected ? PermissionMatrixColumn.values.toSet() : <PermissionMatrixColumn>{};
    }
    state = state.copyWith(selectedPreset: PermissionMatrixPreset.custom, selectedCells: updated);
  }
}
