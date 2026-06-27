class OrgStructureLevel {
  final int levelId;
  final String structureId;
  final int levelNumber;
  final String levelCode;
  final String levelName;
  final bool isMandatory;
  final bool isActive;
  final int displayOrder;

  const OrgStructureLevel({
    required this.levelId,
    required this.structureId,
    required this.levelNumber,
    required this.levelCode,
    required this.levelName,
    required this.isMandatory,
    required this.isActive,
    required this.displayOrder,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrgStructureLevel && other.levelId == levelId;
  }

  @override
  int get hashCode => levelId.hashCode;
}

class OrgStructure {
  final String structureId;
  final int enterpriseId;
  final String enterpriseName;
  final String structureCode;
  final String structureName;
  final String structureType;
  final String? description;
  final bool isActive;
  final List<OrgStructureLevel> levels;

  const OrgStructure({
    required this.structureId,
    required this.enterpriseId,
    required this.enterpriseName,
    required this.structureCode,
    required this.structureName,
    required this.structureType,
    this.description,
    required this.isActive,
    required this.levels,
  });

  List<OrgStructureLevel> get activeLevels =>
      levels.where((level) => level.isActive).toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

  List<OrgStructureLevel> get mandatoryLevels =>
      activeLevels.where((level) => level.isMandatory).toList();
}

extension OrgStructureLevelUI on OrgStructureLevel {
  String getLabel({String? divisionLabel, String? departmentLabel}) {
    final code = levelCode.toUpperCase();
    switch (code) {
      case 'COMPANY':
        return 'Company';
      case 'DIVISION':
        return divisionLabel ?? 'Division';
      case 'BUSINESS_UNIT':
        return 'Business Unit';
      case 'DEPARTMENT':
        return departmentLabel ?? 'Department';
      case 'SECT':
      case 'SECTION':
        return 'Section';
      default:
        return levelName;
    }
  }

  String getHint() {
    final code = levelCode.toUpperCase();
    switch (code) {
      case 'COMPANY':
        return 'e.g. Digify HR';
      case 'DIVISION':
        return 'e.g. Finance';
      case 'BUSINESS_UNIT':
        return 'e.g. Corporate Finance';
      case 'DEPARTMENT':
        return 'e.g. Accounting';
      case 'SECT':
      case 'SECTION':
        return 'e.g. Accounts Payable';
      default:
        return 'Enter $levelName';
    }
  }
}
