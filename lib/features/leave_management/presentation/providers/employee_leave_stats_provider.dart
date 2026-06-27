import 'package:grc/features/leave_management/domain/models/employee_leave_stats.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeLeaveStatsProvider = FutureProvider.autoDispose.family<EmployeeLeaveStats, String>((
  ref,
  employeeGuid,
) async {
  final repository = ref.watch(leaveRequestsRepositoryProvider);
  final tenantId = ref.watch(leaveManagementEnterpriseIdProvider);
  return repository.getEmployeeLeaveRequestStats(employeeGuid: employeeGuid, tenantId: tenantId);
});
