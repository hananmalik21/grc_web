import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/access_management/access_role.dart';

class AccessRoleFormState {
  final String? roleName;
  final String? roleDescription;
  final String? roleType;
  final String? status;
  final String? searchQuery;
  final List<AccessRolePermission> permissions;
  final List<AccessRolePermission> filteredPermissions;
  final bool dataLoading;
  final bool isLoading;
  final bool clearError;
  final String? error;

  AccessRoleFormState({
    this.roleName,
    this.roleDescription,
    this.roleType,
    this.status,
    this.searchQuery,
    this.permissions = const [],
    this.filteredPermissions = const [],
    this.dataLoading = false,
    this.isLoading = false,
    this.clearError = false,
    this.error,
  });

  AccessRoleFormState copyWith({
    String? roleName,
    String? roleDescription,
    String? roleType,
    String? status,
    String? searchQuery,
    List<AccessRolePermission>? permissions,
    List<AccessRolePermission>? filteredPermissions,
    bool? dataLoading,
    bool? isLoading,
    bool? clearError,
    String? error,
  }) {
    return AccessRoleFormState(
      roleName: roleName ?? this.roleName,
      roleDescription: roleDescription ?? this.roleDescription,
      roleType: roleType ?? this.roleType,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      permissions: permissions ?? this.permissions,
      filteredPermissions: filteredPermissions ?? this.filteredPermissions,
      dataLoading: dataLoading ?? this.dataLoading,
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
    );
  }
}

class AccessRoleFormProvider extends StateNotifier<AccessRoleFormState> {
  AccessRoleFormProvider() : super(AccessRoleFormState()) {
    loadPermissions();
  }

  void setInitialData(AccessRoleDetail? roleDetail) {
    if (roleDetail != null) {
      state = state.copyWith(
        roleName: roleDetail.name,
        roleDescription: roleDetail.description,
        roleType: roleDetail.type,
        permissions: roleDetail.permissions,
        filteredPermissions: roleDetail.permissions,
      );
    }
  }

  void loadPermissions() {
    state = state.copyWith(
      dataLoading: true,
      permissions: [
        AccessRolePermission(id: '1', name: 'Employees'),
        AccessRolePermission(id: '2', name: 'Attendance'),
        AccessRolePermission(id: '3', name: 'Leave'),
        AccessRolePermission(id: '4', name: 'Payroll'),
        AccessRolePermission(id: '5', name: 'Documents'),
        AccessRolePermission(id: '6', name: 'Recruitment'),
        AccessRolePermission(id: '7', name: 'Settings'),
        AccessRolePermission(id: '8', name: 'Security'),
      ],
      filteredPermissions: [
        AccessRolePermission(id: '1', name: 'Employees'),
        AccessRolePermission(id: '2', name: 'Attendance'),
        AccessRolePermission(id: '3', name: 'Leave'),
        AccessRolePermission(id: '4', name: 'Payroll'),
        AccessRolePermission(id: '5', name: 'Documents'),
        AccessRolePermission(id: '6', name: 'Recruitment'),
        AccessRolePermission(id: '7', name: 'Settings'),
        AccessRolePermission(id: '8', name: 'Security'),
      ],
    );
  }

  void setRoleName(String roleName) {
    state = state.copyWith(roleName: roleName);
  }

  void setRoleDescription(String roleDescription) {
    state = state.copyWith(roleDescription: roleDescription);
  }

  void setRoleType(String roleType) {
    state = state.copyWith(roleType: roleType);
  }

  void setStatus(String status) {
    state = state.copyWith(status: status);
  }

  void updatePermission(
    String moduleId, {
    bool? view,
    bool? create,
    bool? edit,
    bool? delete,
  }) {
    final permissions = state.permissions;
    final updatedPermissions = permissions.map((permission) {
      if (permission.id == moduleId) {
        return permission.copyWith(
          view: view ?? permission.view,
          create: create ?? permission.create,
          edit: edit ?? permission.edit,
          delete: delete ?? permission.delete,
        );
      }
      return permission;
    }).toList();

    state = state.copyWith(permissions: updatedPermissions);

    if (state.searchQuery?.isNotEmpty ?? false) {
      state = state.copyWith(
        filteredPermissions: updatedPermissions.where((permission) {
          return permission.name.toLowerCase().contains(
            state.searchQuery!.toLowerCase(),
          );
        }).toList(),
      );
    } else {
      state = state.copyWith(filteredPermissions: updatedPermissions);
    }
  }

  void searchPermissions(String query) {
    final permissions = state.permissions;
    final filteredPermissions = permissions.where((permission) {
      return permission.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(
      searchQuery: query,
      filteredPermissions: filteredPermissions,
    );
  }

  void resetForm() {
    state = AccessRoleFormState();
    loadPermissions();
  }
}

final accessRoleFormProvider =
    StateNotifierProvider<AccessRoleFormProvider, AccessRoleFormState>(
      (ref) => AccessRoleFormProvider(),
    );
