import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/leave_policies_remote_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/leave_policies_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/leave_policy.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_policies_repository.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_policies_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeavePoliciesState {
  final List<LeavePolicy>? data;
  final bool isLoading;
  final String? error;

  const LeavePoliciesState({this.data, this.isLoading = false, this.error});

  LeavePoliciesState copyWith({List<LeavePolicy>? data, bool? isLoading, String? error}) {
    return LeavePoliciesState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

final _leavePoliciesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final leavePoliciesRemoteDataSourceProvider = Provider<LeavePoliciesRemoteDataSource>((ref) {
  final apiClient = ref.watch(_leavePoliciesApiClientProvider);
  return LeavePoliciesRemoteDataSourceImpl(apiClient: apiClient);
});

final leavePoliciesRepositoryProvider = Provider<LeavePoliciesRepository>((ref) {
  final remoteDataSource = ref.watch(leavePoliciesRemoteDataSourceProvider);
  return LeavePoliciesRepositoryImpl(remoteDataSource: remoteDataSource);
});

String _accrualCodeToDisplay(String code) {
  switch (code.toUpperCase()) {
    case 'MONTHLY':
      return 'Monthly';
    case 'YEARLY':
      return 'Yearly';
    case 'NONE':
      return 'None';
    default:
      return code;
  }
}

class LeavePoliciesNotifier extends StateNotifier<LeavePoliciesState> {
  final LeavePoliciesRepository _repository;
  final Ref _ref;

  LeavePoliciesNotifier(this._repository, this._ref) : super(const LeavePoliciesState(isLoading: true)) {
    _ref.listen(leaveManagementEnterpriseIdProvider, (_, _) => _load());
    _ref.listen(leavePoliciesFilterProvider, (_, _) => _load());
    _load();
  }

  Future<void> _load() async {
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
    if (tenantId == null) {
      state = const LeavePoliciesState(data: [], isLoading: false);
      return;
    }

    final filter = _ref.read(leavePoliciesFilterProvider);
    String? kuwait;
    if (filter.type == 'kuwait_y') {
      kuwait = 'Y';
    } else if (filter.type == 'kuwait_n') {
      kuwait = 'N';
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getLeavePolicies(
        tenantId: tenantId,
        status: filter.status,
        kuwaitLaborCompliant: kuwait,
      );
      state = state.copyWith(data: list, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load leave policies: ${e.toString()}', isLoading: false);
    }
  }

  Future<LeavePolicy> createLeavePolicy(CreateLeavePolicyParams params) async {
    final created = await _repository.createLeavePolicy(params);
    final list = state.data ?? [];
    state = state.copyWith(data: [...list, created]);
    return created;
  }

  Future<void> updateLeavePolicy(String policyGuid, UpdateLeavePolicyParams params) async {
    final tenantId = _ref.read(leaveManagementEnterpriseIdProvider);
    await _repository.updateLeavePolicy(policyGuid, params, tenantId: tenantId);

    final list = state.data;
    if (list == null) return;

    final updated = list.map((p) {
      if (p.policyGuid != policyGuid) return p;
      return p.copyWith(
        nameEn: params.leaveTypeEn,
        entitlement: '${params.entitlementDays} days',
        accrualType: _accrualCodeToDisplay(params.accrualMethodCode),
        isKuwaitLaw: params.kuwaitLaborCompliant.toUpperCase() == 'Y',
        entitlementDays: params.entitlementDays,
        accrualMethodCode: params.accrualMethodCode,
        status: params.status,
        kuwaitLaborCompliant: params.kuwaitLaborCompliant,
      );
    }).toList();
    state = state.copyWith(data: updated);
  }
}

final leavePoliciesNotifierProvider = StateNotifierProvider<LeavePoliciesNotifier, LeavePoliciesState>((ref) {
  final repository = ref.watch(leavePoliciesRepositoryProvider);
  return LeavePoliciesNotifier(repository, ref);
});

final leavePoliciesProvider = Provider<AsyncValue<List<LeavePolicy>>>((ref) {
  final s = ref.watch(leavePoliciesNotifierProvider);

  if (s.isLoading && s.data == null) {
    return const AsyncValue.loading();
  }
  if (s.error != null && s.data == null) {
    return AsyncValue.error(Exception(s.error!), StackTrace.current);
  }
  if (s.data != null) {
    return AsyncValue.data(s.data!);
  }
  return const AsyncValue.loading();
});
