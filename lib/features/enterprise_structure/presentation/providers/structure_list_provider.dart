import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_structure_list_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StructureListState {
  final List<StructureListItem> structures;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final bool hasError;
  final PaginationInfo? pagination;
  final int total;
  final int currentPage;
  final int pageSize;

  const StructureListState({
    this.structures = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.hasError = false,
    this.pagination,
    this.total = 0,
    this.currentPage = 1,
    this.pageSize = 10,
  });

  StructureListState copyWith({
    List<StructureListItem>? structures,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool? hasError,
    PaginationInfo? pagination,
    int? total,
    int? currentPage,
    int? pageSize,
  }) {
    return StructureListState(
      structures: structures ?? this.structures,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      pagination: pagination ?? this.pagination,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  bool get hasMore => pagination?.hasNext ?? false;
  bool get hasPrevious => pagination?.hasPrevious ?? false;
}

enum StructureListViewStateType { initialLoading, error, empty, content }

class StructureListViewState {
  final StructureListViewStateType type;
  final StructureListState? state;
  final String? errorMessage;

  const StructureListViewState._(this.type, [this.state, this.errorMessage]);

  factory StructureListViewState.initialLoading() =>
      const StructureListViewState._(StructureListViewStateType.initialLoading);

  factory StructureListViewState.error(String? message) =>
      StructureListViewState._(StructureListViewStateType.error, null, message);

  factory StructureListViewState.empty() => const StructureListViewState._(StructureListViewStateType.empty);

  factory StructureListViewState.content(StructureListState state) =>
      StructureListViewState._(StructureListViewStateType.content, state);
}

class StructureListNotifier extends StateNotifier<StructureListState> {
  final GetStructureListUseCase getStructureListUseCase;
  final int? Function()? enterpriseIdGetter;
  bool _isDisposed = false;

  StructureListNotifier({required this.getStructureListUseCase, this.enterpriseIdGetter})
    : super(const StructureListState()) {
    Future.microtask(() {
      if (!_isDisposed) {
        loadStructures();
      }
    });
  }

  StructureListNotifier.withPageSize({
    required this.getStructureListUseCase,
    this.enterpriseIdGetter,
    int pageSize = 1000,
  }) : super(StructureListState(pageSize: pageSize)) {
    Future.microtask(() {
      if (!_isDisposed) {
        loadStructuresWithPageSize(pageSize: pageSize);
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadStructures({bool refresh = false}) async {
    if (_isDisposed) return;

    final enterpriseId = enterpriseIdGetter?.call();
    if (enterpriseId == null) {
      state = state.copyWith(
        structures: const [],
        isLoading: false,
        hasError: false,
        errorMessage: null,
        total: 0,
        currentPage: 1,
      );
      return;
    }

    if (refresh) {
      if (_isDisposed) return;
      state = state.copyWith(isLoading: true, hasError: false, errorMessage: null, currentPage: 1);
    } else if (state.isLoading) {
      return;
    } else {
      if (_isDisposed) return;
      state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);
    }

    try {
      final result = await getStructureListUseCase(
        enterpriseId: enterpriseId,
        page: refresh ? 1 : state.currentPage,
        pageSize: state.pageSize,
      );

      if (_isDisposed) return;

      try {
        state = state.copyWith(
          structures: result.structures,
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
        state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
      } catch (_) {}
    } catch (e) {
      if (_isDisposed) return;
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Failed to load structures: ${e.toString()}',
        );
      } catch (_) {}
    }
  }

  Future<void> loadStructuresWithPageSize({int pageSize = 1000}) async {
    if (_isDisposed || state.isLoading) return;

    final enterpriseId = enterpriseIdGetter?.call();
    if (enterpriseId == null) {
      state = state.copyWith(
        structures: const [],
        isLoading: false,
        hasError: false,
        errorMessage: null,
        total: 0,
        currentPage: 1,
        pageSize: pageSize,
      );
      return;
    }

    if (_isDisposed) return;
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null, currentPage: 1, pageSize: pageSize);

    try {
      final result = await getStructureListUseCase(enterpriseId: enterpriseId, page: 1, pageSize: pageSize);

      if (_isDisposed) return;

      try {
        state = state.copyWith(
          structures: result.structures,
          pagination: result.pagination,
          total: result.total,
          isLoading: false,
          hasError: false,
          currentPage: result.pagination.page,
          pageSize: pageSize,
        );
      } catch (e) {
        if (!_isDisposed) rethrow;
      }
    } on AppException catch (e) {
      if (_isDisposed) return;
      try {
        state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
      } catch (_) {}
    } catch (e) {
      if (_isDisposed) return;
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Failed to load structures: ${e.toString()}',
        );
      } catch (_) {}
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    final enterpriseId = enterpriseIdGetter?.call();
    if (enterpriseId == null) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await getStructureListUseCase(
        enterpriseId: enterpriseId,
        page: nextPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        structures: [...state.structures, ...result.structures],
        pagination: result.pagination,
        total: result.total,
        isLoadingMore: false,
        currentPage: nextPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoadingMore: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load more structures: ${e.toString()}',
      );
    }
  }

  Future<void> loadPreviousPage() async {
    if (state.isLoading || !state.hasPrevious) return;

    final enterpriseId = enterpriseIdGetter?.call();
    if (enterpriseId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final previousPage = state.currentPage - 1;
      final result = await getStructureListUseCase(
        enterpriseId: enterpriseId,
        page: previousPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        structures: result.structures,
        pagination: result.pagination,
        total: result.total,
        isLoading: false,
        currentPage: previousPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load structures: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() async {
    await loadStructures(refresh: true);
  }

  void setStructureActive(String structureId, bool isActive) {
    final updated = state.structures.map((s) {
      if (s.structureId == structureId) return s.copyWith(isActive: isActive);
      return isActive ? s.copyWith(isActive: false) : s;
    }).toList();
    state = state.copyWith(structures: updated);
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || (state.pagination != null && page > state.pagination!.totalPages)) return;
    if (page == state.currentPage) return;

    final enterpriseId = enterpriseIdGetter?.call();
    if (enterpriseId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final result = await getStructureListUseCase(enterpriseId: enterpriseId, page: page, pageSize: state.pageSize);

      state = state.copyWith(
        structures: result.structures,
        pagination: result.pagination,
        total: result.total,
        isLoading: false,
        currentPage: page,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load structures: ${e.toString()}',
      );
    }
  }
}
