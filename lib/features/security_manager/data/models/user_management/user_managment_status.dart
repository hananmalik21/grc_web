/// Timesheet status enum.
/// API codes: DRAFT, SUBMITTED, APPROVED, REJECTED, WITHDRAWN
enum UserManagementStatus { draft, submitted, approved, rejected, withdrawn }

extension UserManagementStatusExtension on UserManagementStatus {
  String get displayName {
    switch (this) {
      case UserManagementStatus.draft:
        return 'Draft';
      case UserManagementStatus.submitted:
        return 'Pending';
      case UserManagementStatus.approved:
        return 'Approved';
      case UserManagementStatus.rejected:
        return 'Rejected';
      case UserManagementStatus.withdrawn:
        return 'Withdrawn';
    }
  }

  static UserManagementStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return UserManagementStatus.draft;
      case 'submitted':
      case 'pending':
        return UserManagementStatus.submitted;
      case 'approved':
        return UserManagementStatus.approved;
      case 'rejected':
        return UserManagementStatus.rejected;
      case 'withdrawn':
        return UserManagementStatus.withdrawn;
      default:
        return UserManagementStatus.draft;
    }
  }

  String toApiString() {
    switch (this) {
      case UserManagementStatus.draft:
        return 'draft';
      case UserManagementStatus.submitted:
        return 'submitted';
      case UserManagementStatus.approved:
        return 'approved';
      case UserManagementStatus.rejected:
        return 'rejected';
      case UserManagementStatus.withdrawn:
        return 'withdrawn';
    }
  }
}
