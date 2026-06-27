import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class LeaveTypeInfo {
  const LeaveTypeInfo({
    required this.leaveTypeId,
    required this.leaveTypeGuid,
    required this.leaveNameEn,
    this.leaveNameAr,
    required this.leaveCode,
  });

  final int leaveTypeId;
  final String leaveTypeGuid;
  final String leaveNameEn;
  final String? leaveNameAr;
  final String leaveCode;
}

/// Domain model for Time-off Request
class TimeOffRequest {
  final int id;
  final String guid;
  final int employeeId;
  final String employeeName;
  final String? employeeGuid;
  final String? department;
  final String? position;
  final TimeOffType type;
  final LeaveTypeInfo? leaveTypeInfo;
  final DateTime startDate;
  final DateTime endDate;
  final double totalDays;
  final RequestStatus status;
  final String reason;
  final String? rejectionReason;
  final int? approvedBy;
  final String? approvedByName;
  final DateTime? requestedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;

  const TimeOffRequest({
    required this.id,
    required this.guid,
    required this.employeeId,
    required this.employeeName,
    this.employeeGuid,
    this.department,
    this.position,
    required this.type,
    this.leaveTypeInfo,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.status,
    required this.reason,
    this.rejectionReason,
    this.approvedBy,
    this.approvedByName,
    this.requestedAt,
    this.approvedAt,
    this.rejectedAt,
  });
}

/// Domain model for Time-off Request overview
class TimeOffRequestOverview {
  final int id;
  final int employeeId;
  final String employeeName;
  final String employeeCode;
  final TimeOffType type;
  final DateTime startDate;
  final DateTime endDate;
  final double totalDays;
  final RequestStatus status;
  final String? department;

  const TimeOffRequestOverview({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.status,
    this.department,
  });
}

/// Time-off request type
enum TimeOffType { annualLeave, sickLeave, personalLeave, emergencyLeave, unpaidLeave, other }

/// Request status enum
enum RequestStatus { pending, approved, rejected, cancelled, draft }

/// Paginated time-off request response
class PaginatedTimeOffRequests {
  final List<TimeOffRequestOverview> requests;
  final PaginationInfo pagination;

  const PaginatedTimeOffRequests({required this.requests, required this.pagination});
}
