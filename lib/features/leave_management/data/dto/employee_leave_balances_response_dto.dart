import 'package:grc/features/leave_management/domain/models/leave_balance.dart';

class EmployeeLeaveBalancesResponseDto {
  final bool success;
  final String message;
  final List<EmployeeLeaveBalanceItemDto> data;

  const EmployeeLeaveBalancesResponseDto({required this.success, required this.message, required this.data});

  factory EmployeeLeaveBalancesResponseDto.fromJson(Map<String, dynamic> json) {
    return EmployeeLeaveBalancesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EmployeeLeaveBalanceItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<LeaveBalance> toDomain() => data.map((e) => e.toDomain()).toList();
}

class EmployeeLeaveBalanceItemDto {
  final int tenantId;
  final int employeeId;
  final String employeeGuid;
  final int leaveTypeId;
  final double openingBalanceDays;
  final double accruedDays;
  final double takenDays;
  final double adjustedDays;
  final double availableDays;
  final String status;
  final String employeeLeaveBalanceGuid;
  final LeaveTypeObjDto? leaveTypeObj;

  const EmployeeLeaveBalanceItemDto({
    required this.tenantId,
    required this.employeeId,
    required this.employeeGuid,
    required this.leaveTypeId,
    required this.openingBalanceDays,
    required this.accruedDays,
    required this.takenDays,
    required this.adjustedDays,
    required this.availableDays,
    required this.status,
    required this.employeeLeaveBalanceGuid,
    this.leaveTypeObj,
  });

  factory EmployeeLeaveBalanceItemDto.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return EmployeeLeaveBalanceItemDto(
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: json['employee_guid'] as String? ?? '',
      leaveTypeId: (json['leave_type_id'] as num?)?.toInt() ?? 0,
      openingBalanceDays: parseDouble(json['opening_balance_days']),
      accruedDays: parseDouble(json['accrued_days']),
      takenDays: parseDouble(json['taken_days']),
      adjustedDays: parseDouble(json['adjusted_days']),
      availableDays: parseDouble(json['available_days']),
      status: json['status'] as String? ?? 'ACTIVE',
      employeeLeaveBalanceGuid: json['employee_leave_balance_guid'] as String? ?? '',
      leaveTypeObj: json['leave_type_obj'] != null
          ? LeaveTypeObjDto.fromJson(json['leave_type_obj'] as Map<String, dynamic>)
          : null,
    );
  }

  LeaveBalance toDomain() {
    return LeaveBalance(
      employeeLeaveBalanceGuid: employeeLeaveBalanceGuid,
      tenantId: tenantId,
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      employeeName: '',
      leaveTypeId: leaveTypeId,
      openingBalanceDays: openingBalanceDays,
      accruedDays: accruedDays,
      takenDays: takenDays,
      adjustedDays: adjustedDays,
      availableDays: availableDays,
      status: status,
    );
  }
}

class LeaveTypeObjDto {
  final int leaveTypeId;
  final String leaveCode;
  final String leaveNameEn;
  final String leaveNameAr;
  final String status;

  const LeaveTypeObjDto({
    required this.leaveTypeId,
    required this.leaveCode,
    required this.leaveNameEn,
    required this.leaveNameAr,
    required this.status,
  });

  factory LeaveTypeObjDto.fromJson(Map<String, dynamic> json) {
    return LeaveTypeObjDto(
      leaveTypeId: (json['leave_type_id'] as num?)?.toInt() ?? 0,
      leaveCode: json['leave_code'] as String? ?? '',
      leaveNameEn: json['leave_name_en'] as String? ?? '',
      leaveNameAr: json['leave_name_ar'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }
}
