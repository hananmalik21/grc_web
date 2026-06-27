/// DTO for saving enterprise structure request
class SaveEnterpriseStructureRequestDto {
  final int? enterpriseId;
  final String structureCode;
  final String structureName;
  final String structureType;
  final String description;
  final bool isActive;
  final List<StructureLevelDto> levels;

  const SaveEnterpriseStructureRequestDto({
    this.enterpriseId,
    required this.structureCode,
    required this.structureName,
    required this.structureType,
    required this.description,
    required this.isActive,
    required this.levels,
  });

  /// Converts to JSON for API request
  /// For updates (PUT), levels should be empty and not included in the request
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      if (enterpriseId != null) 'ENTERPRISE_ID': enterpriseId,
      'STRUCTURE_CODE': structureCode,
      'STRUCTURE_NAME': structureName,
      'STRUCTURE_TYPE': structureType,
      'DESCRIPTION': description,
      'IS_ACTIVE': isActive,
    };
    
    // Only include levels if the list is not empty (for create operations)
    if (levels.isNotEmpty) {
      json['levels'] = levels.map((level) => level.toJson()).toList();
    }
    
    return json;
  }
}

/// DTO for structure level in save request
class StructureLevelDto {
  final int structureLevelId;
  final int levelNumber;
  final int displayOrder;

  const StructureLevelDto({
    required this.structureLevelId,
    required this.levelNumber,
    required this.displayOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'STRUCTURE_LEVEL_ID': structureLevelId,
      'LEVEL_NUMBER': levelNumber,
      'DISPLAY_ORDER': displayOrder,
    };
  }
}

