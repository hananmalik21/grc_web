class SecurityLookupValue {
  const SecurityLookupValue({
    required this.lookupValueGuid,
    required this.lookupValueId,
    this.enterpriseId,
    required this.lookupTypeId,
    required this.valueCode,
    required this.valueName,
    required this.displaySequence,
    required this.activeFlag,
  });

  final String lookupValueGuid;
  final int lookupValueId;
  final int? enterpriseId;
  final int lookupTypeId;
  final String valueCode;
  final String valueName;
  final int displaySequence;
  final String activeFlag;

  bool get isActive => activeFlag.toUpperCase() == 'Y';

  factory SecurityLookupValue.fromJson(Map<String, dynamic> json) {
    return SecurityLookupValue(
      lookupValueGuid: json['lookup_value_guid'] as String? ?? '',
      lookupValueId: _asInt(json['lookup_value_id']),
      enterpriseId: _asNullableInt(json['enterprise_id']),
      lookupTypeId: _asInt(json['lookup_type_id']),
      valueCode: json['value_code'] as String? ?? '',
      valueName: json['value_name'] as String? ?? '',
      displaySequence: _asInt(json['display_sequence']),
      activeFlag: json['active_flag'] as String? ?? 'Y',
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  static int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse('$value');
  }
}
