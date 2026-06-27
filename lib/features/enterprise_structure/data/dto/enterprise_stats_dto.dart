import 'package:grc/features/enterprise_structure/domain/models/enterprise_stats.dart';

class EnterpriseStatsDto {
  final int totalStructures;
  final int activeStructures;
  final int componentsInUse;
  final int employeesAssigned;

  const EnterpriseStatsDto({
    required this.totalStructures,
    required this.activeStructures,
    required this.componentsInUse,
    required this.employeesAssigned,
  });

  factory EnterpriseStatsDto.fromJson(Map<String, dynamic> json) {
    return EnterpriseStatsDto(
      totalStructures: _asInt(json['total_structures']),
      activeStructures: _asInt(json['active_structures']),
      componentsInUse: _asInt(json['components_in_use']),
      employeesAssigned: _asInt(json['employees_assigned']),
    );
  }

  EnterpriseStats toDomain() {
    return EnterpriseStats(
      totalStructures: totalStructures,
      activeStructures: activeStructures,
      componentsInUse: componentsInUse,
      employeesAssigned: employeesAssigned,
    );
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }
}
