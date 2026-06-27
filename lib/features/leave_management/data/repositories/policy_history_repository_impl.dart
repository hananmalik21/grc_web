import 'package:grc/features/leave_management/data/datasources/policy_history_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/policy_history.dart';

/// Repository implementation for policy history
class PolicyHistoryRepositoryImpl {
  final PolicyHistoryLocalDataSource localDataSource;

  PolicyHistoryRepositoryImpl({required this.localDataSource});

  Future<List<PolicyHistory>> getPolicyHistory(String policyName) async {
    try {
      return localDataSource.getPolicyHistory(policyName);
    } catch (e) {
      throw Exception('Failed to load policy history: ${e.toString()}');
    }
  }
}
