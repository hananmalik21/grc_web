import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class LeaveBalanceSummaryListState {
  final List<LeaveBalanceSummaryItem> items;
  final PaginationInfo? pagination;
  final bool isLoading;
  final Object? error;
  final int? lastEnterpriseId;
  final int currentPage;
  final String? searchQuery;

  const LeaveBalanceSummaryListState({
    this.items = const [],
    this.pagination,
    this.isLoading = false,
    this.error,
    this.lastEnterpriseId,
    this.currentPage = 1,
    this.searchQuery,
  });

  LeaveBalanceSummaryListState copyWith({
    List<LeaveBalanceSummaryItem>? items,
    PaginationInfo? pagination,
    bool? isLoading,
    Object? error,
    int? lastEnterpriseId,
    int? currentPage,
    String? searchQuery,
    bool clearSearchQuery = false,
  }) {
    return LeaveBalanceSummaryListState(
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
