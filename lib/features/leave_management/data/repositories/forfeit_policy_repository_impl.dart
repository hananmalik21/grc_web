import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/forfeit_policy_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_policy.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_policy_repository.dart';

class ForfeitPolicyRepositoryImpl implements ForfeitPolicyRepository {
  final ForfeitPolicyLocalDataSource localDataSource;

  ForfeitPolicyRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ForfeitPolicy>> getForfeitPolicies() async {
    try {
      // Simulate async operation
      await Future.delayed(const Duration(milliseconds: 300));
      return localDataSource.getForfeitPolicies();
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch forfeit policies: ${e.toString()}', originalError: e);
    }
  }
}
