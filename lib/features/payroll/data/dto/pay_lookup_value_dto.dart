import 'package:grc/features/payroll/domain/models/pay_lookup_value.dart';

class PayLookupValuesResponseDto {
  const PayLookupValuesResponseDto({required this.success, this.message, required this.data});

  final bool success;
  final String? message;
  final List<PayLookupValueDto> data;

  factory PayLookupValuesResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? const [];
    return PayLookupValuesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: dataList.map((e) => PayLookupValueDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<PayLookupValue> toDomain() => data.map((dto) => dto.toDomain()).toList();
}

class PayLookupValueDto {
  const PayLookupValueDto({
    required this.lookupValueGuid,
    required this.typeCode,
    required this.valueCode,
    required this.valueName,
    this.displaySequence = 0,
    this.activeFlag = 'Y',
  });

  final String lookupValueGuid;
  final String typeCode;
  final String valueCode;
  final String valueName;
  final int displaySequence;
  final String activeFlag;

  factory PayLookupValueDto.fromJson(Map<String, dynamic> json) {
    return PayLookupValueDto(
      lookupValueGuid: json['lookup_value_guid'] as String? ?? '',
      typeCode: json['type_code'] as String? ?? '',
      valueCode: json['value_code'] as String? ?? '',
      valueName: json['value_name'] as String? ?? '',
      displaySequence: (json['display_sequence'] as num?)?.toInt() ?? 0,
      activeFlag: json['active_flag'] as String? ?? 'Y',
    );
  }

  PayLookupValue toDomain() {
    return PayLookupValue(
      lookupValueGuid: lookupValueGuid,
      typeCode: typeCode,
      valueCode: valueCode,
      valueName: valueName,
      displaySequence: displaySequence,
      activeFlag: activeFlag,
    );
  }
}
