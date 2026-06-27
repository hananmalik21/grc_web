import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';

/// Domain model for Overtime request/record
class Overtime {
  final int id;
  final int employeeId;
  final String employeeName;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double hours;
  final OvertimeType type;
  final RequestStatus status;
  final String reason;
  final String? rejectionReason;
  final int? approvedBy;
  final String? approvedByName;
  final DateTime? requestedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final double? hourlyRate;
  final double? totalAmount;

  const Overtime({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.hours,
    required this.type,
    required this.status,
    required this.reason,
    this.rejectionReason,
    this.approvedBy,
    this.approvedByName,
    this.requestedAt,
    this.approvedAt,
    this.rejectedAt,
    this.hourlyRate,
    this.totalAmount,
  });
}

/// Domain model for Overtime overview
class OvertimeOverview {
  final int id;
  final int employeeId;
  final String employeeName;
  final String employeeCode;
  final DateTime date;
  final double hours;
  final OvertimeType type;
  final RequestStatus status;
  final String? department;

  const OvertimeOverview({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.employeeCode,
    required this.date,
    required this.hours,
    required this.type,
    required this.status,
    this.department,
  });
}

/// Overtime type enum
enum OvertimeType { regular, weekend, holiday, nightShift }

/// Paginated overtime response
class PaginatedOvertimes {
  final List<OvertimeOverview> overtimes;
  final PaginationInfo pagination;

  const PaginatedOvertimes({required this.overtimes, required this.pagination});
}
