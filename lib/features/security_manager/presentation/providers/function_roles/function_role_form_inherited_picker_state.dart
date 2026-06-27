import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';

class FunctionRoleFormInheritedPickerState {
  const FunctionRoleFormInheritedPickerState({
    this.roles = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.currentPage = 1,
    this.selectedGuids = const {},
    this.editingRoleGuid,
    this.initialParentRoleIds = const [],
  });

  static const int pageSize = 10;

  final List<FunctionRoleItem> roles;
  final bool isLoading;
  final String searchQuery;
  final int currentPage;
  final Set<String> selectedGuids;
  final String? editingRoleGuid;

  /// Parent role IDs from inherited functions — used to pre-select on edit.
  final List<int> initialParentRoleIds;

  List<FunctionRoleItem> get filteredRoles {
    final exclude = editingRoleGuid;
    Iterable<FunctionRoleItem> base = roles;
    if (exclude != null && exclude.isNotEmpty) {
      base = base.where((r) => r.functionRoleGuid != exclude);
    }
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return base.toList();
    return base.where((r) {
      return r.name.toLowerCase().contains(q) ||
          r.code.toLowerCase().contains(q) ||
          r.moduleName.toLowerCase().contains(q) ||
          r.description.toLowerCase().contains(q);
    }).toList();
  }

  int get totalPages {
    final n = filteredRoles.length;
    if (n == 0) return 1;
    return (n / pageSize).ceil();
  }

  int get safePage => currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);

  List<FunctionRoleItem> get paginatedRoles {
    final list = filteredRoles;
    final start = (safePage - 1) * pageSize;
    if (start >= list.length) return const [];
    final end = (start + pageSize).clamp(0, list.length);
    return list.sublist(start, end);
  }

  FunctionRoleFormInheritedPickerState copyWith({
    List<FunctionRoleItem>? roles,
    bool? isLoading,
    String? searchQuery,
    int? currentPage,
    Set<String>? selectedGuids,
    String? editingRoleGuid,
    bool clearEditingRoleGuid = false,
    List<int>? initialParentRoleIds,
  }) {
    return FunctionRoleFormInheritedPickerState(
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      selectedGuids: selectedGuids ?? this.selectedGuids,
      editingRoleGuid: clearEditingRoleGuid ? null : (editingRoleGuid ?? this.editingRoleGuid),
      initialParentRoleIds: initialParentRoleIds ?? this.initialParentRoleIds,
    );
  }
}
