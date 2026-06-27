import 'package:grc/features/hiring/domain/models/talent_pools/talent_pool.dart';
import 'package:grc/features/hiring/domain/models/talent_pools/talent_pools_page.dart';
import 'package:grc/features/hiring/domain/models/talent_pools/talent_pools_pagination.dart';

class TalentPoolsPageDto {
  const TalentPoolsPageDto({required this.items, this.pagination});

  final List<TalentPoolDto> items;
  final TalentPoolsPaginationDto? pagination;

  factory TalentPoolsPageDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(TalentPoolDto.fromJson)
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>?;
    final paginationJson = metaJson?['pagination'];
    final pagination = paginationJson is Map<String, dynamic>
        ? TalentPoolsPaginationDto.fromJson(paginationJson)
        : null;

    return TalentPoolsPageDto(items: data, pagination: pagination);
  }

  TalentPoolsPage toDomain() {
    return TalentPoolsPage(items: items.map((dto) => dto.toDomain()).toList(), pagination: pagination?.toDomain());
  }
}

class TalentPoolDto {
  const TalentPoolDto({required this.poolGuid, required this.poolName, required this.candidateCount});

  final String poolGuid;
  final String poolName;
  final int candidateCount;

  factory TalentPoolDto.fromJson(Map<String, dynamic> json) {
    return TalentPoolDto(
      poolGuid: json['pool_guid'] as String? ?? '',
      poolName: json['pool_name'] as String? ?? '',
      candidateCount: _parseInt(json['candidate_count']),
    );
  }

  TalentPool toDomain() {
    return TalentPool(poolGuid: poolGuid, poolName: poolName, candidateCount: candidateCount);
  }
}

class TalentPoolsPaginationDto {
  const TalentPoolsPaginationDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory TalentPoolsPaginationDto.fromJson(Map<String, dynamic> json) {
    return TalentPoolsPaginationDto(
      page: _parseInt(json['page'], defaultValue: 1),
      pageSize: _parseInt(json['page_size'] ?? json['pageSize'], defaultValue: 10),
      total: _parseInt(json['total']),
      totalPages: _parseInt(json['total_pages'] ?? json['totalPages'], defaultValue: 1),
      hasNext: _parseBool(json['has_next'] ?? json['hasNext']),
      hasPrevious: _parseBool(json['has_previous'] ?? json['hasPrevious']),
    );
  }

  TalentPoolsPagination toDomain() {
    return TalentPoolsPagination(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

int _parseInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  if (value is num) return value != 0;
  return false;
}
