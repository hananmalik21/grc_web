import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/leave_management/data/datasources/leave_types_remote_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/leave_types_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/api_leave_type.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_types_repository.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final leaveTypesRemoteDataSourceProvider = Provider<LeaveTypesRemoteDataSource>((ref) {
  final apiClient = ref.watch(_apiClientProvider);
  return LeaveTypesRemoteDataSourceImpl(apiClient: apiClient);
});

final leaveTypesRepositoryProvider = Provider<LeaveTypesRepository>((ref) {
  final remoteDataSource = ref.watch(leaveTypesRemoteDataSourceProvider);
  return LeaveTypesRepositoryImpl(remoteDataSource: remoteDataSource);
});

class LeaveTypesState {
  final List<ApiLeaveType> leaveTypes;
  final bool isLoading;
  final String? error;
  final String? searchQuery;

  const LeaveTypesState({this.leaveTypes = const [], this.isLoading = false, this.error, this.searchQuery});

  LeaveTypesState copyWith({List<ApiLeaveType>? leaveTypes, bool? isLoading, String? error, String? searchQuery}) {
    return LeaveTypesState(
      leaveTypes: leaveTypes ?? this.leaveTypes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class LeaveTypesNotifier extends StateNotifier<LeaveTypesState> {
  final LeaveTypesRepository _repository;
  final Ref _ref;
  final Provider<int?> _enterpriseIdProvider;

  LeaveTypesNotifier(this._repository, this._ref, this._enterpriseIdProvider) : super(const LeaveTypesState()) {
    _ref.listen(_enterpriseIdProvider, (previous, next) {
      if (previous != next) {
        loadLeaveTypes();
      }
    });
    loadLeaveTypes();
  }

  Future<void> loadLeaveTypes({String? search}) async {
    state = state.copyWith(isLoading: true, error: null, searchQuery: search);
    try {
      final tenantId = _ref.read(_enterpriseIdProvider);
      final leaveTypes = await _repository.getLeaveTypes(search: search, tenantId: tenantId);
      state = state.copyWith(leaveTypes: leaveTypes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceFirst('Exception: ', ''), isLoading: false);
    }
  }

  void searchLeaveTypes(String query) {
    final trimmedQuery = query.trim();
    loadLeaveTypes(search: trimmedQuery.isEmpty ? null : trimmedQuery);
  }
}

final leaveTypesNotifierProvider = StateNotifierProvider<LeaveTypesNotifier, LeaveTypesState>((ref) {
  final repository = ref.watch(leaveTypesRepositoryProvider);
  return LeaveTypesNotifier(repository, ref, leaveManagementEnterpriseIdProvider);
});

final policyConfigurationTabLeaveTypesNotifierProvider = StateNotifierProvider<LeaveTypesNotifier, LeaveTypesState>((
  ref,
) {
  final repository = ref.watch(leaveTypesRepositoryProvider);
  return LeaveTypesNotifier(repository, ref, policyConfigurationTabEnterpriseIdProvider);
});
