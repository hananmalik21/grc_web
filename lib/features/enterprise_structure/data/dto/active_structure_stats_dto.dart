import 'package:grc/features/enterprise_structure/domain/models/active_structure_stats.dart';

class ActiveStructureInfoDto {
  final String structureId;
  final int enterpriseId;
  final String? enterpriseName;
  final String structureCode;
  final String structureName;

  const ActiveStructureInfoDto({
    required this.structureId,
    required this.structureCode,
    required this.structureName,
    this.enterpriseId = 0,
    this.enterpriseName,
  });

  factory ActiveStructureInfoDto.fromJson(Map<String, dynamic> json) {
    return ActiveStructureInfoDto(
      structureId: _str(json['structure_id']) ?? '',
      enterpriseId: _int(json['enterprise_id']),
      enterpriseName: _str(json['enterprise_name']),
      structureCode: _str(json['structure_code']) ?? '',
      structureName: _str(json['structure_name']) ?? '',
    );
  }

  ActiveStructureInfo toDomain() {
    return ActiveStructureInfo(
      structureId: structureId,
      enterpriseId: enterpriseId,
      enterpriseName: enterpriseName,
      structureCode: structureCode,
      structureName: structureName,
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString();
  }

  static int _int(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }
}

class LevelWithComponentsDto {
  final int levelId;
  final String levelCode;
  final String levelName;
  final int levelNumber;
  final int displayOrder;
  final int componentCount;

  const LevelWithComponentsDto({
    required this.levelId,
    required this.levelCode,
    required this.levelName,
    required this.levelNumber,
    required this.displayOrder,
    required this.componentCount,
  });

  factory LevelWithComponentsDto.fromJson(Map<String, dynamic> json) {
    return LevelWithComponentsDto(
      levelId: _int(json['level_id']),
      levelCode: _str(json['level_code']) ?? '',
      levelName: _str(json['level_name']) ?? '',
      levelNumber: _int(json['level_number']),
      displayOrder: _int(json['display_order']),
      componentCount: _int(json['component_count']),
    );
  }

  LevelWithComponents toDomain() {
    return LevelWithComponents(
      levelId: levelId,
      levelCode: levelCode,
      levelName: levelName,
      levelNumber: levelNumber,
      displayOrder: displayOrder,
      componentCount: componentCount,
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString();
  }

  static int _int(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }
}

class ActiveStructureStatsDto {
  final ActiveStructureInfoDto activeStructure;
  final List<LevelWithComponentsDto> levelsWithComponents;

  const ActiveStructureStatsDto({required this.activeStructure, required this.levelsWithComponents});

  factory ActiveStructureStatsDto.fromJson(Map<String, dynamic> json) {
    final activeStructureJson = json['active_structure'] as Map<String, dynamic>?;
    final levelsJson = json['levels_with_components'] as List<dynamic>? ?? [];

    return ActiveStructureStatsDto(
      activeStructure: activeStructureJson != null
          ? ActiveStructureInfoDto.fromJson(activeStructureJson)
          : const ActiveStructureInfoDto(structureId: '', structureCode: '', structureName: ''),
      levelsWithComponents: levelsJson.map((e) => LevelWithComponentsDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  ActiveStructureStats toDomain() {
    return ActiveStructureStats(
      activeStructure: activeStructure.toDomain(),
      levelsWithComponents: levelsWithComponents.map((e) => e.toDomain()).toList(),
    );
  }
}
