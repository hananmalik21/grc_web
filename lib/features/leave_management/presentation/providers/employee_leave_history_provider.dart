import 'package:grc/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:grc/features/leave_management/presentation/providers/employee_leave_history_state.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeLeaveHistoryNotifier extends StateNotifier<EmployeeLeaveHistoryState> {
  EmployeeLeaveHistoryNotifier(this._repository, this._ref, String employeeGuid)
    : super(EmployeeLeaveHistoryState(employeeGuid: employeeGuid, currentPage: 1, pageSize: 10, isLoading: true)) {
    loadPage(1);
  }

  final LeaveRequestsRepository _repository;
  final Ref _ref;

  Future<void> loadPage(int page) async {
    state = state.copyWith(isLoading: true, error: null, currentPage: page);

    try {
      final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
      final result = await _repository.getEmployeeLeaveRequests(
        employeeGuid: state.employeeGuid,
        page: page,
        pageSize: state.pageSize,
        tenantId: tenantId,
      );

      state = state.copyWith(items: result.requests, pagination: result.pagination, isLoading: false, error: null);
    } catch (e, _) {
      state = state.copyWith(isLoading: false, error: e.toString(), items: [], pagination: null);
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 1) return;
    await loadPage(page);
  }

  Future<void> refresh() async {
    await loadPage(state.currentPage);
  }
}

final employeeLeaveHistoryNotifierProvider = StateNotifierProvider.autoDispose
    .family<EmployeeLeaveHistoryNotifier, EmployeeLeaveHistoryState, String>((ref, employeeGuid) {
      final repository = ref.watch(leaveRequestsRepositoryProvider);
      return EmployeeLeaveHistoryNotifier(repository, ref, employeeGuid);
    });
