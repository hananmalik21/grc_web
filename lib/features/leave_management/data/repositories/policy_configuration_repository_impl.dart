import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/policy_configuration_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/leave_type.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/domain/repositories/policy_configuration_repository.dart';

/// Implementation of PolicyConfigurationRepository
class PolicyConfigurationRepositoryImpl implements PolicyConfigurationRepository {
  final PolicyConfigurationLocalDataSource localDataSource;

  PolicyConfigurationRepositoryImpl({required this.localDataSource});

  @override
  Future<List<LeaveType>> getLeaveTypes() async {
    try {
      return localDataSource.getLeaveTypes();
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave types: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<PolicyConfiguration?> getPolicyConfiguration(String policyName) async {
    try {
      return localDataSource.getPolicyConfiguration(policyName);
    } catch (e) {
      throw UnknownException(
        'Repository error: Failed to fetch policy configuration: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<PolicyConfiguration>> getAllPolicyConfigurations() async {
    try {
      return localDataSource.getAllPolicyConfigurations();
    } catch (e) {
      throw UnknownException(
        'Repository error: Failed to fetch all policy configurations: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
