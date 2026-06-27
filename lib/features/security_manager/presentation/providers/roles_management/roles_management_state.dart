enum RoleType { application, function, data, job, duty }

enum RoleTabType { application, function, data, job, duty }

enum PermissionMatrixPreset { fullAccess, readOnly, managerAccess, noAccess, custom }

enum PermissionMatrixColumn { view, create, edit, delete, approve, export, overridePermission, upload, download }

extension RoleTabTypeExt on RoleTabType {
  RoleType get roleType => switch (this) {
    RoleTabType.application => RoleType.application,
    RoleTabType.function => RoleType.function,
    RoleTabType.data => RoleType.data,
    RoleTabType.job => RoleType.job,
    RoleTabType.duty => RoleType.duty,
  };

  String get label => roleType.label;
  String get tabTitle => roleType.tabTitle;
  String get tabSubtitle => roleType.tabSubtitle;
}

extension RoleTypeExt on RoleType {
  String get label {
    switch (this) {
      case RoleType.application:
        return 'Application';
      case RoleType.function:
        return 'Function';
      case RoleType.data:
        return 'Data';
      case RoleType.job:
        return 'Job';
      case RoleType.duty:
        return 'Duty';
    }
  }

  String get tabTitle {
    switch (this) {
      case RoleType.application:
        return 'Application Roles';
      case RoleType.function:
        return 'Function Roles';
      case RoleType.data:
        return 'Data Roles';
      case RoleType.job:
        return 'Job Roles';
      case RoleType.duty:
        return 'Duty Roles';
    }
  }

  String get tabSubtitle {
    switch (this) {
      case RoleType.application:
        return 'Complete sets of access permissions';
      case RoleType.function:
        return 'Module-specific permissions';
      case RoleType.data:
        return 'Data access control';
      case RoleType.job:
        return 'Position-based access';
      case RoleType.duty:
        return 'Task-specific permissions';
    }
  }
}

class RoleModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final RoleType type;
  final int usersAssigned;
  final bool isActive;
  final DateTime createdOn;
  final String updatedLabel;
  final String roleBadge;

  const RoleModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.type,
    required this.usersAssigned,
    required this.isActive,
    required this.createdOn,
    this.updatedLabel = '',
    this.roleBadge = 'Custom Role',
  });

  RoleModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    RoleType? type,
    int? usersAssigned,
    bool? isActive,
    DateTime? createdOn,
    String? updatedLabel,
    String? roleBadge,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      type: type ?? this.type,
      usersAssigned: usersAssigned ?? this.usersAssigned,
      isActive: isActive ?? this.isActive,
      createdOn: createdOn ?? this.createdOn,
      updatedLabel: updatedLabel ?? this.updatedLabel,
      roleBadge: roleBadge ?? this.roleBadge,
    );
  }
}

class RolePermission {
  final String id;
  final String group;
  final String name;
  final bool isRisky;
  final bool view;
  final bool create;
  final bool edit;
  final bool delete;
  final bool approve;
  final bool export;
  final bool override;
  final bool upload;
  final bool download;

  const RolePermission({
    required this.id,
    required this.group,
    required this.name,
    this.isRisky = false,
    this.view = false,
    this.create = false,
    this.edit = false,
    this.delete = false,
    this.approve = false,
    this.export = false,
    this.override = false,
    this.upload = false,
    this.download = false,
  });
}

class RoleAssignedUser {
  final String name;
  final String code;

  const RoleAssignedUser({required this.name, required this.code});
}

class RoleActivity {
  final String title;
  final String description;
  final String relativeTime;
  final String iconKey;

  const RoleActivity({
    required this.title,
    required this.description,
    required this.relativeTime,
    required this.iconKey,
  });
}

extension PermissionMatrixPresetExt on PermissionMatrixPreset {
  String get label {
    switch (this) {
      case PermissionMatrixPreset.fullAccess:
        return 'Full Access';
      case PermissionMatrixPreset.readOnly:
        return 'Read Only';
      case PermissionMatrixPreset.managerAccess:
        return 'Manager Access';
      case PermissionMatrixPreset.noAccess:
        return 'No Access';
      case PermissionMatrixPreset.custom:
        return 'Custom';
    }
  }
}

class RolesManagementPermissionMatrixFormState {
  final String searchQuery;
  final String scope;
  final PermissionMatrixPreset selectedPreset;
  final Map<String, Set<PermissionMatrixColumn>> selectedCells;

  const RolesManagementPermissionMatrixFormState({
    this.searchQuery = '',
    this.scope = 'All Employees',
    this.selectedPreset = PermissionMatrixPreset.custom,
    this.selectedCells = const {},
  });

  bool isSelected(String permissionId, PermissionMatrixColumn column) {
    return selectedCells[permissionId]?.contains(column) ?? false;
  }

  RolesManagementPermissionMatrixFormState copyWith({
    String? searchQuery,
    String? scope,
    PermissionMatrixPreset? selectedPreset,
    Map<String, Set<PermissionMatrixColumn>>? selectedCells,
  }) {
    return RolesManagementPermissionMatrixFormState(
      searchQuery: searchQuery ?? this.searchQuery,
      scope: scope ?? this.scope,
      selectedPreset: selectedPreset ?? this.selectedPreset,
      selectedCells: selectedCells ?? this.selectedCells,
    );
  }
}

class RolesManagementState {
  final String searchQuery;
  final String filterType;
  final String roleCategoryFilter;
  final List<RoleModel> roles;
  final String? selectedRoleId;
  final bool isLoading;

  const RolesManagementState({
    this.searchQuery = '',
    this.filterType = 'Function',
    this.roleCategoryFilter = 'All Types',
    this.roles = const [],
    this.selectedRoleId,
    this.isLoading = false,
  });

  List<RoleModel> get filteredRoles {
    var result = [...roles];
    if (filterType.isNotEmpty) {
      result = result.where((r) => r.type.label == filterType).toList();
    }
    if (roleCategoryFilter != 'All Types') {
      result = result.where((r) => r.roleBadge == roleCategoryFilter).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where(
            (r) =>
                r.name.toLowerCase().contains(q) ||
                r.description.toLowerCase().contains(q) ||
                r.code.toLowerCase().contains(q),
          )
          .toList();
    }
    return result;
  }

  int get totalRoles => roles.length;
  int get activeRoles => roles.where((r) => r.isActive).length;
  int get inactiveRoles => roles.where((r) => !r.isActive).length;
  int get totalUsersAssigned => roles.fold(0, (sum, r) => sum + r.usersAssigned);
  int get filteredRolesCount => filteredRoles.length;
  int get filteredSystemRolesCount => filteredRoles.where((r) => r.roleBadge == 'System Role').length;
  int get filteredCustomRolesCount => filteredRoles.where((r) => r.roleBadge == 'Custom Role').length;
  int get filteredUsersAssignedCount => filteredRoles.fold(0, (sum, r) => sum + r.usersAssigned);
  int countByType(RoleType type) => roles.where((r) => r.type == type).length;
  RoleModel? get selectedRole {
    final items = filteredRoles;
    if (items.isEmpty) return null;
    if (selectedRoleId == null) return items.first;

    for (final item in items) {
      if (item.id == selectedRoleId) return item;
    }
    return items.first;
  }

  RolesManagementState copyWith({
    String? searchQuery,
    String? filterType,
    String? roleCategoryFilter,
    List<RoleModel>? roles,
    String? selectedRoleId,
    bool clearSelectedRole = false,
    bool? isLoading,
  }) {
    return RolesManagementState(
      searchQuery: searchQuery ?? this.searchQuery,
      filterType: filterType ?? this.filterType,
      roleCategoryFilter: roleCategoryFilter ?? this.roleCategoryFilter,
      roles: roles ?? this.roles,
      selectedRoleId: clearSelectedRole ? null : (selectedRoleId ?? this.selectedRoleId),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
