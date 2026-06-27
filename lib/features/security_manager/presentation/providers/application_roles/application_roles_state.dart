class ApplicationRoleItem {
  const ApplicationRoleItem({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.type,
    required this.category,
    required this.usersAssigned,
    required this.isActive,
    required this.permissions,
    required this.createdBy,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String code;
  final String description;
  final String type;
  final String category;
  final int usersAssigned;
  final bool isActive;
  final List<String> permissions;
  final String createdBy;
  final String updatedAt;

  String get usersLabel => '$usersAssigned ${usersAssigned == 1 ? 'user' : 'users'} assigned';

  bool get isSystem => type == 'System';
}

class ApplicationRolesState {
  const ApplicationRolesState({
    this.selectedTypeFilter = 'All',
    this.selectedStatusFilter = 'All',
    this.selectedCategoryFilter = 'All',
    this.searchQuery = '',
    this.selectedRole,
    this.roles = const [],
  });

  final String selectedTypeFilter;
  final String selectedStatusFilter;
  final String selectedCategoryFilter;
  final String searchQuery;
  final ApplicationRoleItem? selectedRole;
  final List<ApplicationRoleItem> roles;

  List<ApplicationRoleItem> get filteredRoles {
    return roles.where((role) {
      final matchesSearch =
          searchQuery.isEmpty ||
          role.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          role.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          role.code.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesType = selectedTypeFilter == 'All' || role.type == selectedTypeFilter;
      final matchesStatus =
          selectedStatusFilter == 'All' ||
          (selectedStatusFilter == 'Active' && role.isActive) ||
          (selectedStatusFilter == 'Inactive' && !role.isActive);
      final matchesCategory = selectedCategoryFilter == 'All' || role.category == selectedCategoryFilter;
      return matchesSearch && matchesType && matchesStatus && matchesCategory;
    }).toList();
  }

  int get totalRolesCount => roles.length;

  int get activeRolesCount => roles.where((r) => r.isActive).length;

  int get totalUsersAssigned => roles.fold(0, (sum, r) => sum + r.usersAssigned);

  int get systemRolesCount => roles.where((r) => r.isSystem).length;

  ApplicationRolesState copyWith({
    String? selectedTypeFilter,
    String? selectedStatusFilter,
    String? selectedCategoryFilter,
    String? searchQuery,
    ApplicationRoleItem? Function()? selectedRole,
    List<ApplicationRoleItem>? roles,
  }) {
    return ApplicationRolesState(
      selectedTypeFilter: selectedTypeFilter ?? this.selectedTypeFilter,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      selectedCategoryFilter: selectedCategoryFilter ?? this.selectedCategoryFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRole: selectedRole != null ? selectedRole() : this.selectedRole,
      roles: roles ?? this.roles,
    );
  }
}
