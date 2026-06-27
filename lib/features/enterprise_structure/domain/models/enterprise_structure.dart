/// Domain model for Enterprise Structure
class EnterpriseStructure {
  final int? enterpriseId;
  final String structureCode;
  final String structureName;
  final String structureType;
  final String description;
  final bool isActive;
  final List<EnterpriseStructureLevel> levels;

  const EnterpriseStructure({
    this.enterpriseId,
    required this.structureCode,
    required this.structureName,
    required this.structureType,
    required this.description,
    required this.isActive,
    required this.levels,
  });
}

/// Domain model for Enterprise Structure Level
class EnterpriseStructureLevel {
  final int structureLevelId;
  final int levelNumber;
  final int displayOrder;

  const EnterpriseStructureLevel({
    required this.structureLevelId,
    required this.levelNumber,
    required this.displayOrder,
  });
}

