import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';

class DutyRoleFormInheritedPickerState {
  const DutyRoleFormInheritedPickerState({
    this.roles = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.currentPage = 1,
    this.selectedGuids = const {},
    this.editingRoleGuid,
  });

  static const int pageSize = 10;

  final List<DutyRoleItem> roles;
  final bool isLoading;
  final String searchQuery;
  final int currentPage;
  final Set<String> selectedGuids;
  final String? editingRoleGuid;

  List<DutyRoleItem> get filteredRoles {
    Iterable<DutyRoleItem> base = roles;
    final exclude = editingRoleGuid;
    if (exclude != null && exclude.isNotEmpty) {
      base = base.where((r) => r.dutyRoleGuid != exclude);
    }
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return base.toList();
    return base.where((r) {
      return r.name.toLowerCase().contains(q) || r.code.toLowerCase().contains(q);
    }).toList();
  }

  int get totalPages {
    final n = filteredRoles.length;
    return n == 0 ? 1 : (n / pageSize).ceil();
  }

  int get safePage => currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);

  List<DutyRoleItem> get paginatedRoles {
    final list = filteredRoles;
    final start = (safePage - 1) * pageSize;
    if (start >= list.length) return const [];
    final end = (start + pageSize).clamp(0, list.length);
    return list.sublist(start, end);
  }

  DutyRoleFormInheritedPickerState copyWith({
    List<DutyRoleItem>? roles,
    bool? isLoading,
    String? searchQuery,
    int? currentPage,
    Set<String>? selectedGuids,
    String? editingRoleGuid,
    bool clearEditingRoleGuid = false,
  }) {
    return DutyRoleFormInheritedPickerState(
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      selectedGuids: selectedGuids ?? this.selectedGuids,
      editingRoleGuid: clearEditingRoleGuid ? null : (editingRoleGuid ?? this.editingRoleGuid),
    );
  }
}
