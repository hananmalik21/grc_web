import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_location.dart';

class SalaryStructureLocationDto {
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

  const SalaryStructureLocationDto({
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

  factory SalaryStructureLocationDto.fromJson(Map<String, dynamic> json) {
    return SalaryStructureLocationDto(
      lookupValueId: (json['lookup_value_id'] as num?)?.toInt(),
      lookupValueGuid: json['lookup_value_guid'] as String?,
      lookupTypeId: (json['lookup_type_id'] as num?)?.toInt(),
      tenantId: (json['tenant_id'] as num?)?.toInt(),
      valueCode: json['value_code'] as String?,
      valueName: json['value_name'] as String?,
      displaySequence: (json['display_sequence'] as num?)?.toInt(),
      activeFlag: json['active_flag'] as String?,
      typeCode: json['type_code'] as String?,
      typeName: json['type_name'] as String?,
      typeDescription: json['type_description'] as String?,
    );
  }

  SalaryStructureLocation toDomain() {
    return SalaryStructureLocation(
      lookupValueId: lookupValueId,
      lookupValueGuid: lookupValueGuid,
      lookupTypeId: lookupTypeId,
      tenantId: tenantId,
      valueCode: valueCode,
      valueName: valueName,
      displaySequence: displaySequence,
      activeFlag: activeFlag,
      typeCode: typeCode,
      typeName: typeName,
      typeDescription: typeDescription,
    );
  }
}
