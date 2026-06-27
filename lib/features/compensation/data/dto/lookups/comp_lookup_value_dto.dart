import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';

class CompLookupValueDto {
  final String lookupValueGuid;
  final int lookupValueId;
  final int lookupTypeId;
  final String valueCode;
  final String valueName;
  final int? displaySequence;
  final String activeFlag;

  const CompLookupValueDto({
    required this.lookupValueGuid,
    required this.lookupValueId,
    required this.lookupTypeId,
    required this.valueCode,
    required this.valueName,
    required this.displaySequence,
    required this.activeFlag,
  });

  factory CompLookupValueDto.fromJson(Map<String, dynamic> json) {
    return CompLookupValueDto(
      lookupValueGuid: (json['lookup_value_guid'] as String?) ?? '',
      lookupValueId: (json['lookup_value_id'] as num?)?.toInt() ?? 0,
      lookupTypeId: (json['lookup_type_id'] as num?)?.toInt() ?? 0,
      valueCode: (json['value_code'] as String?) ?? '',
      valueName: (json['value_name'] as String?) ?? '',
      displaySequence: (json['display_sequence'] as num?)?.toInt(),
      activeFlag: (json['active_flag'] as String?) ?? 'N',
    );
  }

  CompLookupValue toDomain() {
    return CompLookupValue(
      lookupValueId: lookupValueId,
      lookupValueGuid: lookupValueGuid,
      lookupTypeId: lookupTypeId,
      valueCode: valueCode,
      valueName: valueName,
      displaySequence: displaySequence,
      isActive: activeFlag == 'Y',
    );
  }
}
