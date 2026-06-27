import 'package:grc/features/leave_management/domain/models/abs_lookup.dart';

class AbsLookupsResponseDto {
  final bool success;
  final AbsLookupsMetaDto? meta;
  final List<AbsLookupItemDto> data;

  const AbsLookupsResponseDto({required this.success, this.meta, required this.data});

  factory AbsLookupsResponseDto.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    final metaJson = json['meta'] as Map<String, dynamic>?;

    return AbsLookupsResponseDto(
      success: json['success'] as bool? ?? false,
      meta: metaJson != null ? AbsLookupsMetaDto.fromJson(metaJson) : null,
      data: dataList.map((e) => AbsLookupItemDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  List<AbsLookup> toDomain() => data.map((d) => d.toDomain()).toList();
}

class AbsLookupItemDto {
  final int lookupId;
  final String lookupCode;
  final String lookupName;
  final int tenantId;
  final String status;
  final String? createdBy;
  final String? createdDate;
  final String? lastUpdatedBy;
  final String? lastUpdateDate;

  const AbsLookupItemDto({
    required this.lookupId,
    required this.lookupCode,
    required this.lookupName,
    required this.tenantId,
    required this.status,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdateDate,
  });

  factory AbsLookupItemDto.fromJson(Map<String, dynamic> json) {
    return AbsLookupItemDto(
      lookupId: (json['lookup_id'] as num?)?.toInt() ?? 0,
      lookupCode: json['lookup_code'] as String? ?? '',
      lookupName: json['lookup_name'] as String? ?? '',
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'ACTIVE',
      createdBy: json['created_by'] as String?,
      createdDate: json['created_date'] as String?,
      lastUpdatedBy: json['last_updated_by'] as String?,
      lastUpdateDate: json['last_update_date'] as String?,
    );
  }

  AbsLookup toDomain() => AbsLookup(
    lookupId: lookupId,
    lookupCode: lookupCode,
    lookupName: lookupName,
    tenantId: tenantId,
    status: status,
    createdBy: createdBy,
    createdDate: createdDate,
    lastUpdatedBy: lastUpdatedBy,
    lastUpdateDate: lastUpdateDate,
  );
}

class AbsLookupsMetaDto {
  final int count;
  final int total;
  final String? executionTime;
  final int? tenantId;

  const AbsLookupsMetaDto({required this.count, required this.total, this.executionTime, this.tenantId});

  factory AbsLookupsMetaDto.fromJson(Map<String, dynamic> json) {
    return AbsLookupsMetaDto(
      count: (json['count'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      executionTime: json['execution_time'] as String?,
      tenantId: (json['tenant_id'] as num?)?.toInt(),
    );
  }
}
