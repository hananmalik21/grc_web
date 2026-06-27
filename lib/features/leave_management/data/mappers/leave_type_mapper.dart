import 'package:grc/features/time_management/domain/models/time_off_request.dart';

/// Maps TimeOffType enum to short display labels
class LeaveTypeMapper {
  static String getShortLabel(TimeOffType type) {
    switch (type) {
      case TimeOffType.annualLeave:
        return 'Annual';
      case TimeOffType.sickLeave:
        return 'Sick';
      case TimeOffType.personalLeave:
        return 'Emergency';
      case TimeOffType.emergencyLeave:
        return 'Emergency';
      case TimeOffType.unpaidLeave:
        return 'Unpaid';
      case TimeOffType.other:
        return 'Other';
    }
  }

  /// Note: Adjust these IDs based on your backend configuration
  static int getLeaveTypeId(TimeOffType type) {
    switch (type) {
      case TimeOffType.annualLeave:
        return 1;
      case TimeOffType.sickLeave:
        return 2;
      case TimeOffType.personalLeave:
        return 3;
      case TimeOffType.emergencyLeave:
        return 4;
      case TimeOffType.unpaidLeave:
        return 5;
      case TimeOffType.other:
        return 6;
    }
  }

  static TimeOffType? getLeaveTypeFromCode(String? code) {
    if (code == null) return null;
    switch (code.toUpperCase()) {
      case 'ANNUAL':
        return TimeOffType.annualLeave;
      case 'SICK':
        return TimeOffType.sickLeave;
      case 'PERSONAL':
        return TimeOffType.personalLeave;
      case 'EMERGENCY':
        return TimeOffType.emergencyLeave;
      case 'UNPAID':
        return TimeOffType.unpaidLeave;
      default:
        return TimeOffType.other;
    }
  }
}
