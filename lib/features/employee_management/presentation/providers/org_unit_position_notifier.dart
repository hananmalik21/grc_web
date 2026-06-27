import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/models/position_response.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_positions_by_org_unit_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgUnitPositionNotifier extends StateNotifier<PaginationState<Position>>
    with PaginationMixin<Position>
    implements PaginationController<Position> {
  OrgUnitPositionNotifier(this._getPositionsByOrgUnitUseCase, this.tenantId, this.orgUnitId)
    : super(const PaginationState());

  final GetPositionsByOrgUnitUseCase _getPositionsByOrgUnitUseCase;
  final int? tenantId;
  final String orgUnitId;

  Future<PositionResponse> _fetch({required int page, required int pageSize}) {
    return _getPositionsByOrgUnitUseCase(
      orgUnitId: orgUnitId,
      page: page,
      pageSize: pageSize,
      search: state.searchQuery,
      status: state.status,
      tenantId: tenantId,
    );
  }

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _fetch(page: 1, pageSize: state.pageSize);

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
      final response = await _fetch(page: nextPage, pageSize: state.pageSize);

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
      final response = await _fetch(page: page, pageSize: state.pageSize);

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

  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}
