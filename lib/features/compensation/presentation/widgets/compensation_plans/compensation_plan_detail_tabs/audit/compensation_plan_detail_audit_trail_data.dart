class AuditTrailRowData {
  final String dateTime;
  final String user;
  final String action;
  final String details;
  final String ipAddress;

  const AuditTrailRowData({
    required this.dateTime,
    required this.user,
    required this.action,
    required this.details,
    required this.ipAddress,
  });
}

class CompensationPlanDetailAuditTrailData {
  CompensationPlanDetailAuditTrailData._();

  static const pageSize = 5;

  static const title = 'Audit Trail';
  static const subtitle = 'Complete history of all changes made to this plan';

  static const dateTimeHeader = 'Date & Time';
  static const userHeader = 'User';
  static const actionHeader = 'Action';
  static const detailsHeader = 'Details';
  static const ipAddressHeader = 'IP Address';

  static const rows = <AuditTrailRowData>[
    AuditTrailRowData(
      dateTime: '2026-03-27 14:30:22',
      user: 'Sarah Johnson',
      action: 'View',
      details: 'Viewed plan details',
      ipAddress: '192.168.1.105',
    ),
    AuditTrailRowData(
      dateTime: '2026-02-10 11:45:00',
      user: 'Michael Chen',
      action: 'Update',
      details: 'Modified component: Housing Allowance',
      ipAddress: '192.168.1.87',
    ),
    AuditTrailRowData(
      dateTime: '2025-12-01 10:00:00',
      user: 'Sarah Johnson',
      action: 'Publish',
      details: 'Plan published and activated',
      ipAddress: '192.168.1.105',
    ),
    AuditTrailRowData(
      dateTime: '2025-11-28 15:20:00',
      user: 'Jennifer Wilson',
      action: 'Approve',
      details: 'Finance approval granted',
      ipAddress: '192.168.1.92',
    ),
    AuditTrailRowData(
      dateTime: '2025-11-15 10:30:00',
      user: 'Sarah Johnson',
      action: 'Create',
      details: 'Plan created as draft',
      ipAddress: '192.168.1.105',
    ),
  ];
}
