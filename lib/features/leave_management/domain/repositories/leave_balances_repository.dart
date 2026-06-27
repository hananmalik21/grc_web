import 'package:grc/features/leave_management/domain/models/leave_balance.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';

abstract class LeaveBalancesRepository {
  Future<PaginatedLeaveBalances> getLeaveBalances({int page = 1, int pageSize = 10, int? tenantId});

  Future<List<LeaveBalance>> getLeaveBalancesForEmployee(String employeeGuid, {int? tenantId});

  Future<PaginatedLeaveBalanceSummaries> getLeaveBalanceSummaries({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? search,
  });

  Future<void> updateLeaveBalance(String employeeLeaveBalanceGuid, UpdateLeaveBalanceParams params, {int? tenantId});

  Future<void> adjustLeaveBalances({
    required int tenantId,
    required int employeeId,
    required String reason,
    required List<LeaveAdjustmentItem> items,
  });
}
