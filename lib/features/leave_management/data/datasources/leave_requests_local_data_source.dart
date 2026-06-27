import 'package:grc/features/time_management/domain/models/time_off_request.dart';

/// Local data source for leave requests
/// This data is static mock data for development/testing purposes
abstract class LeaveRequestsLocalDataSource {
  List<TimeOffRequest> getLeaveRequests();
}

class LeaveRequestsLocalDataSourceImpl implements LeaveRequestsLocalDataSource {
  @override
  List<TimeOffRequest> getLeaveRequests() {
    return [
      TimeOffRequest(
        id: 1,
        guid: '',
        employeeId: 1,
        employeeName: '',
        type: TimeOffType.annualLeave,
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 27),
        totalDays: 7,
        status: RequestStatus.pending,
        reason: 'Family vacation',
      ),
      TimeOffRequest(
        id: 2,
        guid: '',
        employeeId: 2,
        employeeName: '',
        type: TimeOffType.sickLeave,
        startDate: DateTime(2024, 12, 10),
        endDate: DateTime(2024, 12, 12),
        totalDays: 3,
        status: RequestStatus.approved,
        reason: 'Medical treatment',
      ),
    ];
  }
}
