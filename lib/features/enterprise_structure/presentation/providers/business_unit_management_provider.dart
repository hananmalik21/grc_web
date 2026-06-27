import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_business_units_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for business unit list with pagination
class BusinessUnitListState {
  final List<BusinessUnitOverview> businessUnits;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final bool hasError;
  final PaginationInfo? pagination;
  final int total;
  final int currentPage;
  final int pageSize;
  final String? searchQuery;

  const BusinessUnitListState({
    this.businessUnits = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.hasError = false,
    this.pagination,
    this.total = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.searchQuery,
  });

  BusinessUnitListState copyWith({
    List<BusinessUnitOverview>? businessUnits,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool? hasError,
    PaginationInfo? pagination,
    int? total,
    int? currentPage,
    int? pageSize,
    String? searchQuery,
  }) {
    return BusinessUnitListState(
      businessUnits: businessUnits ?? this.businessUnits,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      pagination: pagination ?? this.pagination,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasMore => pagination?.hasNext ?? false;
  bool get hasPrevious => pagination?.hasPrevious ?? false;
}

/// Notifier for business unit list with pagination
class BusinessUnitListNotifier extends StateNotifier<BusinessUnitListState> {
  final GetBusinessUnitsUseCase getBusinessUnitsUseCase;
  bool _isDisposed = false;

  BusinessUnitListNotifier({required this.getBusinessUnitsUseCase})
      : super(const BusinessUnitListState()) {
    Future.microtask(() {
      if (!_isDisposed) {
        loadBusinessUnits();
      }
    });
  }

  /// Constructor with custom page size
  BusinessUnitListNotifier.withPageSize({
    required this.getBusinessUnitsUseCase,
    int pageSize = 1000,
  }) : super(BusinessUnitListState(pageSize: pageSize)) {
    Future.microtask(() {
      if (!_isDisposed) {
        loadBusinessUnits();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Load business units for the first page
  Future<void> loadBusinessUnits({bool refresh = false, String? search}) async {
    if (_isDisposed) return;

    final searchQuery = search ?? state.searchQuery;

    if (refresh) {
      if (_isDisposed) return;
      state = state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: null,
        currentPage: 1,
        searchQuery: searchQuery,
      );
    } else if (state.isLoading) {
      return; // Already loading
    } else {
      if (_isDisposed) return;
      state = state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: null,
        searchQuery: searchQuery,
      );
    }

    try {
      final result = await getBusinessUnitsUseCase(
        search: searchQuery?.isEmpty == true ? null : searchQuery,
        page: refresh ? 1 : state.currentPage,
        pageSize: state.pageSize,
      );

      if (_isDisposed) return;

      try {
        state = state.copyWith(
          businessUnits: result.businessUnits,
          pagination: result.pagination,
          total: result.total,
          isLoading: false,
          hasError: false,
          currentPage: result.pagination.page,
        );
      } catch (e) {
        if (!_isDisposed) rethrow;
      }
    } on AppException catch (e) {
      if (_isDisposed) return;
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: e.message,
        );
      } catch (_) {
        // Ignore if disposed
      }
    } catch (e) {
      if (_isDisposed) return;
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Failed to load business units: ${e.toString()}',
        );
      } catch (_) {
        // Ignore if disposed
      }
    }
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await getBusinessUnitsUseCase(
        search: state.searchQuery?.isEmpty == true ? null : state.searchQuery,
        page: nextPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        businessUnits: [...state.businessUnits, ...result.businessUnits],
        pagination: result.pagination,
        total: result.total,
        isLoadingMore: false,
        currentPage: nextPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load more business units: ${e.toString()}',
      );
    }
  }

  /// Load previous page
  Future<void> loadPreviousPage() async {
    if (state.isLoading || !state.hasPrevious) return;

    state = state.copyWith(isLoading: true);

    try {
      final previousPage = state.currentPage - 1;
      final result = await getBusinessUnitsUseCase(
        search: state.searchQuery?.isEmpty == true ? null : state.searchQuery,
        page: previousPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        businessUnits: result.businessUnits,
        pagination: result.pagination,
        total: result.total,
        isLoading: false,
        currentPage: previousPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load business units: ${e.toString()}',
      );
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    await loadBusinessUnits(refresh: true);
  }

  /// Search business units
  Future<void> search(String query) async {
    await loadBusinessUnits(refresh: true, search: query);
  }
}

/// Provider for business unit list notifier
final businessUnitListNotifierProvider =
    StateNotifierProvider.autoDispose<BusinessUnitListNotifier, BusinessUnitListState>(
  (ref) {
    final getBusinessUnitsUseCase = ref.watch(getBusinessUnitsUseCaseProvider);
    return BusinessUnitListNotifier(getBusinessUnitsUseCase: getBusinessUnitsUseCase);
  },
);

/// Legacy provider for backward compatibility (returns list directly)
final businessUnitListProvider = Provider<List<BusinessUnitOverview>>((ref) {
  final state = ref.watch(businessUnitListNotifierProvider);
  return state.businessUnits;
});

final businessUnitSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for filtered business units with search
final filteredBusinessUnitsProvider = Provider<List<BusinessUnitOverview>>((ref) {
  final state = ref.watch(businessUnitListNotifierProvider);
  final query = ref.watch(businessUnitSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return state.businessUnits;

  return state.businessUnits.where((bu) {
    return bu.name.toLowerCase().contains(query) ||
        bu.code.toLowerCase().contains(query) ||
        bu.headName.toLowerCase().contains(query);
  }).toList();
});

