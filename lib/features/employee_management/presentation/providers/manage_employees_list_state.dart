import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class ManageEmployeesListState {
  final List<EmployeeListItem> items;
  final PaginationInfo? pagination;
  final bool isLoading;
  final Object? error;
  final int? lastEnterpriseId;
  final int currentPage;
  final String? searchQuery;

  const ManageEmployeesListState({
    this.items = const [],
    this.pagination,
    this.isLoading = false,
    this.error,
    this.lastEnterpriseId,
    this.currentPage = 1,
    this.searchQuery,
  });

  bool get hasExplicitSearch => searchQuery != null && searchQuery!.trim().isNotEmpty;

  ManageEmployeesListState copyWith({
    List<EmployeeListItem>? items,
    PaginationInfo? pagination,
    bool? isLoading,
    Object? error,
    int? lastEnterpriseId,
    int? currentPage,
    String? searchQuery,
    bool clearSearchQuery = false,
  }) {
    return ManageEmployeesListState(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastEnterpriseId: lastEnterpriseId ?? this.lastEnterpriseId,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }
}
