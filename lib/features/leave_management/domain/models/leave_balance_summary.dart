import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class LeaveBalanceSummaryItem {
  final int employeeId;
  final String employeeGuid;
  final String employeeNumber;
  final String employeeName;
  final String department;
  final DateTime? joinDate;
  final double annualLeave;
  final double sickLeave;
  final double totalAvailable;

  const LeaveBalanceSummaryItem({
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeNumber,
    required this.employeeName,
    required this.department,
    this.joinDate,
    this.annualLeave = 0,
    this.sickLeave = 0,
    this.totalAvailable = 0,
  });

  LeaveBalanceSummaryItem copyWith({
    int? employeeId,
    String? employeeGuid,
    String? employeeNumber,
    String? employeeName,
    String? department,
    DateTime? joinDate,
    double? annualLeave,
    double? sickLeave,
    double? totalAvailable,
  }) {
    return LeaveBalanceSummaryItem(
      employeeId: employeeId ?? this.employeeId,
      employeeGuid: employeeGuid ?? this.employeeGuid,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      employeeName: employeeName ?? this.employeeName,
      department: department ?? this.department,
      joinDate: joinDate ?? this.joinDate,
      annualLeave: annualLeave ?? this.annualLeave,
      sickLeave: sickLeave ?? this.sickLeave,
      totalAvailable: totalAvailable ?? this.totalAvailable,
    );
  }

  static LeaveBalanceSummaryItem placeholder() => const LeaveBalanceSummaryItem(
    employeeId: 0,
    employeeGuid: '',
    employeeNumber: '',
    employeeName: '',
    department: '',
  );

  static LeaveBalanceSummaryItem skeletonPlaceholder() => LeaveBalanceSummaryItem(
    employeeId: 0,
    employeeGuid: '',
    employeeNumber: 'EMP-000000',
    employeeName: 'Employee Name',
    department: 'Department Name',
    joinDate: DateTime(2024, 1, 15),
    annualLeave: 21,
    sickLeave: 10,
    totalAvailable: 31,
  );
}

class PaginatedLeaveBalanceSummaries {
  final List<LeaveBalanceSummaryItem> items;
  final PaginationInfo pagination;

  const PaginatedLeaveBalanceSummaries({required this.items, required this.pagination});
}
