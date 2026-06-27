import 'package:grc/features/leave_management/domain/models/api_leave_type.dart';

class LeaveDetailsData {
  const LeaveDetailsData({required this.employeeData, required this.summaryByLeaveType, required this.transactions});

  final Map<String, dynamic> employeeData;
  final Map<String, Map<String, dynamic>> summaryByLeaveType;
  final List<Map<String, dynamic>> transactions;

  Map<String, dynamic> getSummaryForType(ApiLeaveType type) {
    if (summaryByLeaveType.isEmpty) return {};
    final byId = summaryByLeaveType[type.id.toString()];
    if (byId != null) return byId;

    final codeLower = _codeToCamelKey(type.code);
    final byCode = summaryByLeaveType[codeLower] ?? summaryByLeaveType[type.code];
    if (byCode != null) return byCode;

    return {};
  }

  double getAvailableDaysForType(ApiLeaveType type) {
    final summary = getSummaryForType(type);
    if (summary.isEmpty) return 0.0;
    final val =
        summary['currentBalance'] ??
        summary['current_balance'] ??
        summary['available_days'] ??
        summary['availableDays'] ??
        0.0;
    return (val as num).toDouble();
  }

  String _codeToCamelKey(String code) {
    final lower = code.toLowerCase();
    if (lower.isEmpty) return lower;
    if (lower == 'annual_leave' || lower == 'annual') return 'annualLeave';
    if (lower == 'sick_leave' || lower == 'sick') return 'sickLeave';
    if (lower == 'unpaid_leave' || lower == 'unpaid') return 'unpaidLeave';
    return lower;
  }
}
