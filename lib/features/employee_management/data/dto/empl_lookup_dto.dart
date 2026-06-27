import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';

class EmplLookupTypesResponseDto {
  final bool success;
  final String? message;
  final EmplLookupPaginationMetaDto meta;
  final List<EmplLookupTypeDto> data;

  const EmplLookupTypesResponseDto({required this.success, this.message, required this.meta, required this.data});

  factory EmplLookupTypesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List<dynamic>? ?? [];
    return EmplLookupTypesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: EmplLookupPaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => EmplLookupTypeDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class EmplLookupPaginationMetaDto {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const EmplLookupPaginationMetaDto({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory EmplLookupPaginationMetaDto.fromJson(Map<String, dynamic> json) {
    return EmplLookupPaginationMetaDto(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }
}

class EmplLookupTypeDto {
  final String lookupTypeGuid;
  final int lookupTypeId;
  final int? enterpriseId;
  final String typeCode;
  final String typeName;
  final String isActive;

  const EmplLookupTypeDto({
    required this.lookupTypeGuid,
    required this.lookupTypeId,
    this.enterpriseId,
    required this.typeCode,
    required this.typeName,
    required this.isActive,
  });

  factory EmplLookupTypeDto.fromJson(Map<String, dynamic> json) {
    return EmplLookupTypeDto(
      lookupTypeGuid: json['lookup_type_guid'] as String? ?? '',
      lookupTypeId: (json['lookup_type_id'] as num).toInt(),
      enterpriseId: (json['enterprise_id'] as num?)?.toInt(),
      typeCode: json['type_code'] as String? ?? '',
      typeName: json['type_name'] as String? ?? '',
      isActive: json['is_active'] as String? ?? 'Y',
    );
  }
}

class EmplLookupValuesResponseDto {
  final bool success;
  final String? message;
  final EmplLookupPaginationMetaDto meta;
  final List<EmplLookupValueDto> data;

  const EmplLookupValuesResponseDto({required this.success, this.message, required this.meta, required this.data});

  factory EmplLookupValuesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List<dynamic>? ?? [];
    return EmplLookupValuesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: EmplLookupPaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => EmplLookupValueDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<EmplLookupValue> toDomain() => data.map((d) => d.toDomain()).toList();
}

class EmplLookupValueDto {
  final String lookupGuid;
  final int lookupId;
  final int? enterpriseId;
  final String lookupType;
  final String lookupCode;
  final String? meaningEn;
  final String? meaningAr;
  final int displaySequence;
  final String isEnabled;

  const EmplLookupValueDto({
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

  factory EmplLookupValueDto.fromJson(Map<String, dynamic> json) {
    return EmplLookupValueDto(
      lookupGuid: json['lookup_guid'] as String? ?? '',
      lookupId: (json['lookup_id'] as num).toInt(),
      enterpriseId: (json['enterprise_id'] as num?)?.toInt(),
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
