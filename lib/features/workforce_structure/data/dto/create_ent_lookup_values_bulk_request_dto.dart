class CreateEntLookupValuesBulkRequestDto {
  final int enterpriseId;
  final int lookupTypeId;
  final String lookupType;
  final List<BulkEntLookupValueItemDto> values;

  const CreateEntLookupValuesBulkRequestDto({
    required this.enterpriseId,
    required this.lookupTypeId,
    required this.lookupType,
    required this.values,
  });

  Map<String, dynamic> toJson() => {
    'enterprise_id': enterpriseId,
    'lookup_type_id': lookupTypeId,
    'lookup_type': lookupType,
    'values': values.map((v) => v.toJson()).toList(),
  };
}

class BulkEntLookupValueItemDto {
  final String lookupCode;
  final String meaningEn;
  final String? meaningAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final int displaySequence;
  final String isEnabled;
  final String? startDate;
  final String? endDate;

  const BulkEntLookupValueItemDto({
    required this.lookupCode,
    required this.meaningEn,
    this.meaningAr,
    this.descriptionEn,
    this.descriptionAr,
    required this.displaySequence,
    this.isEnabled = 'Y',
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() => {
    'lookup_code': lookupCode,
    'meaning_en': meaningEn,
    'meaning_ar': meaningAr,
    'description_en': descriptionEn,
    'description_ar': descriptionAr,
    'display_sequence': displaySequence,
    'is_enabled': isEnabled,
    if (startDate != null) 'start_date': startDate,
    if (endDate != null) 'end_date': endDate,
  };
}
