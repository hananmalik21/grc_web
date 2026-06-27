import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';

/// DTO for Organization Structure Level from API
class OrgStructureLevelDto {
  final int levelId;
  final String structureId;
  final int levelNumber;
  final String levelCode;
  final String levelName;
  final String isMandatory;
  final String isActive;
  final int displayOrder;
  final String createdBy;
  final String createdDate;
  final String lastUpdatedBy;
  final String lastUpdatedDate;
  final String? lastUpdateLogin;

  const OrgStructureLevelDto({
    required this.levelId,
    required this.structureId,
    required this.levelNumber,
    required this.levelCode,
    required this.levelName,
    required this.isMandatory,
    required this.isActive,
    required this.displayOrder,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    this.lastUpdateLogin,
  });

  factory OrgStructureLevelDto.fromJson(Map<String, dynamic> json) {
    return OrgStructureLevelDto(
      levelId: json['level_id'] as int,
      structureId: (json['structure_id'] as String?) ??
          (json['structure_id'] as num?)?.toString() ??
          '',
      levelNumber: json['level_number'] as int,
      levelCode: json['level_code'] as String,
      levelName: json['level_name'] as String,
      isMandatory: json['is_mandatory'] as String,
      isActive: json['is_active'] as String,
      displayOrder: json['display_order'] as int,
      createdBy: json['created_by'] as String,
      createdDate: json['created_date'] as String,
      lastUpdatedBy: json['last_updated_by'] as String,
      lastUpdatedDate: json['last_updated_date'] as String,
      lastUpdateLogin: json['last_update_login'] as String?,
    );
  }

  OrgStructureLevel toDomain() {
    return OrgStructureLevel(
      levelId: levelId,
      structureId: structureId,
      levelNumber: levelNumber,
      levelCode: levelCode,
      levelName: levelName,
      isMandatory: isMandatory == 'Y',
      isActive: isActive == 'Y',
      displayOrder: displayOrder,
    );
  }
}

/// DTO for Organization Structure from API
class OrgStructureDto {
  final String structureId;
  final int enterpriseId;
  final String enterpriseName;
  final String structureCode;
  final String structureName;
  final String structureType;
  final String? description;
  final String isActive;
  final String createdBy;
  final String createdDate;
  final String lastUpdatedBy;
  final String lastUpdatedDate;
  final String? lastUpdateLogin;
  final List<OrgStructureLevelDto> levels;

  const OrgStructureDto({
    required this.structureId,
    required this.enterpriseId,
    required this.enterpriseName,
    required this.structureCode,
    required this.structureName,
    required this.structureType,
    this.description,
    required this.isActive,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    this.lastUpdateLogin,
    required this.levels,
  });

  factory OrgStructureDto.fromJson(Map<String, dynamic> json) {
    return OrgStructureDto(
      structureId: (json['structure_id'] as String?) ??
          (json['structure_id'] as num?)?.toString() ??
          '',
      enterpriseId: json['enterprise_id'] as int,
      enterpriseName: json['enterprise_name'] as String,
      structureCode: json['structure_code'] as String,
      structureName: json['structure_name'] as String,
      structureType: json['structure_type'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as String,
      createdBy: json['created_by'] as String,
      createdDate: json['created_date'] as String,
      lastUpdatedBy: json['last_updated_by'] as String,
      lastUpdatedDate: json['last_updated_date'] as String,
      lastUpdateLogin: json['last_update_login'] as String?,
      levels: (json['levels'] as List<dynamic>)
          .map((e) => OrgStructureLevelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  OrgStructure toDomain() {
    return OrgStructure(
      structureId: structureId,
      enterpriseId: enterpriseId,
      enterpriseName: enterpriseName,
      structureCode: structureCode,
      structureName: structureName,
      structureType: structureType,
      description: description,
      isActive: isActive == 'Y',
      levels: levels.map((e) => e.toDomain()).toList(),
    );
  }
}
