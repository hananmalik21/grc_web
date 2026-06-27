class CompLookupType {
  final int lookupTypeId;
  final String lookupTypeGuid;
  final String typeCode;
  final String typeName;
  final String? description;
  final bool isActive;

  const CompLookupType({
    required this.lookupTypeId,
    required this.lookupTypeGuid,
    required this.typeCode,
    required this.typeName,
    required this.description,
    required this.isActive,
  });
}
