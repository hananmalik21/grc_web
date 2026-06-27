import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_type.dart';

class CompLookupTypeDto {
  final String lookupTypeGuid;
  final int lookupTypeId;
  final String typeCode;
  final String typeName;
  final String? description;
  final String activeFlag;

  const CompLookupTypeDto({
    required this.lookupTypeGuid,
    required this.lookupTypeId,
    required this.typeCode,
    required this.typeName,
    required this.description,
    required this.activeFlag,
  });

  factory CompLookupTypeDto.fromJson(Map<String, dynamic> json) {
    return CompLookupTypeDto(
      lookupTypeGuid: (json['lookup_type_guid'] as String?) ?? '',
      lookupTypeId: (json['lookup_type_id'] as num?)?.toInt() ?? 0,
      typeCode: (json['type_code'] as String?) ?? '',
      typeName: (json['type_name'] as String?) ?? '',
      description: json['description'] as String?,
      activeFlag: (json['active_flag'] as String?) ?? 'N',
    );
  }

  CompLookupType toDomain() {
    return CompLookupType(
      lookupTypeId: lookupTypeId,
      lookupTypeGuid: lookupTypeGuid,
      typeCode: typeCode,
      typeName: typeName,
      description: description,
      isActive: activeFlag == 'Y',
    );
  }
}
