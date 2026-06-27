/// Timesheet status enum.
/// API codes: DRAFT, SUBMITTED, APPROVED, REJECTED, WITHDRAWN
enum TimesheetStatus { draft, submitted, approved, rejected, withdrawn }

extension TimesheetStatusExtension on TimesheetStatus {
  String get displayName {
    switch (this) {
      case TimesheetStatus.draft:
        return 'Draft';
      case TimesheetStatus.submitted:
        return 'Pending';
      case TimesheetStatus.approved:
        return 'Approved';
      case TimesheetStatus.rejected:
        return 'Rejected';
      case TimesheetStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  static TimesheetStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return TimesheetStatus.draft;
      case 'submitted':
      case 'pending':
        return TimesheetStatus.submitted;
      case 'approved':
        return TimesheetStatus.approved;
      case 'rejected':
        return TimesheetStatus.rejected;
      case 'withdrawn':
        return TimesheetStatus.withdrawn;
      default:
        return TimesheetStatus.draft;
    }
  }

  String toApiString() {
    switch (this) {
      case TimesheetStatus.draft:
        return 'draft';
      case TimesheetStatus.submitted:
        return 'submitted';
      case TimesheetStatus.approved:
        return 'approved';
      case TimesheetStatus.rejected:
        return 'rejected';
      case TimesheetStatus.withdrawn:
        return 'withdrawn';
    }
  }
}
