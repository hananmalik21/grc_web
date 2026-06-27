class ActiveStructureInfo {
  final String structureId;
  final int enterpriseId;
  final String? enterpriseName;
  final String structureCode;
  final String structureName;

  const ActiveStructureInfo({
    required this.structureId,
    required this.enterpriseId,
    this.enterpriseName,
    required this.structureCode,
    required this.structureName,
  });
}

class LevelWithComponents {
  final int levelId;
  final String levelCode;
  final String levelName;
  final int levelNumber;
  final int displayOrder;
  final int componentCount;

  const LevelWithComponents({
    required this.levelId,
    required this.levelCode,
    required this.levelName,
    required this.levelNumber,
    required this.displayOrder,
    required this.componentCount,
  });

  String get formattedComponentCount => componentCount.toString();
}

class ActiveStructureStats {
  final ActiveStructureInfo activeStructure;
  final List<LevelWithComponents> levelsWithComponents;

  const ActiveStructureStats({required this.activeStructure, required this.levelsWithComponents});

  static const empty = ActiveStructureStats(
    activeStructure: ActiveStructureInfo(structureId: '', enterpriseId: 0, structureCode: '', structureName: ''),
    levelsWithComponents: [],
  );
}
