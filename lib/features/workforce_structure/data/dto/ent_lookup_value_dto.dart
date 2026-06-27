import 'package:grc/features/employee_management/data/dto/empl_lookup_dto.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';

class EntLookupValueDto {
  final String lookupGuid;
  final int lookupId;
  final int? enterpriseId;
  final String lookupType;
  final String lookupCode;
  final String? meaningEn;
  final String? meaningAr;
  final int displaySequence;
  final String isEnabled;

  const EntLookupValueDto({
    required this.lookupGuid,
    required this.lookupId,
    this.enterpriseId,
    required this.lookupType,
    required this.lookupCode,
    this.meaningEn,
    this.meaningAr,
    this.displaySequence = 0,
    this.isEnabled = 'Y',
  });

  factory EntLookupValueDto.fromJson(Map<String, dynamic> json) {
    return EntLookupValueDto(
      lookupGuid: json['lookup_guid'] as String? ?? '',
      lookupId: (json['lookup_id'] as num).toInt(),
      enterpriseId: json['enterprise_id'] == null ? null : (json['enterprise_id'] as num).toInt(),
      lookupType: json['lookup_type'] as String? ?? '',
      lookupCode: json['lookup_code'] as String? ?? '',
      meaningEn: json['meaning_en'] as String?,
      meaningAr: json['meaning_ar'] as String?,
      displaySequence: (json['display_sequence'] as num?)?.toInt() ?? 0,
      isEnabled: json['is_enabled'] as String? ?? 'Y',
    );
  }

  EmplLookupValue toDomain() => EmplLookupValue(
    lookupId: lookupId,
    enterpriseId: enterpriseId,
    lookupCode: lookupCode,
    meaningEn: meaningEn ?? lookupCode,
    meaningAr: meaningAr ?? meaningEn ?? lookupCode,
    displaySequence: displaySequence,
  );
}

class EntLookupValuesResponseDto {
  final bool success;
  final String? message;
  final EmplLookupPaginationMetaDto meta;
  final List<EntLookupValueDto> data;

  const EntLookupValuesResponseDto({required this.success, this.message, required this.meta, required this.data});

  factory EntLookupValuesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List<dynamic>? ?? [];

    return EntLookupValuesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: EmplLookupPaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => EntLookupValueDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<EmplLookupValue> toDomain() => data.map((d) => d.toDomain()).toList();
}
