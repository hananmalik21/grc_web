import 'package:grc/features/leave_management/data/datasources/policy_history_local_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/policy_history_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/policy_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for policy history local data source
final policyHistoryLocalDataSourceProvider = Provider<PolicyHistoryLocalDataSource>(
  (ref) => PolicyHistoryLocalDataSourceImpl(),
);

/// Provider for policy history repository
final policyHistoryRepositoryProvider = Provider<PolicyHistoryRepositoryImpl>(
  (ref) => PolicyHistoryRepositoryImpl(localDataSource: ref.watch(policyHistoryLocalDataSourceProvider)),
);

/// Provider for policy history by policy name
final policyHistoryProvider = FutureProvider.family<List<PolicyHistory>, String>((ref, policyName) async {
  final repository = ref.watch(policyHistoryRepositoryProvider);
  try {
    return await repository.getPolicyHistory(policyName);
  } catch (e) {
    throw Exception('Failed to load policy history: ${e.toString()}');
  }
});
