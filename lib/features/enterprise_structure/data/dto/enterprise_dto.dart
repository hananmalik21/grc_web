import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';

/// DTO for Enterprise
class EnterpriseDto {
  final int id;
  final String name;
  final String? code;
  final bool isActive;

  const EnterpriseDto({
    required this.id,
    required this.name,
    this.code,
    required this.isActive,
  });

  /// Creates DTO from JSON
  factory EnterpriseDto.fromJson(Map<String, dynamic> json) {
    // Handle different field name variations
    final enterpriseId = (json['enterprise_id'] as num?)?.toInt() ??
        (json['id'] as num?)?.toInt() ??
        (json['ENTERPRISE_ID'] as num?)?.toInt() ??
        0;

    final enterpriseName = json['enterprise_name'] as String? ??
        json['name'] as String? ??
        json['ENTERPRISE_NAME'] as String? ??
        '';

    final enterpriseCode = json['enterprise_code'] as String? ??
        json['code'] as String? ??
        json['ENTERPRISE_CODE'] as String?;

    // Handle is_active as "Y"/"N" or boolean
    final isActiveValue = json['is_active'] ??
        json['isActive'] ??
        json['IS_ACTIVE'] ??
        true;
    final isActive = isActiveValue is bool
        ? isActiveValue
        : (isActiveValue.toString().toUpperCase() == 'Y' ||
            isActiveValue.toString() == 'true');

    return EnterpriseDto(
      id: enterpriseId,
      name: enterpriseName,
      code: enterpriseCode,
      isActive: isActive,
    );
  }

  /// Converts DTO to domain model
  Enterprise toDomain() {
    return Enterprise(
      id: id,
      name: name,
      code: code,
      isActive: isActive,
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (code != null) 'code': code,
      'isActive': isActive,
    };
  }
}

