import 'package:grc/core/enums/overtime_status.dart';

class UpdateOvertimeRequestDto {
  final int tenantId;
  final double requestedHours;
  final String reason;
  final OvertimeStatus status;
  final String actor;

  const UpdateOvertimeRequestDto({
    required this.tenantId,
    required this.requestedHours,
    required this.reason,
    this.status = OvertimeStatus.submitted,
    this.actor = 'admin',
  });

  Map<String, dynamic> toJson() => {
    'tenant_id': tenantId,
    'requested_hours': requestedHours,
    'reason': reason,
    'status': status.apiValue,
    'actor': actor,
  };
}
