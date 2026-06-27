/// Domain model for a structure list item
class StructureListItem {
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
  final List<StructureLevelItem> levels;
  final int orgUnitCount;
  final int employeeCount;

  const StructureListItem({
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

  StructureListItem copyWith({
    String? structureId,
    int? enterpriseId,
    String? enterpriseName,
    String? structureCode,
    String? structureName,
    String? structureType,
    String? description,
    bool? isActive,
    DateTime? createdDate,
    DateTime? lastUpdatedDate,
    List<StructureLevelItem>? levels,
    int? orgUnitCount,
    int? employeeCount,
  }) {
    return StructureListItem(
      structureId: structureId ?? this.structureId,
      enterpriseId: enterpriseId ?? this.enterpriseId,
      enterpriseName: enterpriseName ?? this.enterpriseName,
      structureCode: structureCode ?? this.structureCode,
      structureName: structureName ?? this.structureName,
      structureType: structureType ?? this.structureType,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdDate: createdDate ?? this.createdDate,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      levels: levels ?? this.levels,
      orgUnitCount: orgUnitCount ?? this.orgUnitCount,
      employeeCount: employeeCount ?? this.employeeCount,
    );
  }
}

/// Domain model for a structure level item in the list
class StructureLevelItem {
  final int levelId;
  final int levelNumber;
  final String levelCode;
  final String levelName;
  final bool isMandatory;
  final bool isActive;
  final int displayOrder;

  const StructureLevelItem({
    required this.levelId,
    required this.levelNumber,
    required this.levelCode,
    required this.levelName,
    required this.isMandatory,
    required this.isActive,
    required this.displayOrder,
  });
}

/// Pagination information
class PaginationInfo {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationInfo({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}

/// Paginated response for structure list
class PaginatedStructureList {
  final List<StructureListItem> structures;
  final PaginationInfo pagination;
  final int total;
  final int count;

  const PaginatedStructureList({
    required this.structures,
    required this.pagination,
    required this.total,
    required this.count,
  });
}
