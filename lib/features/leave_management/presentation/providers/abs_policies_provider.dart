import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/abs_policies_remote_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/abs_policies_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/paginated_policies.dart';
import 'package:grc/features/leave_management/domain/models/leave_policy.dart';
import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/leave_management/domain/repositories/abs_policies_repository.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_policies_filter_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbsPoliciesState {
  final PaginatedPolicies? data;
  final bool isLoading;
  final String? error;

  const AbsPoliciesState({this.data, this.isLoading = false, this.error});

  AbsPoliciesState copyWith({PaginatedPolicies? data, bool? isLoading, String? error}) {
    return AbsPoliciesState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

final _absPoliciesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final absPoliciesRemoteDataSourceProvider = Provider<AbsPoliciesRemoteDataSource>((ref) {
  final apiClient = ref.watch(_absPoliciesApiClientProvider);
  return AbsPoliciesRemoteDataSourceImpl(apiClient: apiClient);
});

final absPoliciesRepositoryProvider = Provider<AbsPoliciesRepository>((ref) {
  final remoteDataSource = ref.watch(absPoliciesRemoteDataSourceProvider);
  return AbsPoliciesRepositoryImpl(remoteDataSource: remoteDataSource);
});

final absPoliciesPaginationProvider = StateProvider<({int page, int pageSize})>((ref) {
  return (page: 1, pageSize: 10);
});

class AbsPoliciesNotifier extends StateNotifier<AbsPoliciesState> {
  final AbsPoliciesRepository _repository;
  final Ref _ref;
  final Provider<int?> _enterpriseIdProvider;
  final StateProvider<({int page, int pageSize})> _paginationProvider;

  AbsPoliciesNotifier(this._repository, this._ref, this._enterpriseIdProvider, this._paginationProvider)
    : super(const AbsPoliciesState(isLoading: false)) {
    _ref.listen(_paginationProvider, (previous, next) {
      if (previous != next) _load();
    });
    _ref.listen<int?>(_enterpriseIdProvider, (previous, next) {
      if (previous != next) {
        state = const AbsPoliciesState(data: null, isLoading: true, error: null);
        final pagination = _ref.read(_paginationProvider);
        if (pagination.page != 1) {
          _ref.read(_paginationProvider.notifier).state = (page: 1, pageSize: pagination.pageSize);
        }
        _load();
      }
    });
  }

  Future<void> _load() async {
    final pagination = _ref.read(_paginationProvider);
    final tenantId = _ref.read(_enterpriseIdProvider);

    state = AbsPoliciesState(data: null, isLoading: true, error: null);

    if (tenantId == null) {
      state = state.copyWith(data: PaginatedPolicies.empty, isLoading: false, error: null);
      return;
    }

    try {
      final data = await _repository.getPolicies(
        tenantId: tenantId,
        page: pagination.page,
        pageSize: pagination.pageSize,
      );
      state = state.copyWith(data: data, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load leave policies: ${e.toString()}', isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = const AbsPoliciesState(isLoading: true);
    final pagination = _ref.read(_paginationProvider);
    if (pagination.page != 1) {
      _ref.read(_paginationProvider.notifier).state = (page: 1, pageSize: pagination.pageSize);
    } else {
      await _load();
    }
  }

  void replacePolicyWith(PolicyListItem updated) {
    final current = state.data;
    if (current == null) return;
    final list = current.policies.toList();
    final index = list.indexWhere((p) => p.policyGuid == updated.policyGuid);
    if (index < 0) return;
    list[index] = updated;
    state = state.copyWith(
      data: PaginatedPolicies(policies: list, pagination: current.pagination),
    );
  }

  void addPolicy(PolicyListItem created) {
    final current = state.data;
    final list = current != null ? [created, ...current.policies] : [created];
    final pagination =
        current?.pagination ??
        const PaginationInfo(
          currentPage: 1,
          totalPages: 1,
          totalItems: 1,
          pageSize: 10,
          hasNext: false,
          hasPrevious: false,
        );
    state = state.copyWith(
      data: PaginatedPolicies(policies: list, pagination: pagination),
    );
  }

  void removePolicyByGuid(String policyGuid) {
    final current = state.data;
    if (current == null) return;
    final list = current.policies.where((p) => p.policyGuid != policyGuid).toList();
    state = state.copyWith(
      data: PaginatedPolicies(policies: list, pagination: current.pagination),
    );
  }
}

final absPoliciesNotifierProvider = StateNotifierProvider<AbsPoliciesNotifier, AbsPoliciesState>((ref) {
  final repository = ref.watch(absPoliciesRepositoryProvider);
  return AbsPoliciesNotifier(repository, ref, leaveManagementEnterpriseIdProvider, absPoliciesPaginationProvider);
});

// Leave Policies Tab specific providers
final leavePoliciesTabAbsPoliciesPaginationProvider = StateProvider<({int page, int pageSize})>((ref) {
  return (page: 1, pageSize: 10);
});

final leavePoliciesTabAbsPoliciesNotifierProvider = StateNotifierProvider<AbsPoliciesNotifier, AbsPoliciesState>((ref) {
  final repository = ref.watch(absPoliciesRepositoryProvider);
  return AbsPoliciesNotifier(
    repository,
    ref,
    leavePoliciesTabEnterpriseIdProvider,
    leavePoliciesTabAbsPoliciesPaginationProvider,
  );
});

// Policy Configuration Tab specific providers
final policyConfigurationTabAbsPoliciesPaginationProvider = StateProvider<({int page, int pageSize})>((ref) {
  return (page: 1, pageSize: 10);
});

final policyConfigurationTabAbsPoliciesNotifierProvider = StateNotifierProvider<AbsPoliciesNotifier, AbsPoliciesState>((
  ref,
) {
  final repository = ref.watch(absPoliciesRepositoryProvider);
  return AbsPoliciesNotifier(
    repository,
    ref,
    policyConfigurationTabEnterpriseIdProvider,
    policyConfigurationTabAbsPoliciesPaginationProvider,
  );
});

final absPoliciesProvider = Provider<AsyncValue<PaginatedPolicies>>((ref) {
  final state = ref.watch(absPoliciesNotifierProvider);
  return _mapStateToAsyncValue(state);
});

final leavePoliciesTabAbsPoliciesProvider = Provider<AsyncValue<PaginatedPolicies>>((ref) {
  final state = ref.watch(leavePoliciesTabAbsPoliciesNotifierProvider);
  return _mapStateToAsyncValue(state);
});

final policyConfigurationTabAbsPoliciesProvider = Provider<AsyncValue<PaginatedPolicies>>((ref) {
  final state = ref.watch(policyConfigurationTabAbsPoliciesNotifierProvider);
  return _mapStateToAsyncValue(state);
});

AsyncValue<PaginatedPolicies> _mapStateToAsyncValue(AbsPoliciesState state) {
  if (state.error != null) {
    return AsyncValue.error(Exception(state.error!), StackTrace.current);
  }
  if (state.isLoading && state.data == null) {
    return const AsyncValue.loading();
  }
  if (state.data != null) {
    return AsyncValue.data(state.data!);
  }
  return const AsyncValue.loading();
}

final leavePoliciesFromAbsProvider = Provider<AsyncValue<List<LeavePolicy>>>((ref) {
  final paginated = ref.watch(absPoliciesProvider);
  return _mapPaginatedToFilteredPolicies(ref, paginated);
});

final leavePoliciesTabLeavePoliciesFromAbsProvider = Provider<AsyncValue<List<LeavePolicy>>>((ref) {
  final paginated = ref.watch(leavePoliciesTabAbsPoliciesProvider);
  return _mapPaginatedToFilteredPolicies(ref, paginated);
});

AsyncValue<List<LeavePolicy>> _mapPaginatedToFilteredPolicies(Ref ref, AsyncValue<PaginatedPolicies> paginated) {
  final filter = ref.watch(leavePoliciesFilterProvider);

  return paginated.when(
    data: (data) {
      var list = data.policies.map(LeavePolicy.fromPolicyListItem).toList();
      if (filter.status != null) {
        list = list.where((p) => p.status == filter.status).toList();
      }
      if (filter.type == 'kuwait_y') {
        list = list.where((p) => p.kuwaitLaborCompliant == 'Y').toList();
      } else if (filter.type == 'kuwait_n') {
        list = list.where((p) => p.kuwaitLaborCompliant == 'N').toList();
      }
      return AsyncValue.data(list);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
}

final selectedPolicyGuidProvider = StateNotifierProvider<SelectedPolicyGuidNotifier, String?>((ref) {
  return SelectedPolicyGuidNotifier(ref, absPoliciesNotifierProvider);
});

final policyConfigurationTabSelectedPolicyGuidProvider = StateNotifierProvider<SelectedPolicyGuidNotifier, String?>((
  ref,
) {
  return SelectedPolicyGuidNotifier(ref, policyConfigurationTabAbsPoliciesNotifierProvider);
});

class SelectedPolicyGuidNotifier extends StateNotifier<String?> {
  SelectedPolicyGuidNotifier(this._ref, this._policiesProvider) : super(null) {
    _ref.listen<AbsPoliciesState>(_policiesProvider, (_, next) {
      _syncWithPolicies(next.data?.policies ?? []);
    });
  }

  final Ref _ref;
  final StateNotifierProvider<AbsPoliciesNotifier, AbsPoliciesState> _policiesProvider;

  void _syncWithPolicies(List<PolicyListItem> policies) {
    final needSelection = state == null && policies.isNotEmpty;
    final selectionMissing = state != null && policies.isNotEmpty && !policies.any((p) => p.policyGuid == state);
    if (needSelection || selectionMissing) {
      state = policies.isNotEmpty ? policies.first.policyGuid : null;
    }
  }

  void setSelectedPolicyGuid(String? guid) {
    state = guid;
  }
}

final selectedPolicyConfigurationProvider = Provider<PolicyListItem?>((ref) {
  final paginated = ref.watch(absPoliciesProvider).value;
  final guid = ref.watch(selectedPolicyGuidProvider);
  return _mapGuidToPolicy(paginated, guid);
});

final policyConfigurationTabSelectedPolicyConfigurationProvider = Provider<PolicyListItem?>((ref) {
  final paginated = ref.watch(policyConfigurationTabAbsPoliciesProvider).value;
  final guid = ref.watch(policyConfigurationTabSelectedPolicyGuidProvider);
  return _mapGuidToPolicy(paginated, guid);
});

PolicyListItem? _mapGuidToPolicy(PaginatedPolicies? paginated, String? guid) {
  final policies = paginated?.policies ?? [];
  if (guid == null || policies.isEmpty) return null;
  return policies.where((p) => p.policyGuid == guid).firstOrNull;
}

final currentPolicyDisplayDetailProvider = Provider<PolicyDetail?>((ref) {
  final draft = ref.watch(policyDraftProvider);
  final policy = ref.watch(selectedPolicyConfigurationProvider);
  return draft ?? policy?.detail;
});

final policyConfigurationTabCurrentPolicyDisplayDetailProvider = Provider<PolicyDetail?>((ref) {
  final draft = ref.watch(policyDraftProvider);
  final policy = ref.watch(policyConfigurationTabSelectedPolicyConfigurationProvider);
  return draft ?? policy?.detail;
});
