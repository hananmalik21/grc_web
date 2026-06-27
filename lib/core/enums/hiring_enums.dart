/// Shared hiring enums (API values, filters, create flows).
enum RequisitionStatus {
  open('OPEN', 'Open'),
  draft('DRAFT', 'Draft'),
  hold('HOLD', 'Hold'),
  submitted('SUBMITTED', 'Pending Approval'),
  approved('APPROVED', 'Approved'),
  rejected('REJECTED', 'Rejected'),
  closed('CLOSED', 'Closed');

  const RequisitionStatus(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static RequisitionStatus? fromApiValue(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final normalized = value.trim().toUpperCase();
    return switch (normalized) {
      'OPEN' => RequisitionStatus.open,
      'DRAFT' => RequisitionStatus.draft,
      'HOLD' || 'ON_HOLD' => RequisitionStatus.hold,
      'PENDING_APPROVAL' => RequisitionStatus.submitted,
      'SUBMITTED' => RequisitionStatus.submitted,
      'APPROVED' => RequisitionStatus.approved,
      'REJECTED' => RequisitionStatus.rejected,
      'CLOSED' => RequisitionStatus.closed,
      _ => null,
    };
  }

  String get filterKey => switch (this) {
    RequisitionStatus.open => 'open',
    RequisitionStatus.draft => 'draft',
    RequisitionStatus.hold => 'on_hold',
    RequisitionStatus.submitted => 'pending_approval',
    RequisitionStatus.approved => 'approved',
    RequisitionStatus.rejected => 'rejected',
    RequisitionStatus.closed => 'closed',
  };

  @override
  String toString() => label;
}

enum RequisitionOpenStatus {
  closed('CLOSED', 'Closed'),
  notOpen('NOT_OPEN', 'Not Open'),
  open('OPEN', 'Open'),
  onHold('ON_HOLD', 'On Hold');

  const RequisitionOpenStatus(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static RequisitionOpenStatus? fromApiValue(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final normalized = value.trim().toUpperCase();
    return switch (normalized) {
      'CLOSED' => RequisitionOpenStatus.closed,
      'NOT_OPEN' => RequisitionOpenStatus.notOpen,
      'OPEN' => RequisitionOpenStatus.open,
      'ON_HOLD' => RequisitionOpenStatus.onHold,
      _ => null,
    };
  }
}

enum RequisitionCreateAction { draft, submit }
