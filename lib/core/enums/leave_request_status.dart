enum LeaveRequestStatus {
  submitted('SUBMITTED'),
  withdrawn('WITHDRAWN'),
  approved('APPROVED'),
  rejected('REJECTED'),
  draft('DRAFT');

  final String value;
  const LeaveRequestStatus(this.value);

  static LeaveRequestStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'SUBMITTED':
        return LeaveRequestStatus.submitted;
      case 'WITHDRAWN':
        return LeaveRequestStatus.withdrawn;
      case 'APPROVED':
        return LeaveRequestStatus.approved;
      case 'REJECTED':
        return LeaveRequestStatus.rejected;
      case 'DRAFT':
        return LeaveRequestStatus.draft;
      default:
        return LeaveRequestStatus.submitted;
    }
  }

  @override
  String toString() => value;
}
