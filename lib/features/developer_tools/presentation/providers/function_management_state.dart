import 'package:grc/features/developer_tools/domain/models/security_function.dart';

class FunctionManagementState {
  static const int maxPageSize = 10;

  const FunctionManagementState({
    this.searchQuery = '',
    this.currentPage = 1,
    this.pageSize = 10,
    this.functions = const [],
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.isLoading = false,
    this.error,
  });

  final String searchQuery;
  final int currentPage;
  final int pageSize;
  final List<SecurityFunction> functions;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final bool isLoading;
  final String? error;

  int get safeCurrentPage => currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);
  int get effectivePageSize => pageSize.clamp(1, maxPageSize).toInt();

  FunctionManagementState copyWith({
    String? searchQuery,
    int? currentPage,
    int? pageSize,
    List<SecurityFunction>? functions,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return FunctionManagementState(
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      pageSize: (pageSize ?? this.pageSize).clamp(1, maxPageSize).toInt(),
      functions: functions ?? this.functions,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
