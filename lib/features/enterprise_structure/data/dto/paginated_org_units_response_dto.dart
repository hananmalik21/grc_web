import 'package:grc/features/enterprise_structure/data/dto/org_structure_level_dto.dart';

/// DTO for paginated org units response
class PaginatedOrgUnitsResponseDto {
  final List<OrgStructureLevelDto> units;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  const PaginatedOrgUnitsResponseDto({
    required this.units,
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.totalItems,
  });

  factory PaginatedOrgUnitsResponseDto.fromJson(Map<String, dynamic> json) {
    // Handle different response formats
    List<dynamic> unitsData;
    int currentPage = 1;
    int pageSize = 10;
    int totalPages = 1;
    int totalItems = 0;

    // Check if response has pagination nested in meta.pagination (new format)
    if (json.containsKey('meta')) {
      final meta = json['meta'] as Map<String, dynamic>;

      // Check if pagination is nested in meta
      if (meta.containsKey('pagination')) {
        final pagination = meta['pagination'] as Map<String, dynamic>;
        currentPage = (pagination['page'] as num?)?.toInt() ?? 1;
        pageSize = (pagination['page_size'] as num?)?.toInt() ?? 10;
        totalPages = (pagination['total_pages'] as num?)?.toInt() ?? 1;
        totalItems = (pagination['total'] as num?)?.toInt() ?? 0;
      } else {
        // Fallback: pagination data might be directly in meta
        currentPage = (meta['current_page'] as num?)?.toInt() ?? (meta['page'] as num?)?.toInt() ?? 1;
        pageSize = (meta['page_size'] as num?)?.toInt() ?? (meta['per_page'] as num?)?.toInt() ?? 10;
        totalPages = (meta['total_pages'] as num?)?.toInt() ?? (meta['last_page'] as num?)?.toInt() ?? 1;
        totalItems = (meta['total'] as num?)?.toInt() ?? (meta['total_items'] as num?)?.toInt() ?? 0;
      }
    }
    // Check if response has pagination at root level (alternative format)
    else if (json.containsKey('pagination')) {
      final pagination = json['pagination'] as Map<String, dynamic>;
      currentPage = (pagination['page'] as num?)?.toInt() ?? 1;
      pageSize = (pagination['page_size'] as num?)?.toInt() ?? 10;
      totalPages = (pagination['total_pages'] as num?)?.toInt() ?? 1;
      totalItems = (pagination['total'] as num?)?.toInt() ?? 0;
    } else {
      // If no pagination metadata, try to calculate from data length
      if (json.containsKey('data') && json['data'] is List) {
        final dataList = json['data'] as List;
        totalItems = dataList.length;
        // If we have items but no pagination info, assume we're on page 1
        if (totalItems > 0) {
          currentPage = 1;
          totalPages = (totalItems / pageSize).ceil();
        }
      }
    }

    // Extract units list
    if (json.containsKey('data') && json['data'] is List) {
      unitsData = json['data'] as List<dynamic>;
    } else if (json.containsKey('units') && json['units'] is List) {
      unitsData = json['units'] as List<dynamic>;
    } else if (json is List) {
      unitsData = json as List<dynamic>;
    } else {
      unitsData = [];
    }

    final units = unitsData
        .whereType<Map<String, dynamic>>()
        .map((json) => OrgStructureLevelDto.fromJson(json))
        .toList();

    return PaginatedOrgUnitsResponseDto(
      units: units,
      currentPage: currentPage,
      pageSize: pageSize,
      totalPages: totalPages,
      totalItems: totalItems,
    );
  }
}
