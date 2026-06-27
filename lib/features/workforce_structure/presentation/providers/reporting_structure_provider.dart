import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_relationship.dart';
import 'package:grc/features/workforce_structure/domain/repositories/reporting_structure_repository.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_repositories_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportingStatsProvider = Provider<ReportingStats>((ref) {
  final state = ref.watch(reportingStructureNotifierProvider);

  final positions = state.items;

  final topLevelCount = positions.where((p) => p.isTopLevel).length;
  final withReportsCount = positions.where((p) => p.hasDirectReports).length;
  final departmentsCount = positions.map((p) => p.department).toSet().length;

  return ReportingStats(
    totalPositions: state.totalItems,
    topLevelCount: topLevelCount,
    withReportsCount: withReportsCount,
    departmentsCount: departmentsCount,
  );
});

class ReportingStats {
  final int totalPositions;
  final int topLevelCount;
  final int withReportsCount;
  final int departmentsCount;

  const ReportingStats({
    required this.totalPositions,
    required this.topLevelCount,
    required this.withReportsCount,
    required this.departmentsCount,
  });
}

final reportingStructureNotifierProvider =
    StateNotifierProvider<ReportingStructureNotifier, PaginationState<ReportingPosition>>((ref) {
      final repository = ref.watch(reportingStructureRepositoryProvider);
      final tenantId = ref.watch(reportingStructureEnterpriseIdProvider);
      final notifier = ReportingStructureNotifier(repository, tenantId);
      Future.microtask(() => notifier.loadFirstPage());
      return notifier;
    });

class ReportingStructureNotifier extends StateNotifier<PaginationState<ReportingPosition>>
    with PaginationMixin<ReportingPosition> {
  final ReportingStructureRepository _repository;
  final int? _tenantId;
  List<ReportingRelationship> _allRelationships = [];

  ReportingStructureNotifier(this._repository, this._tenantId) : super(const PaginationState<ReportingPosition>());

  Future<void> loadFirstPage() async {
    state = handleLoadingState(state, true);
    try {
      _allRelationships = await _repository.getReportingRelationships(tenantId: _tenantId);
      final flattened = _flattenHierarchy(_allRelationships);

      _applyPaginatedData(flattened, 1);
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage) return;
    state = handleLoadingState(state, false);

    try {
      if (_allRelationships.isEmpty) {
        _allRelationships = await _repository.getReportingRelationships(tenantId: _tenantId);
      }
      final flattened = _flattenHierarchy(_allRelationships);
      _applyPaginatedData(flattened, state.currentPage + 1);
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  Future<void> goToPage(int page) async {
    state = handleLoadingState(state, true);
    try {
      if (_allRelationships.isEmpty) {
        _allRelationships = await _repository.getReportingRelationships(tenantId: _tenantId);
      }
      final flattened = _flattenHierarchy(_allRelationships);
      _applyPaginatedData(flattened, page);
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  Future<void> refresh() async {
    await loadFirstPage();
  }

  List<ReportingPosition> _flattenHierarchy(List<ReportingRelationship> relationships) {
    final List<ReportingPosition> result = [];
    for (final rel in relationships) {
      result.add(rel.toReportingPosition());
      if (rel.directReports.isNotEmpty) {
        result.addAll(_flattenHierarchy(rel.directReports));
      }
    }
    return result;
  }

  void _applyPaginatedData(List<ReportingPosition> allItems, int page) {
    final startIndex = (page - 1) * state.pageSize;
    final endIndex = startIndex + state.pageSize;
    final items = allItems.skip(startIndex).take(state.pageSize).toList();

    state = handleSuccessState(
      currentState: state,
      newItems: items,
      currentPage: page,
      pageSize: state.pageSize,
      totalItems: allItems.length,
      totalPages: (allItems.length / state.pageSize).ceil(),
      hasNextPage: endIndex < allItems.length,
      hasPreviousPage: page > 1,
      isFirstPage: page == 1,
    );
  }
}
