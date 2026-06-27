import 'package:grc/features/leave_management/domain/models/employee_leave_stats.dart';

/// DTO for GET /api/abs/employees/:employeeGuid/leave-requests/stats response.
class EmployeeLeaveStatsDto {
  const EmployeeLeaveStatsDto({
    required this.totalLeaveRequests,
    required this.submittedLeaveRequests,
    required this.approvedLeaveRequests,
    required this.rejectedLeaveRequests,
  });

  final int totalLeaveRequests;
  final int submittedLeaveRequests;
  final int approvedLeaveRequests;
  final int rejectedLeaveRequests;

  factory EmployeeLeaveStatsDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return EmployeeLeaveStatsDto(
      totalLeaveRequests: parseInt(json['total_leave_requests']),
      submittedLeaveRequests: parseInt(json['submitted_leave_requests']),
      approvedLeaveRequests: parseInt(json['approved_leave_requests']),
      rejectedLeaveRequests: parseInt(json['rejected_leave_requests']),
    );
  }

  EmployeeLeaveStats toDomain() => EmployeeLeaveStats(
    total: totalLeaveRequests,
    approved: approvedLeaveRequests,
    pending: submittedLeaveRequests,
    rejected: rejectedLeaveRequests,
  );
}
