import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/domain/repositories/manage_employees_list_repository.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportingToEmployeeSearchState {
  final List<EmployeeListItem> items;
  final bool isLoading;
  final String? searchQuery;

  const ReportingToEmployeeSearchState({this.items = const [], this.isLoading = false, this.searchQuery});

  ReportingToEmployeeSearchState copyWith({List<EmployeeListItem>? items, bool? isLoading, String? searchQuery}) {
    return ReportingToEmployeeSearchState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ReportingToEmployeeSearchNotifier extends StateNotifier<ReportingToEmployeeSearchState> {
  final ManageEmployeesListRepository _repository;
  final int? Function() _getEnterpriseId;

  ReportingToEmployeeSearchNotifier(this._repository, this._getEnterpriseId)
    : super(const ReportingToEmployeeSearchState());

  Future<void> loadFirstPage() async {
    await search(null);
  }

  Future<void> search(String? query) async {
    final enterpriseId = _getEnterpriseId();
    if (enterpriseId == null) {
      state = state.copyWith(items: [], isLoading: false, searchQuery: query);
      return;
    }

    state = state.copyWith(isLoading: true, searchQuery: query);

    try {
      final result = await _repository.getEmployees(
        enterpriseId: enterpriseId,
        page: 1,
        pageSize: 25,
        search: (query?.trim().isEmpty ?? true) ? null : query!.trim(),
      );
      state = state.copyWith(items: result.items, isLoading: false);
    } catch (_) {
      state = state.copyWith(items: [], isLoading: false);
    }
  }
}

final reportingToEmployeeSearchNotifierProvider =
    StateNotifierProvider<ReportingToEmployeeSearchNotifier, ReportingToEmployeeSearchState>((ref) {
      final repository = ref.read(manageEmployeesListRepositoryProvider);
      return ReportingToEmployeeSearchNotifier(repository, () => ref.read(manageEmployeesEnterpriseIdProvider));
    });
