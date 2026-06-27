import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';

class EmployeeLeaveHistoryState {
  final String employeeGuid;
  final List<TimeOffRequest> items;
  final PaginationInfo? pagination;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int pageSize;

  const EmployeeLeaveHistoryState({
    required this.employeeGuid,
    this.items = const [],
    this.pagination,
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.pageSize = 10,
  });

  EmployeeLeaveHistoryState copyWith({
    String? employeeGuid,
    List<TimeOffRequest>? items,
    PaginationInfo? pagination,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? pageSize,
  }) {
    return EmployeeLeaveHistoryState(
      employeeGuid: employeeGuid ?? this.employeeGuid,
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
