import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';

/// DTO for Active Structure Level Definition
class ActiveStructureLevelDto {
  final int levelId;
  final String structureId;
  final int levelNumber;
  final String levelCode;
  final String levelName;
  final String isMandatory;
  final String isActive;
  final int displayOrder;

  const ActiveStructureLevelDto({
    required this.levelId,
    required this.structureId,
    required this.levelNumber,
    required this.levelCode,
    required this.levelName,
    required this.isMandatory,
    required this.isActive,
    required this.displayOrder,
  });

  /// Creates DTO from JSON
  factory ActiveStructureLevelDto.fromJson(Map<String, dynamic> json) {
    return ActiveStructureLevelDto(
      levelId: (json['level_id'] as num?)?.toInt() ??
          (json['levelId'] as num?)?.toInt() ??
          0,
      structureId: (json['structure_id'] as String?) ??
          (json['structure_id'] as num?)?.toString() ??
          (json['structureId'] as String?) ??
          (json['structureId'] as num?)?.toString() ??
          '',
      levelNumber: (json['level_number'] as num?)?.toInt() ??
          (json['levelNumber'] as num?)?.toInt() ??
          0,
      levelCode: json['level_code'] as String? ??
          json['levelCode'] as String? ??
          '',
      levelName: json['level_name'] as String? ??
          json['levelName'] as String? ??
          '',
      isMandatory: json['is_mandatory'] as String? ??
          json['isMandatory'] as String? ??
          'N',
      isActive: json['is_active'] as String? ??
          json['isActive'] as String? ??
          'N',
      displayOrder: (json['display_order'] as num?)?.toInt() ??
          (json['displayOrder'] as num?)?.toInt() ??
          0,
    );
  }

  /// Converts DTO to domain model
  ActiveStructureLevel toDomain() {
    return ActiveStructureLevel(
      levelId: levelId,
      structureId: structureId,
      levelNumber: levelNumber,
      levelCode: levelCode,
      levelName: levelName,
      isMandatory: isMandatory.toUpperCase() == 'Y',
      isActive: isActive.toUpperCase() == 'Y',
      displayOrder: displayOrder,
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'level_id': levelId,
      'structure_id': structureId,
      'level_number': levelNumber,
      'level_code': levelCode,
      'level_name': levelName,
      'is_mandatory': isMandatory,
      'is_active': isActive,
      'display_order': displayOrder,
    };
  }
}

/// DTO for Active Structure Response
class ActiveStructureResponseDto {
  final String structureId;
  final int enterpriseId;
  final String enterpriseName;
  final String structureCode;
  final String structureName;
  final String structureType;
  final String? description;
  final String isActive;
  final List<ActiveStructureLevelDto> levels;

  const ActiveStructureResponseDto({
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

  /// Creates DTO from JSON
  factory ActiveStructureResponseDto.fromJson(Map<String, dynamic> json) {
    final levelsData = json['levels'] as List<dynamic>? ?? [];
    final levels = levelsData
        .whereType<Map<String, dynamic>>()
        .map((levelJson) => ActiveStructureLevelDto.fromJson(levelJson))
        .toList();

    return ActiveStructureResponseDto(
      structureId: (json['structure_id'] as String?) ??
          (json['structure_id'] as num?)?.toString() ??
          (json['structureId'] as String?) ??
          (json['structureId'] as num?)?.toString() ??
          '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ??
          (json['enterpriseId'] as num?)?.toInt() ??
          0,
      enterpriseName: json['enterprise_name'] as String? ??
          json['enterpriseName'] as String? ??
          '',
      structureCode: json['structure_code'] as String? ??
          json['structureCode'] as String? ??
          '',
      structureName: json['structure_name'] as String? ??
          json['structureName'] as String? ??
          '',
      structureType: json['structure_type'] as String? ??
          json['structureType'] as String? ??
          '',
      description: json['description'] as String?,
      isActive: json['is_active'] as String? ??
          json['isActive'] as String? ??
          'N',
      levels: levels,
    );
  }
}

