class CompLookupValue {
  final int lookupValueId;
  final String lookupValueGuid;
  final int lookupTypeId;
  final String valueCode;
  final String valueName;
  final int? displaySequence;
  final bool isActive;

  const CompLookupValue({
    required this.lookupValueId,
    required this.lookupValueGuid,
    required this.lookupTypeId,
    required this.valueCode,
    required this.valueName,
    required this.displaySequence,
    required this.isActive,
  });
}
