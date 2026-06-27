class RequisitionStatusInfo {
  const RequisitionStatusInfo({
    this.approvalStatusCode,
    this.openStatusCode,
    this.displayStatus,
    this.submittedBy,
    this.submittedDate,
    this.approvedBy,
    this.approvedDate,
    this.openedBy,
    this.openedDate,
    this.closedBy,
    this.closedDate,
  });

  final String? approvalStatusCode;
  final String? openStatusCode;
  final String? displayStatus;
  final String? submittedBy;
  final DateTime? submittedDate;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? openedBy;
  final DateTime? openedDate;
  final String? closedBy;
  final DateTime? closedDate;
}
