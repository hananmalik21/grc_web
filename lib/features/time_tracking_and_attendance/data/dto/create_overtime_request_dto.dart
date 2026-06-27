import 'package:grc/core/enums/overtime_status.dart';

class CreateOvertimeRequestDto {
  final int tenantId;
  final String employeeGuid;
  final int attendanceDayId;
  final double requestedHours;
  final String reason;
  final int otConfigId;
  final int otRateTypeId;
  final OvertimeStatus status;
  final String actor;

  const CreateOvertimeRequestDto({
    required this.tenantId,
    required this.employeeGuid,
    required this.attendanceDayId,
    required this.requestedHours,
    required this.reason,
    required this.otConfigId,
    required this.otRateTypeId,
    this.status = OvertimeStatus.submitted,
    this.actor = 'admin',
  });

  Map<String, dynamic> toJson() => {
    'tenant_id': tenantId,
    'employee_guid': employeeGuid,
    'attendance_day_id': attendanceDayId,
    'requested_hours': requestedHours,
    'reason': reason,
    'ot_config_id': otConfigId,
    'ot_rate_type_id': otRateTypeId,
    'status': status.apiValue,
    'actor': actor,
  };
}
