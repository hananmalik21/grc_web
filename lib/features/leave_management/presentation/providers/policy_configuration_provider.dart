import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/policy_configuration_local_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/policy_configuration_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/leave_type.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for policy configuration local data source
final policyConfigurationLocalDataSourceProvider = Provider<PolicyConfigurationLocalDataSource>(
  (ref) => PolicyConfigurationLocalDataSourceImpl(),
);

/// Provider for policy configuration repository
final policyConfigurationRepositoryProvider = Provider<PolicyConfigurationRepositoryImpl>(
  (ref) => PolicyConfigurationRepositoryImpl(localDataSource: ref.watch(policyConfigurationLocalDataSourceProvider)),
);

/// Provider for leave types
final leaveTypesProvider = FutureProvider<List<LeaveType>>((ref) async {
  final repository = ref.watch(policyConfigurationRepositoryProvider);
  try {
    return await repository.getLeaveTypes();
  } on AppException {
    rethrow;
  } catch (e) {
    throw Exception('Failed to load leave types: ${e.toString()}');
  }
});

/// Provider for policy configuration by name
final policyConfigurationProvider = FutureProvider.family<PolicyConfiguration?, String>((ref, policyName) async {
  final repository = ref.watch(policyConfigurationRepositoryProvider);
  try {
    return await repository.getPolicyConfiguration(policyName);
  } on AppException {
    rethrow;
  } catch (e) {
    throw Exception('Failed to load policy configuration: ${e.toString()}');
  }
});

/// Provider for all policy configurations
final allPolicyConfigurationsProvider = FutureProvider<List<PolicyConfiguration>>((ref) async {
  final repository = ref.watch(policyConfigurationRepositoryProvider);
  try {
    return await repository.getAllPolicyConfigurations();
  } on AppException {
    rethrow;
  } catch (e) {
    throw Exception('Failed to load all policy configurations: ${e.toString()}');
  }
});
