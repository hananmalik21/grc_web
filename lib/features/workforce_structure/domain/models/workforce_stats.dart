/// Workforce statistics domain model
class WorkforceStats {
  final int totalPositions;
  final int totalJobLevels;
  final int totalJobFamilies;
  final int totalGrades;
  final PositionsStats positionsStats;

  const WorkforceStats({
    required this.totalPositions,
    required this.totalJobLevels,
    required this.totalJobFamilies,
    required this.totalGrades,
    required this.positionsStats,
  });
}

/// Positions statistics domain model
class PositionsStats {
  final int totalPositions;
  final int filledPositions;
  final int vacantPositions;
  final double fillRate;

  const PositionsStats({
    required this.totalPositions,
    required this.filledPositions,
    required this.vacantPositions,
    required this.fillRate,
  });

  String get formattedTotalPositions {
    return totalPositions == 0 ? '---' : totalPositions.toString();
  }

  String get formattedFilledPositions {
    return filledPositions == 0 ? '---' : filledPositions.toString();
  }

  String get formattedVacantPositions {
    return vacantPositions == 0 ? '---' : vacantPositions.toString();
  }

  String get formattedFillRate {
    return fillRate == 0 ? '---' : '${fillRate.toStringAsFixed(1)}%';
  }
}
