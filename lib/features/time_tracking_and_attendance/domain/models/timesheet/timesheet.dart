import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_line.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';

/// Domain model for Timesheet
class Timesheet {
  final int id;
  final String guid;
  final int employeeId;
  final String employeeName;
  final String employeeNumber;
  final String departmentName;
  final String? companyName;
  final String? divisionName;
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final double regularHours;
  final double overtimeHours;
  final double totalHours;
  final TimesheetStatus status;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final List<TimesheetLine> lines;

  const Timesheet({
    required this.id,
    required this.guid,
    required this.employeeId,
    required this.employeeName,
    required this.employeeNumber,
    required this.departmentName,
    this.companyName,
    this.divisionName,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.regularHours,
    required this.overtimeHours,
    required this.totalHours,
    required this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.submittedAt,
    this.approvedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.lines = const [],
  });

  factory Timesheet.fromJson(Map<String, dynamic> json) {
    return Timesheet(
      id: json['id'] as int,
      guid: (json['guid'] ?? json['timesheet_guid']) as String? ?? '',
      employeeId: json['employee_id'] as int,
      employeeName: json['employee_name'] as String? ?? '',
      employeeNumber: json['employee_number'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? '',
      companyName: json['company_name'] as String?,
      divisionName: json['division_name'] as String?,
      weekStartDate: DateTime.parse(json['week_start_date'] as String),
      weekEndDate: DateTime.parse(json['week_end_date'] as String),
      regularHours: (json['regular_hours'] as num?)?.toDouble() ?? 0.0,
      overtimeHours: (json['overtime_hours'] as num?)?.toDouble() ?? 0.0,
      totalHours: (json['total_hours'] as num?)?.toDouble() ?? 0.0,
      status: TimesheetStatusExtension.fromString(json['status'] as String? ?? 'draft'),
      description: json['description'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      submittedAt: json['submitted_at'] != null ? DateTime.parse(json['submitted_at'] as String) : null,
      approvedAt: json['approved_at'] != null ? DateTime.parse(json['approved_at'] as String) : null,
      rejectedAt: json['rejected_at'] != null ? DateTime.parse(json['rejected_at'] as String) : null,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guid': guid,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'employee_number': employeeNumber,
      'department_name': departmentName,
      'company_name': companyName,
      'division_name': divisionName,
      'week_start_date': weekStartDate.toIso8601String(),
      'week_end_date': weekEndDate.toIso8601String(),
      'regular_hours': regularHours,
      'overtime_hours': overtimeHours,
      'total_hours': totalHours,
      'status': status.toApiString(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'submitted_at': submittedAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
    };
  }

  /// Gets formatted week period string (e.g., "Dec 9 - Dec 15, 2024")
  String get formattedWeekPeriod {
    final startFormat = weekStartDate.month == weekEndDate.month ? 'MMM d' : 'MMM d, yyyy';
    final endFormat = 'MMM d, yyyy';
    final startStr = _formatDate(weekStartDate, startFormat);
    final endStr = _formatDate(weekEndDate, endFormat);
    return '$startStr - $endStr';
  }

  String _formatDate(DateTime date, String format) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;

    if (format == 'MMM d') {
      return '$month $day';
    } else if (format == 'MMM d, yyyy') {
      return '$month $day, $year';
    }
    return '$month $day, $year';
  }

  /// Gets avatar initials from employee name
  String get avatarInitials {
    final names = employeeName.split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    }
    return '${names[0][0]}${names[1][0]}'.toUpperCase();
  }
}
