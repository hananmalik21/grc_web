import 'package:grc/features/time_management/domain/models/time_off_request.dart';

class MockLeaveRequest {
  static TimeOffRequest create({
    int id = 1,
    String guid = 'mock-guid',
    int employeeId = 123,
    String employeeName = 'Employee Name Placeholder',
    String? employeeGuid = 'emp-guid',
    DateTime? startDate,
    DateTime? endDate,
    double totalDays = 5.0,
    TimeOffType type = TimeOffType.annualLeave,
    RequestStatus status = RequestStatus.pending,
    String reason = 'Leave reason placeholder text',
    String? department = 'Engineering',
    String? position = 'Senior Developer',
  }) {
    return TimeOffRequest(
      id: id,
      guid: guid,
      employeeId: employeeId,
      employeeName: employeeName,
      employeeGuid: employeeGuid,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? DateTime.now().add(const Duration(days: 5)),
      totalDays: totalDays,
      type: type,
      status: status,
      reason: reason,
      department: department,
      position: position,
    );
  }
}
