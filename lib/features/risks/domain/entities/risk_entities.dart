enum RiskStatus {
  assessed,
  treated,
  monitored,
  open,
}

enum RiskLikelihood {
  veryHigh,
  high,
  medium,
  low,
  veryLow,
}

enum RiskSeverity {
  critical,
  high,
  medium,
  low,
}

enum RiskTreatment {
  mitigate,
  transfer,
  accept,
  avoid,
}

class RiskLinkedAsset {
  const RiskLinkedAsset({required this.id, required this.name});

  final String id;
  final String name;
}

class RiskItem {
  const RiskItem({
    required this.id,
    required this.title,
    required this.assetCount,
    required this.category,
    required this.status,
    required this.likelihood,
    required this.impactValue,
    required this.inherentValue,
    required this.inherentSeverity,
    required this.residualValue,
    required this.residualSeverity,
    required this.treatment,
    required this.owner,
    this.controlEffectiveness = 70,
    this.linkedAssets = const [],
  });

  final String id;
  final String title;
  final int assetCount;
  final String category;
  final RiskStatus status;
  final RiskLikelihood likelihood;
  final String impactValue;
  final String inherentValue;
  final RiskSeverity inherentSeverity;
  final String residualValue;
  final RiskSeverity residualSeverity;
  final RiskTreatment treatment;
  final String owner;
  /// Control effectiveness as a percentage (0–100).
  final double controlEffectiveness;
  final List<RiskLinkedAsset> linkedAssets;
}

class RisksSummary {
  const RisksSummary({
    required this.inherentRiskVar,
    required this.residualRiskVar,
    required this.controlEffectiveness,
    required this.riskReduction,
  });

  final String inherentRiskVar;
  final String residualRiskVar;
  final String controlEffectiveness;
  final String riskReduction;
}

/// Heat map cell: count of risks in each likelihood × impact zone.
/// [row][col] where row 0=VeryHigh…4=VeryLow, col 0=Low…3=Critical.
typedef RiskHeatMap = List<List<int>>;

class RisksData {
  const RisksData({
    required this.summary,
    required this.risks,
    required this.heatMap,
  });

  final RisksSummary summary;
  final List<RiskItem> risks;
  final RiskHeatMap heatMap;
}
