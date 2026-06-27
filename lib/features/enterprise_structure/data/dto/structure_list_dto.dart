import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';

/// DTO for structure list item
class StructureListItemDto {
  final String structureId;
  final int enterpriseId;
  final String? enterpriseName;
  final String structureCode;
  final String structureName;
  final String structureType;
  final String description;
  final bool isActive;
  final DateTime createdDate;
  final DateTime? lastUpdatedDate;
  final List<StructureLevelItemDto> levels;
  final int orgUnitCount;
  final int employeeCount;

  const StructureListItemDto({
    required this.structureId,
    required this.enterpriseId,
    this.enterpriseName,
    required this.structureCode,
    required this.structureName,
    required this.structureType,
    required this.description,
    required this.isActive,
    required this.createdDate,
    this.lastUpdatedDate,
    required this.levels,
    this.orgUnitCount = 0,
    this.employeeCount = 0,
  });

  factory StructureListItemDto.fromJson(Map<String, dynamic> json) {
    // Parse is_active from "Y"/"N" or boolean
    final isActiveValue = json['is_active'] ?? json['isActive'] ?? 'Y';
    final isActive = isActiveValue is bool
        ? isActiveValue
        : (isActiveValue.toString().toUpperCase() == 'Y' || isActiveValue.toString() == 'true');

    // Parse dates
    final createdDateStr = json['created_date'] as String? ?? json['createdDate'] as String? ?? '';
    final createdDate = DateTime.tryParse(createdDateStr) ?? DateTime.now();

    final lastUpdatedDateStr = json['last_updated_date'] as String? ?? json['lastUpdatedDate'] as String?;
    final lastUpdatedDate = lastUpdatedDateStr != null ? DateTime.tryParse(lastUpdatedDateStr) : null;

    // Parse levels
    final levelsJson = json['levels'] as List<dynamic>? ?? [];
    final levels = levelsJson
        .map((levelJson) => StructureLevelItemDto.fromJson(levelJson as Map<String, dynamic>))
        .toList();

    return StructureListItemDto(
      structureId:
          (json['structure_id'] as String?) ??
          (json['structure_id'] as num?)?.toString() ??
          (json['id'] as String?) ??
          (json['id'] as num?)?.toString() ??
          '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? (json['enterpriseId'] as num?)?.toInt() ?? 0,
      enterpriseName: json['enterprise_name'] as String? ?? json['enterpriseName'] as String?,
      structureCode: json['structure_code'] as String? ?? json['structureCode'] as String? ?? '',
      structureName: json['structure_name'] as String? ?? json['structureName'] as String? ?? '',
      structureType: json['structure_type'] as String? ?? json['structureType'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isActive: isActive,
      createdDate: createdDate,
      lastUpdatedDate: lastUpdatedDate,
      levels: levels,
      orgUnitCount: (json['org_unit_count'] as num?)?.toInt() ?? (json['orgUnitCount'] as num?)?.toInt() ?? 0,
      employeeCount: (json['employee_count'] as num?)?.toInt() ?? (json['employeeCount'] as num?)?.toInt() ?? 0,
    );
  }

  StructureListItem toDomain() {
    return StructureListItem(
      structureId: structureId,
      enterpriseId: enterpriseId,
      enterpriseName: enterpriseName,
      structureCode: structureCode,
      structureName: structureName,
      structureType: structureType,
      description: description,
      isActive: isActive,
      createdDate: createdDate,
      lastUpdatedDate: lastUpdatedDate,
      levels: levels.map((level) => level.toDomain()).toList(),
      orgUnitCount: orgUnitCount,
      employeeCount: employeeCount,
    );
  }
}

/// DTO for structure level item
class StructureLevelItemDto {
  final int levelId;
  final int levelNumber;
  final String levelCode;
  final String levelName;
  final bool isMandatory;
  final bool isActive;
  final int displayOrder;

  const StructureLevelItemDto({
    required this.levelId,
    required this.levelNumber,
    required this.levelCode,
    required this.levelName,
    required this.isMandatory,
    required this.isActive,
    required this.displayOrder,
  });

  factory StructureLevelItemDto.fromJson(Map<String, dynamic> json) {
    // Parse is_mandatory from "Y"/"N" or boolean
    final isMandatoryValue = json['is_mandatory'] as String? ?? json['isMandatory']?.toString() ?? 'N';
    final isMandatory =
        isMandatoryValue.toUpperCase() == 'Y' || isMandatoryValue == 'true' || (json['isMandatory'] as bool? ?? false);

    // Parse is_active from "Y"/"N" or boolean
    final isActiveValue = json['is_active'] as String? ?? json['isActive']?.toString() ?? 'Y';
    final isActive =
        isActiveValue.toUpperCase() == 'Y' || isActiveValue == 'true' || (json['isActive'] as bool? ?? true);

    return StructureLevelItemDto(
      levelId: (json['level_id'] as num?)?.toInt() ?? (json['id'] as num?)?.toInt() ?? 0,
      levelNumber: (json['level_number'] as num?)?.toInt() ?? (json['levelNumber'] as num?)?.toInt() ?? 0,
      levelCode: json['level_code'] as String? ?? json['levelCode'] as String? ?? '',
      levelName: json['level_name'] as String? ?? json['levelName'] as String? ?? '',
      isMandatory: isMandatory,
      isActive: isActive,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? (json['displayOrder'] as num?)?.toInt() ?? 0,
    );
  }

  StructureLevelItem toDomain() {
    return StructureLevelItem(
      levelId: levelId,
      levelNumber: levelNumber,
      levelCode: levelCode,
      levelName: levelName,
      isMandatory: isMandatory,
      isActive: isActive,
      displayOrder: displayOrder,
    );
  }
}

/// DTO for paginated structure list response
class PaginatedStructureListDto {
  final List<StructureListItemDto> structures;
  final PaginationInfoDto pagination;
  final int total;
  final int count;

  const PaginatedStructureListDto({
    required this.structures,
    required this.pagination,
    required this.total,
    required this.count,
  });

  factory PaginatedStructureListDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final structures = data.map((item) => StructureListItemDto.fromJson(item as Map<String, dynamic>)).toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = meta['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationInfoDto.fromJson(paginationJson);

    final count = structures.length;
    final total = (meta['total'] as num?)?.toInt() ?? _deriveTotal(pagination, count);

    return PaginatedStructureListDto(structures: structures, pagination: pagination, total: total, count: count);
  }

  static int _deriveTotal(PaginationInfoDto p, int itemCount) {
    if (p.hasNext) return 0;
    return (p.page - 1) * p.pageSize + itemCount;
  }

  PaginatedStructureList toDomain() {
    final paginationWithTotal = PaginationInfo(
      page: pagination.page,
      pageSize: pagination.pageSize,
      total: total,
      totalPages: pagination.totalPages,
      hasNext: pagination.hasNext,
      hasPrevious: pagination.hasPrevious,
    );
    return PaginatedStructureList(
      structures: structures.map((s) => s.toDomain()).toList(),
      pagination: paginationWithTotal,
      total: total,
      count: count,
    );
  }
}

/// DTO for pagination info
class PaginationInfoDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationInfoDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfoDto.fromJson(Map<String, dynamic> json) {
    return PaginationInfoDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? (json['pageSize'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? (json['totalPages'] as num?)?.toInt() ?? 1,
      hasNext: json['has_next'] as bool? ?? json['hasNext'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? json['hasPrevious'] as bool? ?? false,
    );
  }

  PaginationInfo toDomain() {
    return PaginationInfo(
      page: page,
      pageSize: pageSize,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}
