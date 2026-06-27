import 'package:grc/features/workforce_structure/domain/models/workforce_stats.dart';

/// DTO for Workforce Statistics from API
class WorkforceStatsDto {
  final int totalPositions;
  final int totalJobLevels;
  final int totalJobFamilies;
  final int totalGrades;
  final PositionsStatsDto positionsStats;

  const WorkforceStatsDto({
    required this.totalPositions,
    required this.totalJobLevels,
    required this.totalJobFamilies,
    required this.totalGrades,
    required this.positionsStats,
  });

  factory WorkforceStatsDto.fromJson(Map<String, dynamic> json) {
    return WorkforceStatsDto(
      totalPositions: _asInt(json['total_positions']),
      totalJobLevels: _asInt(json['total_job_levels']),
      totalJobFamilies: _asInt(json['total_job_families']),
      totalGrades: _asInt(json['total_grades']),
      positionsStats: PositionsStatsDto.fromJson(json['positions_stats'] as Map<String, dynamic>),
    );
  }

  WorkforceStats toDomain() {
    return WorkforceStats(
      totalPositions: totalPositions,
      totalJobLevels: totalJobLevels,
      totalJobFamilies: totalJobFamilies,
      totalGrades: totalGrades,
      positionsStats: positionsStats.toDomain(),
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

/// DTO for Positions Statistics from API
class PositionsStatsDto {
  final int totalPositions;
  final int filledPositions;
  final int vacantPositions;
  final double fillRate;

  const PositionsStatsDto({
    required this.totalPositions,
    required this.filledPositions,
    required this.vacantPositions,
    required this.fillRate,
  });

  factory PositionsStatsDto.fromJson(Map<String, dynamic> json) {
    return PositionsStatsDto(
      totalPositions: _asInt(json['total_positions']),
      filledPositions: _asInt(json['filled_positions']),
      vacantPositions: _asInt(json['vacant_positions']),
      fillRate: _asDouble(json['fill_rate']),
    );
  }

  PositionsStats toDomain() {
    return PositionsStats(
      totalPositions: totalPositions,
      filledPositions: filledPositions,
      vacantPositions: vacantPositions,
      fillRate: fillRate,
    );
  }

  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  static double _asDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }
}
