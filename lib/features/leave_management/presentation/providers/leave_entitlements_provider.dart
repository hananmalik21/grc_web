import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/leave_entitlement_local_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/leave_entitlement_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/leave_entitlement.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for leave entitlement local data source
final leaveEntitlementLocalDataSourceProvider = Provider<LeaveEntitlementLocalDataSource>(
  (ref) => LeaveEntitlementLocalDataSourceImpl(),
);

/// Provider for leave entitlement repository
final leaveEntitlementRepositoryProvider = Provider<LeaveEntitlementRepositoryImpl>(
  (ref) => LeaveEntitlementRepositoryImpl(localDataSource: ref.watch(leaveEntitlementLocalDataSourceProvider)),
);

/// Provider for Kuwait Labor Law leave entitlements
final kuwaitLawEntitlementsProvider = FutureProvider<List<LeaveEntitlement>>((ref) async {
  final repository = ref.watch(leaveEntitlementRepositoryProvider);
  try {
    return await repository.getKuwaitLawEntitlements();
  } on AppException {
    rethrow;
  } catch (e) {
    throw Exception('Failed to load leave entitlements: ${e.toString()}');
  }
});
