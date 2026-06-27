import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/forfeit_policy_local_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/forfeit_policy_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_policy.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_policy_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForfeitPolicyState {
  final List<ForfeitPolicy>? data;
  final bool isLoading;
  final String? error;

  const ForfeitPolicyState({this.data, this.isLoading = false, this.error});

  ForfeitPolicyState copyWith({List<ForfeitPolicy>? data, bool? isLoading, String? error}) {
    return ForfeitPolicyState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

/// Provider for forfeit policy local data source
final forfeitPolicyLocalDataSourceProvider = Provider<ForfeitPolicyLocalDataSource>((ref) {
  return ForfeitPolicyLocalDataSourceImpl();
});

/// Provider for forfeit policy repository
final forfeitPolicyRepositoryProvider = Provider<ForfeitPolicyRepository>((ref) {
  final localDataSource = ref.watch(forfeitPolicyLocalDataSourceProvider);
  return ForfeitPolicyRepositoryImpl(localDataSource: localDataSource);
});

class ForfeitPolicyNotifier extends StateNotifier<ForfeitPolicyState> {
  final ForfeitPolicyRepository _repository;

  ForfeitPolicyNotifier(this._repository) : super(const ForfeitPolicyState(isLoading: false));

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _repository.getForfeitPolicies();
      state = state.copyWith(data: list, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load forfeit policies: ${e.toString()}', isLoading: false);
    }
  }

  Future<void> refresh() async {
    await _load();
  }
}

final forfeitPolicyNotifierProvider = StateNotifierProvider<ForfeitPolicyNotifier, ForfeitPolicyState>((ref) {
  final repository = ref.watch(forfeitPolicyRepositoryProvider);
  return ForfeitPolicyNotifier(repository);
});

final forfeitPoliciesProvider = Provider<AsyncValue<List<ForfeitPolicy>>>((ref) {
  final state = ref.watch(forfeitPolicyNotifierProvider);

  if (state.isLoading && state.data == null) {
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
