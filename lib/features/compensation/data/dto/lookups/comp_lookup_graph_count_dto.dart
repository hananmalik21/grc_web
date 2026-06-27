class CompLookupGraphCountItemDto {
  final int lookupValueId;
  final String valueCode;
  final String valueName;
  final int displaySequence;
  final int count;

  const CompLookupGraphCountItemDto({
    required this.lookupValueId,
    required this.valueCode,
    required this.valueName,
    required this.displaySequence,
    required this.count,
  });

  factory CompLookupGraphCountItemDto.fromJson(Map<String, dynamic> json) {
    return CompLookupGraphCountItemDto(
      lookupValueId: (json['lookup_value_id'] as num?)?.toInt() ?? 0,
      valueCode: (json['value_code'] as String?) ?? '',
      valueName: (json['value_name'] as String?) ?? '',
      displaySequence: (json['display_sequence'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}
