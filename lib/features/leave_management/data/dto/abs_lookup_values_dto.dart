import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';

class AbsLookupValuesResponseDto {
  final bool success;
  final AbsLookupValuesMetaDto? meta;
  final List<AbsLookupValueItemDto> data;

  const AbsLookupValuesResponseDto({required this.success, this.meta, required this.data});

  factory AbsLookupValuesResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    final metaJson = json['meta'] as Map<String, dynamic>?;

    return AbsLookupValuesResponseDto(
      success: json['success'] as bool? ?? false,
      meta: metaJson != null ? AbsLookupValuesMetaDto.fromJson(metaJson) : null,
      data: dataList.map((e) => AbsLookupValueItemDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<AbsLookupValue> toDomain() => data.map((d) => d.toDomain()).toList();
}

class AbsLookupValueItemDto {
  final int lookupValueId;
  final int lookupId;
  final String lookupValueCode;
  final String lookupValueName;
  final int displayOrder;
  final String status;
  final int tenantId;
  final String? createdBy;
  final String? createdDate;

  const AbsLookupValueItemDto({
    required this.lookupValueId,
    required this.lookupId,
    required this.lookupValueCode,
    required this.lookupValueName,
    required this.displayOrder,
    required this.status,
    required this.tenantId,
    this.createdBy,
    this.createdDate,
  });

  factory AbsLookupValueItemDto.fromJson(Map<String, dynamic> json) {
    return AbsLookupValueItemDto(
      lookupValueId: (json['lookup_value_id'] as num?)?.toInt() ?? 0,
      lookupId: (json['lookup_id'] as num?)?.toInt() ?? 0,
      lookupValueCode: json['lookup_value_code'] as String? ?? '',
      lookupValueName: json['lookup_value_name'] as String? ?? '',
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'ACTIVE',
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      createdBy: json['created_by'] as String?,
      createdDate: json['created_date'] as String?,
    );
  }

  AbsLookupValue toDomain() => AbsLookupValue(
    lookupValueId: lookupValueId,
    lookupId: lookupId,
    lookupValueCode: lookupValueCode,
    lookupValueName: lookupValueName,
    displayOrder: displayOrder,
    status: status,
    tenantId: tenantId,
    createdBy: createdBy,
    createdDate: createdDate,
  );
}

class AbsLookupValuesMetaDto {
  final int count;
  final int total;
  final String? executionTime;
  final int? lookupId;
  final int? tenantId;

  const AbsLookupValuesMetaDto({
    required this.count,
    required this.total,
    this.executionTime,
    this.lookupId,
    this.tenantId,
  });

  factory AbsLookupValuesMetaDto.fromJson(Map<String, dynamic> json) {
    return AbsLookupValuesMetaDto(
      count: (json['count'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      executionTime: json['execution_time'] as String?,
      lookupId: (json['lookup_id'] as num?)?.toInt(),
      tenantId: (json['tenant_id'] as num?)?.toInt(),
    );
  }
}
