import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/leave_entitlement_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/leave_entitlement.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_entitlement_repository.dart';

/// Implementation of LeaveEntitlementRepository
class LeaveEntitlementRepositoryImpl implements LeaveEntitlementRepository {
  final LeaveEntitlementLocalDataSource localDataSource;

  LeaveEntitlementRepositoryImpl({required this.localDataSource});

  @override
  Future<List<LeaveEntitlement>> getKuwaitLawEntitlements() async {
    try {
      return localDataSource.getKuwaitLawEntitlements();
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave entitlements: ${e.toString()}', originalError: e);
    }
  }
}
