import 'package:grc/core/enums/overtime_status.dart';
import '../models/overtime/overtime_requests_page.dart';

abstract class OvertimeRepository {
  Future<void> createOvertimeRequest({
    required int tenantId,
    required String employeeGuid,
    required int attendanceDayId,
    required double requestedHours,
    required String reason,
    required int otConfigId,
    required int otRateTypeId,
    OvertimeStatus status = OvertimeStatus.submitted,
    String actor = 'admin',
  });

  Future<OvertimeRequestsPage> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? searchQuery,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  });

  Future<Map<String, dynamic>?> approveOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  });

  Future<Map<String, dynamic>?> rejectOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  });

  Future<Map<String, dynamic>?> updateOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    required double requestedHours,
    required String reason,
    String actor = 'admin',
  });

  Future<Map<String, dynamic>?> cancelOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  });
}
