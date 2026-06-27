class SalaryStructureLocation {
  final int? lookupValueId;
  final String? lookupValueGuid;
  final int? lookupTypeId;
  final int? tenantId;
  final String? valueCode;
  final String? valueName;
  final int? displaySequence;
  final String? activeFlag;
  final String? typeCode;
  final String? typeName;
  final String? typeDescription;

  const SalaryStructureLocation({
    required this.lookupValueId,
    required this.lookupValueGuid,
    required this.lookupTypeId,
    required this.tenantId,
    required this.valueCode,
    required this.valueName,
    required this.displaySequence,
    required this.activeFlag,
    required this.typeCode,
    required this.typeName,
    required this.typeDescription,
  });
}
