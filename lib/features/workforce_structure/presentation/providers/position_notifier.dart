import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_position_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionNotifier extends StateNotifier<PaginationState<Position>>
    with PaginationMixin<Position>
    implements PaginationController<Position> {
  final GetPositionsUseCase _getPositionsUseCase;
  final CreatePositionUseCase _createPositionUseCase;
  final UpdatePositionUseCase _updatePositionUseCase;
  final DeletePositionUseCase _deletePositionUseCase;
  final int? tenantId;
  String? _deletingId;

  String? get deletingPositionId => _deletingId;

  PositionNotifier(
    this._getPositionsUseCase,
    this._createPositionUseCase,
    this._updatePositionUseCase,
    this._deletePositionUseCase,
    this.tenantId,
  ) : super(const PaginationState());

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getPositionsUseCase(
        page: 1,
        pageSize: state.pageSize,
        search: state.searchQuery,
        status: state.status,
        tenantId: tenantId,
      );

      state = handleSuccessState(
        currentState: state,
        newItems: response.positions,
        currentPage: response.page,
        pageSize: response.pageSize,
        totalItems: response.totalCount,
        totalPages: response.totalPages,
        hasNextPage: response.hasNext,
        hasPreviousPage: response.hasPrevious,
        isFirstPage: true,
      );
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    final previousPage = state.currentPage;
    final nextPage = state.currentPage + 1;
    state = handleLoadingState(state, false).copyWith(isLoading: true, currentPage: nextPage);

    try {
      final response = await _getPositionsUseCase(
        page: nextPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
        status: state.status,
        tenantId: tenantId,
      );

      state = handleSuccessState(
        currentState: state,
        newItems: response.positions,
        currentPage: response.page,
        pageSize: response.pageSize,
        totalItems: response.totalCount,
        totalPages: response.totalPages,
        hasNextPage: response.hasNext,
        hasPreviousPage: response.hasPrevious,
        isFirstPage: false,
      );
    } catch (e) {
      state = handleErrorState(state.copyWith(currentPage: previousPage), e.toString());
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getPositionsUseCase(
        page: page,
        pageSize: state.pageSize,
        search: state.searchQuery,
        status: state.status,
        tenantId: tenantId,
      );

      state = handleSuccessState(
        currentState: state,
        newItems: response.positions,
        currentPage: response.page,
        pageSize: response.pageSize,
        totalItems: response.totalCount,
        totalPages: response.totalPages,
        hasNextPage: response.hasNext,
        hasPreviousPage: response.hasPrevious,
        isFirstPage: true,
      );
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  @override
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = PaginationState(pageSize: state.pageSize);
  }

  void search(String? query) {
    final normalized = query?.trim() ?? '';
    if (state.searchQuery == normalized) return;

    state = state.copyWith(searchQuery: normalized);
    refresh();
  }

  void clearSearch() {
    if (state.searchQuery == null || state.searchQuery!.isEmpty) return;

    state = state.copyWith(searchQuery: '');
    refresh();
  }

  void setStatus(PositionStatus? status) {
    if (state.status == status) return;

    if (status == null) {
      state = state.copyWith(clearStatus: true);
    } else {
      state = state.copyWith(status: status);
    }
    refresh();
  }

  Future<Position> createPosition(Map<String, dynamic> positionData) async {
    try {
      final newPosition = await _createPositionUseCase(positionData, tenantId: tenantId);

      state = state.copyWith(items: [newPosition, ...state.items], totalItems: state.totalItems + 1);

      return newPosition;
    } catch (e) {
      rethrow;
    }
  }

  Future<Position> updatePosition(String id, Map<String, dynamic> positionData) async {
    try {
      final updatedPosition = await _updatePositionUseCase.execute(id, positionData, tenantId: tenantId);

      state = state.copyWith(items: state.items.map((p) => p.id == id ? updatedPosition : p).toList());

      return updatedPosition;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePosition(String id, {bool hard = true}) async {
    _deletingId = id;
    state = state.copyWith();
    try {
      await _deletePositionUseCase.execute(id, hard: hard, tenantId: tenantId);
      state = state.copyWith(items: state.items.where((p) => p.id != id).toList(), totalItems: state.totalItems - 1);
    } catch (e) {
      rethrow;
    } finally {
      _deletingId = null;
      if (state.items.isNotEmpty || true) state = state.copyWith();
    }
  }

  void updatePageSize(int newPageSize) {
    if (newPageSize != state.pageSize) {
      state = state.copyWith(pageSize: newPageSize);
      refresh();
    }
  }

  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}
