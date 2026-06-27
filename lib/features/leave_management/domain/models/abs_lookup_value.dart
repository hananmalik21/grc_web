/// Single value for an ABS lookup (e.g. Islam, Hindu for RELIGION_CODE).
class AbsLookupValue {
  final int lookupValueId;
  final int lookupId;
  final String lookupValueCode;
  final String lookupValueName;
  final int displayOrder;
  final String status;
  final int tenantId;
  final String? createdBy;
  final String? createdDate;

  const AbsLookupValue({
    required this.lookupValueId,
    required this.lookupId,
    required this.lookupValueCode,
    required this.lookupValueName,
    required this.displayOrder,
    required this.status,
    required this.tenantId,
    this.createdBy,
    this.createdDate,
  });

  bool get isActive => status.toUpperCase() == 'ACTIVE';
}
