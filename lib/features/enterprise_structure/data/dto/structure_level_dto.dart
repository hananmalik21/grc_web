import 'package:grc/features/enterprise_structure/domain/models/structure_level.dart';

/// Data Transfer Object for Structure Level
/// Maps API response to domain model
class StructureLevelDto {
  final String id;
  final String name;
  final String icon;
  final int level;
  final bool isMandatory;
  final bool isActive;
  final String previewIcon;

  const StructureLevelDto({
    required this.id,
    required this.name,
    required this.icon,
    required this.level,
    required this.isMandatory,
    required this.isActive,
    required this.previewIcon,
  });

  /// Creates DTO from JSON
  /// Maps API response fields to DTO fields
  factory StructureLevelDto.fromJson(Map<String, dynamic> json) {
    // Extract level ID (use level_id from API or fallback to id)
    final levelId = (json['level_id'] as num?)?.toInt() ??
        (json['level'] as num?)?.toInt() ??
        (json['order'] as num?)?.toInt() ??
        0;

    // Extract level code (use level_code from API or fallback to id)
    final levelCode = (json['level_code'] as String?)?.toLowerCase() ??
        (json['id'] as String?)?.toLowerCase() ??
        (json['_id'] as String?)?.toLowerCase() ??
        '';

    // Extract level name
    final levelName = json['level_name'] as String? ??
        json['name'] as String? ??
        '';

    // Convert is_mandatory from "Y"/"N" to bool
    final isMandatoryValue = json['is_mandatory'] as String? ??
        json['isMandatory']?.toString() ??
        json['mandatory']?.toString() ??
        'N';
    final isMandatory = isMandatoryValue.toUpperCase() == 'Y' ||
        isMandatoryValue == 'true' ||
        (json['isMandatory'] as bool? ?? false);

    // Convert is_active from "Y"/"N" to bool
    final isActiveValue = json['is_active'] as String? ??
        json['isActive']?.toString() ??
        json['active']?.toString() ??
        'Y';
    final isActive = isActiveValue.toUpperCase() == 'Y' ||
        isActiveValue == 'true' ||
        (json['isActive'] as bool? ?? true);

    // Map icons based on level_code
    final icons = _getIconsForLevelCode(levelCode);

    return StructureLevelDto(
      // Use level_id as the id (needed for save API)
      id: levelId.toString(),
      name: levelName,
      icon: json['icon'] as String? ??
          json['iconPath'] as String? ??
          icons['icon']!,
      level: levelId,
      isMandatory: isMandatory,
      isActive: isActive,
      previewIcon: json['previewIcon'] as String? ??
          json['previewIconPath'] as String? ??
          icons['previewIcon']!,
    );
  }

  /// Maps level codes to icon paths
  static Map<String, String> _getIconsForLevelCode(String levelCode) {
    switch (levelCode.toLowerCase()) {
      case 'company':
      case 'comp':
        return {
          'icon': 'assets/icons/company_icon_small.svg',
          'previewIcon': 'assets/icons/company_icon_preview.svg',
        };
      case 'division':
      case 'div':
        return {
          'icon': 'assets/icons/division_icon_small.svg',
          'previewIcon': 'assets/icons/division_icon_preview.svg',
        };
      case 'business_unit':
      case 'businessunit':
      case 'bu':
        return {
          'icon': 'assets/icons/business_unit_icon_small.svg',
          'previewIcon': 'assets/icons/business_unit_icon_preview.svg',
        };
      case 'department':
      case 'dept':
        return {
          'icon': 'assets/icons/department_icon_small.svg',
          'previewIcon': 'assets/icons/department_icon_preview.svg',
        };
      case 'section':
      case 'sect':
        return {
          'icon': 'assets/icons/section_icon_small.svg',
          'previewIcon': 'assets/icons/section_icon_preview.svg',
        };
      default:
        return {
          'icon': 'assets/icons/company_icon_small.svg',
          'previewIcon': 'assets/icons/company_icon_preview.svg',
        };
    }
  }

  /// Converts DTO to domain model
  StructureLevel toDomain() {
    return StructureLevel(
      id: id,
      name: name,
      icon: icon,
      level: level,
      isMandatory: isMandatory,
      isActive: isActive,
      previewIcon: previewIcon,
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'level': level,
      'isMandatory': isMandatory,
      'isActive': isActive,
      'previewIcon': previewIcon,
    };
  }
}

