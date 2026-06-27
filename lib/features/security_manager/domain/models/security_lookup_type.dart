class SecurityLookupType {
  const SecurityLookupType({
    required this.lookupTypeGuid,
    required this.lookupTypeId,
    this.enterpriseId,
    required this.typeCode,
    required this.typeName,
    this.description,
    required this.activeFlag,
  });

  final String lookupTypeGuid;
  final int lookupTypeId;
  final int? enterpriseId;
  final String typeCode;
  final String typeName;
  final String? description;
  final String activeFlag;

  bool get isActive => activeFlag.toUpperCase() == 'Y';

  factory SecurityLookupType.fromJson(Map<String, dynamic> json) {
    return SecurityLookupType(
      lookupTypeGuid: json['lookup_type_guid'] as String? ?? '',
      lookupTypeId: _asInt(json['lookup_type_id']),
      enterpriseId: _asNullableInt(json['enterprise_id']),
      typeCode: json['type_code'] as String? ?? '',
      typeName: json['type_name'] as String? ?? '',
      description: json['description'] as String?,
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
