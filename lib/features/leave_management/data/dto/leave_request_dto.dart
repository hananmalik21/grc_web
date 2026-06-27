import 'package:grc/core/enums/leave_request_status.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';

class EmployeeInfoDto {
  final int employeeId;
  final String employeeGuid;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String? email;
  final String? positionName;
  final String? departmentName;

  const EmployeeInfoDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    this.email,
    this.positionName,
    this.departmentName,
  });

  factory EmployeeInfoDto.fromJson(Map<String, dynamic> json) {
    final positionName = json['position_name_en'] as String? ?? json['position_name'] as String? ?? '';
    final orgList = json['org_structure_list'] as List<dynamic>?;
    String? departmentName;
    if (orgList != null) {
      for (final e in orgList) {
        if (e is Map<String, dynamic>) {
          final levelCode = e['level_code'] as String?;
          if (levelCode == 'DEPARTMENT') {
            departmentName = e['org_unit_name_en'] as String? ?? e['org_unit_name'] as String? ?? '';
            break;
          }
        }
      }
    }
    return EmployeeInfoDto(
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: json['employee_guid'] as String? ?? '',
      firstName: json['first_name_en'] as String? ?? json['first_name'] as String? ?? '',
      middleName: json['middle_name_en'] as String? ?? json['middle_name'] as String?,
      lastName: json['last_name_en'] as String? ?? json['last_name'] as String? ?? '',
      firstNameAr: json['first_name_ar'] as String?,
      middleNameAr: json['middle_name_ar'] as String?,
      lastNameAr: json['last_name_ar'] as String? ?? json['family_name_ar'] as String?,
      email: json['email'] as String?,
      positionName: positionName.isNotEmpty ? positionName : null,
      departmentName: (departmentName != null && departmentName.trim().isNotEmpty) ? departmentName.trim() : null,
    );
  }
}

class LeaveTypeInfoDto {
  final int leaveTypeId;
  final String leaveTypeGuid;
  final String leaveNameEn;
  final String? leaveNameAr;
  final String leaveCode;

  const LeaveTypeInfoDto({
    required this.leaveTypeId,
    required this.leaveTypeGuid,
    required this.leaveNameEn,
    this.leaveNameAr,
    required this.leaveCode,
  });

  factory LeaveTypeInfoDto.fromJson(Map<String, dynamic> json) {
    return LeaveTypeInfoDto(
      leaveTypeId: (json['leave_type_id'] as num?)?.toInt() ?? 0,
      leaveTypeGuid: json['leave_type_guid'] as String? ?? '',
      leaveNameEn: json['leave_name_en'] as String? ?? '',
      leaveNameAr: json['leave_name_ar'] as String?,
      leaveCode: json['leave_code'] as String? ?? '',
    );
  }
}

class LeaveRequestDto {
  final int leaveRequestId;
  final String leaveRequestGuid;
  final int tenantId;
  final int employeeId;
  final int leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTs;
  final DateTime endTs;
  final double totalDays;
  final LeaveRequestStatus requestStatus;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime creationDate;
  final String createdBy;
  final DateTime lastUpdateDate;
  final String lastUpdatedBy;
  final String reason;
  final EmployeeInfoDto? employeeInfo;
  final LeaveTypeInfoDto? leaveTypeInfo;

  const LeaveRequestDto({
    required this.leaveRequestId,
    required this.leaveRequestGuid,
    required this.tenantId,
    required this.employeeId,
    required this.leaveTypeId,
    required this.startDate,
    required this.endDate,
    required this.startTs,
    required this.endTs,
    required this.totalDays,
    required this.requestStatus,
    this.submittedAt,
    this.approvedAt,
    this.rejectedAt,
    required this.creationDate,
    required this.createdBy,
    required this.lastUpdateDate,
    required this.lastUpdatedBy,
    this.reason = '',
    this.employeeInfo,
    this.leaveTypeInfo,
  });

  factory LeaveRequestDto.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) {
        throw FormatException('DateTime value cannot be null');
      }
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      throw FormatException('Invalid DateTime format: $value');
    }

    DateTime? parseNullableDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      if (value is num) return value.toDouble();
      return 0.0;
    }

    final leaveDetails = json['leave_details'] as Map<String, dynamic>? ?? json;

    final employeeInfoJson = leaveDetails['employee_info'] as Map<String, dynamic>?;
    final leaveTypeInfoJson = leaveDetails['leave_type_info'] as Map<String, dynamic>?;

    return LeaveRequestDto(
      leaveRequestId: (leaveDetails['leave_request_id'] as num?)?.toInt() ?? 0,
      leaveRequestGuid: leaveDetails['leave_request_guid'] as String? ?? '',
      tenantId: (leaveDetails['tenant_id'] as num?)?.toInt() ?? 0,
      employeeId: (leaveDetails['employee_id'] as num?)?.toInt() ?? 0,
      leaveTypeId: (leaveDetails['leave_type_id'] as num?)?.toInt() ?? 0,
      startDate: parseDateTime(leaveDetails['start_date']),
      endDate: parseDateTime(leaveDetails['end_date']),
      startTs: parseDateTime(leaveDetails['start_ts']),
      endTs: parseDateTime(leaveDetails['end_ts']),
      totalDays: parseDouble(leaveDetails['total_days']),
      requestStatus: LeaveRequestStatus.fromString(leaveDetails['request_status'] as String? ?? 'SUBMITTED'),
      submittedAt: parseNullableDateTime(leaveDetails['submitted_at']),
      approvedAt: parseNullableDateTime(leaveDetails['approved_at']),
      rejectedAt: parseNullableDateTime(leaveDetails['rejected_at']),
      creationDate: parseDateTime(leaveDetails['creation_date']),
      createdBy: leaveDetails['created_by'] as String? ?? '',
      lastUpdateDate: parseDateTime(leaveDetails['last_update_date']),
      lastUpdatedBy: leaveDetails['last_updated_by'] as String? ?? '',
      reason: leaveDetails['reason_for_leave'] as String? ?? '',
      employeeInfo: employeeInfoJson != null ? EmployeeInfoDto.fromJson(employeeInfoJson) : null,
      leaveTypeInfo: leaveTypeInfoJson != null ? LeaveTypeInfoDto.fromJson(leaveTypeInfoJson) : null,
    );
  }

  RequestStatus _mapStatus(LeaveRequestStatus status) {
    switch (status) {
      case LeaveRequestStatus.submitted:
        return RequestStatus.pending;
      case LeaveRequestStatus.approved:
        return RequestStatus.approved;
      case LeaveRequestStatus.rejected:
        return RequestStatus.rejected;
      case LeaveRequestStatus.withdrawn:
        return RequestStatus.cancelled;
      case LeaveRequestStatus.draft:
        return RequestStatus.draft;
    }
  }

  TimeOffRequest toDomain() {
    final employeeName = employeeInfo != null
        ? '${employeeInfo!.firstName.trim()} ${employeeInfo!.middleName?.trim() ?? ''} ${employeeInfo!.lastName.trim()}'
              .trim()
        : '';

    final LeaveTypeInfo? domainLeaveTypeInfo = leaveTypeInfo == null
        ? null
        : LeaveTypeInfo(
            leaveTypeId: leaveTypeInfo!.leaveTypeId,
            leaveTypeGuid: leaveTypeInfo!.leaveTypeGuid,
            leaveNameEn: leaveTypeInfo!.leaveNameEn,
            leaveNameAr: leaveTypeInfo!.leaveNameAr,
            leaveCode: leaveTypeInfo!.leaveCode,
          );

    return TimeOffRequest(
      id: leaveRequestId,
      guid: leaveRequestGuid,
      employeeId: employeeId,
      employeeName: employeeName,
      employeeGuid: employeeInfo?.employeeGuid,
      department: employeeInfo?.departmentName,
      position: employeeInfo?.positionName,
      type: TimeOffType.other,
      leaveTypeInfo: domainLeaveTypeInfo,
      startDate: startDate,
      endDate: endDate,
      totalDays: totalDays,
      status: _mapStatus(requestStatus),
      reason: reason,
      rejectionReason: null,
      approvedBy: null,
      approvedByName: null,
      requestedAt: submittedAt,
      approvedAt: approvedAt,
      rejectedAt: rejectedAt,
    );
  }
}
