import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/leave_requests_remote_data_source.dart';
import 'package:grc/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:grc/features/leave_management/data/repositories/leave_requests_repository_impl.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_actions_provider.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestsState {
  final PaginatedLeaveRequests? data;
  final bool isLoading;
  final String? error;

  const LeaveRequestsState({this.data, this.isLoading = false, this.error});

  LeaveRequestsState copyWith({PaginatedLeaveRequests? data, bool? isLoading, String? error}) {
    return LeaveRequestsState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final leaveRequestsRemoteDataSourceProvider = Provider<LeaveRequestsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaveRequestsRemoteDataSourceImpl(apiClient: apiClient);
});

final leaveRequestsRepositoryProvider = Provider<LeaveRequestsRepository>((ref) {
  final remoteDataSource = ref.watch(leaveRequestsRemoteDataSourceProvider);
  return LeaveRequestsRepositoryImpl(remoteDataSource: remoteDataSource);
});

final leaveRequestsPaginationProvider = StateProvider<({int page, int pageSize})>((ref) {
  return (page: 1, pageSize: 10);
});

class LeaveRequestsNotifier extends StateNotifier<LeaveRequestsState> {
  final LeaveRequestsRepository _repository;
  final Ref _ref;

  LeaveRequestsNotifier(this._repository, this._ref) : super(const LeaveRequestsState(isLoading: false)) {
    _ref.listen(leaveRequestsPaginationProvider, (previous, next) {
      if (previous != next) {
        _loadRequests();
      }
    });
    _ref.listen(leaveFilterProvider, (previous, next) {
      if (previous != next) {
        _loadRequests();
      }
    });
    _ref.listen(leaveManagementEnterpriseIdProvider, (previous, next) {
      if (previous != next) {
        _loadRequests();
      }
    });
  }

  String? _mapFilterToStatus(LeaveFilter filter) {
    switch (filter) {
      case LeaveFilter.all:
        return null;
      case LeaveFilter.draft:
        return 'DRAFT';
      case LeaveFilter.pending:
        return 'SUBMITTED';
      case LeaveFilter.approved:
        return 'APPROVED';
      case LeaveFilter.rejected:
        return 'REJECTED';
    }
  }

  Future<void> _loadRequests() async {
    final pagination = _ref.read(leaveRequestsPaginationProvider);
    final filter = _ref.read(leaveFilterProvider);
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
    final status = _mapFilterToStatus(filter);

    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _repository.getLeaveRequests(
        page: pagination.page,
        pageSize: pagination.pageSize,
        status: status,
        tenantId: tenantId,
      );
      state = state.copyWith(data: data, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load leave requests: ${e.toString()}', isLoading: false);
    }
  }

  Future<void> refresh() async {
    await _loadRequests();
  }

  Future<void> approveLeaveRequest(String guid) async {
    _ref.read(leaveRequestsApproveLoadingProvider.notifier).state = {
      ..._ref.read(leaveRequestsApproveLoadingProvider),
      guid,
    };

    try {
      final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
      await _repository.approveLeaveRequest(guid, tenantId: tenantId);

      if (state.data != null) {
        final updatedRequests = state.data!.requests.map((request) {
          if (request.guid == guid) {
            return TimeOffRequest(
              id: request.id,
              guid: request.guid,
              employeeId: request.employeeId,
              employeeName: request.employeeName,
              employeeGuid: request.employeeGuid,
              department: request.department,
              position: request.position,
              type: request.type,
              leaveTypeInfo: request.leaveTypeInfo,
              startDate: request.startDate,
              endDate: request.endDate,
              totalDays: request.totalDays,
              status: RequestStatus.approved,
              reason: request.reason,
              rejectionReason: request.rejectionReason,
              approvedBy: request.approvedBy,
              approvedByName: request.approvedByName,
              requestedAt: request.requestedAt,
              approvedAt: DateTime.now(),
              rejectedAt: request.rejectedAt,
            );
          }
          return request;
        }).toList();

        state = state.copyWith(
          data: PaginatedLeaveRequests(requests: updatedRequests, pagination: state.data!.pagination),
        );
      }
    } finally {
      final loadingSet = {..._ref.read(leaveRequestsApproveLoadingProvider)};
      loadingSet.remove(guid);
      _ref.read(leaveRequestsApproveLoadingProvider.notifier).state = loadingSet;
    }
  }

  Future<void> rejectLeaveRequest(String guid) async {
    _ref.read(leaveRequestsRejectLoadingProvider.notifier).state = {
      ..._ref.read(leaveRequestsRejectLoadingProvider),
      guid,
    };

    try {
      final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
      await _repository.rejectLeaveRequest(guid, tenantId: tenantId);

      if (state.data != null) {
        final updatedRequests = state.data!.requests.map((request) {
          if (request.guid == guid) {
            return TimeOffRequest(
              id: request.id,
              guid: request.guid,
              employeeId: request.employeeId,
              employeeName: request.employeeName,
              employeeGuid: request.employeeGuid,
              department: request.department,
              position: request.position,
              type: request.type,
              leaveTypeInfo: request.leaveTypeInfo,
              startDate: request.startDate,
              endDate: request.endDate,
              totalDays: request.totalDays,
              status: RequestStatus.rejected,
              reason: request.reason,
              rejectionReason: request.rejectionReason,
              approvedBy: request.approvedBy,
              approvedByName: request.approvedByName,
              requestedAt: request.requestedAt,
              approvedAt: request.approvedAt,
              rejectedAt: DateTime.now(),
            );
          }
          return request;
        }).toList();

        state = state.copyWith(
          data: PaginatedLeaveRequests(requests: updatedRequests, pagination: state.data!.pagination),
        );
      }
    } finally {
      final loadingSet = {..._ref.read(leaveRequestsRejectLoadingProvider)};
      loadingSet.remove(guid);
      _ref.read(leaveRequestsRejectLoadingProvider.notifier).state = loadingSet;
    }
  }

  Future<void> deleteLeaveRequest(String guid) async {
    try {
      final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
      await _repository.deleteLeaveRequest(guid, tenantId: tenantId);

      if (state.data != null) {
        final updatedRequests = state.data!.requests.where((request) => request.guid != guid).toList();
        final currentPagination = state.data!.pagination;
        final updatedPagination = PaginationInfo(
          currentPage: currentPagination.currentPage,
          totalPages: currentPagination.totalPages,
          totalItems: currentPagination.totalItems - 1,
          pageSize: currentPagination.pageSize,
          hasNext: currentPagination.hasNext,
          hasPrevious: currentPagination.hasPrevious,
        );

        state = state.copyWith(
          data: PaginatedLeaveRequests(requests: updatedRequests, pagination: updatedPagination),
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

final leaveRequestsNotifierProvider = StateNotifierProvider<LeaveRequestsNotifier, LeaveRequestsState>((ref) {
  final repository = ref.watch(leaveRequestsRepositoryProvider);
  return LeaveRequestsNotifier(repository, ref);
});

final leaveRequestsProvider = Provider<AsyncValue<PaginatedLeaveRequests>>((ref) {
  final state = ref.watch(leaveRequestsNotifierProvider);

  if (state.isLoading) {
    return const AsyncValue.loading();
  }

  if (state.error != null && state.data == null) {
    return AsyncValue.error(Exception(state.error!), StackTrace.current);
  }

  if (state.data != null) {
    return AsyncValue.data(state.data!);
  }

  return const AsyncValue.loading();
});

final filteredLeaveRequestsProvider = Provider<AsyncValue<List<TimeOffRequest>>>((ref) {
  final requestsAsync = ref.watch(leaveRequestsProvider);
  final filter = ref.watch(leaveFilterProvider);

  return requestsAsync.when(
    data: (paginatedResponse) {
      final filtered = _filterRequests(paginatedResponse.requests, filter);
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final leaveRequestsPaginationNotifierProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(leaveRequestsNotifierProvider.notifier).refresh();
  };
});

List<TimeOffRequest> _filterRequests(List<TimeOffRequest> requests, LeaveFilter filter) {
  if (filter == LeaveFilter.all) {
    return requests;
  }

  final statusMap = {
    LeaveFilter.draft: RequestStatus.draft,
    LeaveFilter.pending: RequestStatus.pending,
    LeaveFilter.approved: RequestStatus.approved,
    LeaveFilter.rejected: RequestStatus.rejected,
  };

  final targetStatus = statusMap[filter];
  return requests.where((request) => request.status == targetStatus).toList();
}
