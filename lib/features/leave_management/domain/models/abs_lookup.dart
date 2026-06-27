/// Single ABS lookup (e.g. ACCRUAL_METHOD, CONTRACT_TYPE, EMP_CATEGORY).
class AbsLookup {
  final int lookupId;
  final String lookupCode;
  final String lookupName;
  final int tenantId;
  final String status;
  final String? createdBy;
  final String? createdDate;
  final String? lastUpdatedBy;
  final String? lastUpdateDate;

  const AbsLookup({
    required this.lookupId,
    required this.lookupCode,
    required this.lookupName,
    required this.tenantId,
    required this.status,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdateDate,
  });

  bool get isActive => status.toUpperCase() == 'ACTIVE';
}
