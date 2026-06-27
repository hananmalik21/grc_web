import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';

class RecLookupTypesResponseDto {
  const RecLookupTypesResponseDto({required this.success, this.message, required this.meta, required this.data});

  final bool success;
  final String? message;
  final RecLookupPaginationMetaDto meta;
  final List<RecLookupTypeDto> data;

  factory RecLookupTypesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? metaJson;
    final dataList = json['data'] as List<dynamic>? ?? [];
    return RecLookupTypesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: RecLookupPaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => RecLookupTypeDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class RecLookupValuesResponseDto {
  const RecLookupValuesResponseDto({required this.success, this.message, required this.meta, required this.data});

  final bool success;
  final String? message;
  final RecLookupPaginationMetaDto meta;
  final List<RecLookupValueDto> data;

  factory RecLookupValuesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? metaJson;
    final dataList = json['data'] as List<dynamic>? ?? [];
    return RecLookupValuesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: RecLookupPaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => RecLookupValueDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<RecLookupValue> toDomain() => data.map((d) => d.toDomain()).toList();
}

class RecLookupPaginationMetaDto {
  const RecLookupPaginationMetaDto({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory RecLookupPaginationMetaDto.fromJson(Map<String, dynamic> json) {
    return RecLookupPaginationMetaDto(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }
}

class RecLookupTypeDto {
  const RecLookupTypeDto({
    required this.lookupTypeGuid,
    required this.lookupTypeId,
    required this.enterpriseId,
    required this.typeCode,
    required this.typeName,
    required this.isActive,
  });

  final String lookupTypeGuid;
  final int lookupTypeId;
  final int enterpriseId;
  final String typeCode;
  final String typeName;
  final String isActive;

  factory RecLookupTypeDto.fromJson(Map<String, dynamic> json) {
    return RecLookupTypeDto(
      lookupTypeGuid: json['lookup_type_guid'] as String? ?? '',
      lookupTypeId: (json['lookup_type_id'] as num?)?.toInt() ?? 0,
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      typeCode: json['type_code'] as String? ?? '',
      typeName: json['type_name'] as String? ?? '',
      isActive: json['is_active'] as String? ?? 'Y',
    );
  }

  RecLookupType toDomain() => RecLookupType(
    lookupTypeGuid: lookupTypeGuid,
    lookupTypeId: lookupTypeId,
    typeCode: typeCode,
    typeName: typeName,
    isActive: isActive,
  );
}

class RecLookupValueDto {
  const RecLookupValueDto({
    required this.lookupGuid,
    required this.lookupId,
    required this.enterpriseId,
    required this.lookupType,
    required this.lookupCode,
    this.meaningEn,
    this.meaningAr,
    this.descriptionEn,
    this.descriptionAr,
    this.displaySequence = 0,
    this.isEnabled = 'Y',
  });

  final String lookupGuid;
  final int lookupId;
  final int enterpriseId;
  final String lookupType;
  final String lookupCode;
  final String? meaningEn;
  final String? meaningAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final int displaySequence;
  final String isEnabled;

  factory RecLookupValueDto.fromJson(Map<String, dynamic> json) {
    return RecLookupValueDto(
      lookupGuid: json['lookup_guid'] as String? ?? '',
      lookupId: (json['lookup_id'] as num?)?.toInt() ?? 0,
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      lookupType: json['lookup_type'] as String? ?? '',
      lookupCode: json['lookup_code'] as String? ?? '',
      meaningEn: json['meaning_en'] as String?,
      meaningAr: json['meaning_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      displaySequence: (json['display_sequence'] as num?)?.toInt() ?? 0,
      isEnabled: json['is_enabled'] as String? ?? 'Y',
    );
  }

  RecLookupValue toDomain() {
    final en = meaningEn ?? lookupCode;
    final ar = meaningAr ?? en;
    return RecLookupValue(
      lookupGuid: lookupGuid,
      lookupId: lookupId,
      lookupType: lookupType,
      lookupCode: lookupCode,
      meaningEn: en,
      meaningAr: ar,
      displaySequence: displaySequence,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      isEnabled: isEnabled,
    );
  }
}
