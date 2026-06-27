enum OvertimeStatus {
  draft('Draft'),
  submitted('Pending'),
  pending('Pending'),
  approved('Approved'),
  rejected('Rejected'),
  withdrawn('Withdrawn');

  final String label;
  const OvertimeStatus(this.label);

  static OvertimeStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'DRAFT':
        return OvertimeStatus.draft;
      case 'SUBMITTED':
        return OvertimeStatus.submitted;
      case 'PENDING':
        return OvertimeStatus.pending;
      case 'APPROVED':
        return OvertimeStatus.approved;
      case 'REJECTED':
        return OvertimeStatus.rejected;
      case 'WITHDRAWN':
        return OvertimeStatus.withdrawn;
      default:
        return OvertimeStatus.submitted;
    }
  }

  String get apiValue {
    switch (this) {
      case OvertimeStatus.draft:
        return 'DRAFT';
      case OvertimeStatus.submitted:
        return 'SUBMITTED';
      case OvertimeStatus.pending:
        return 'PENDING';
      case OvertimeStatus.approved:
        return 'APPROVED';
      case OvertimeStatus.rejected:
        return 'REJECTED';
      case OvertimeStatus.withdrawn:
        return 'WITHDRAWN';
    }
  }

  @override
  String toString() => label;
}
