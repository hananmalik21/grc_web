enum AssetType {
  data,
  application,
  infrastructure,
  cloud,
}

enum AssetRiskLevel {
  critical,
  high,
  medium,
  low,
}

enum AssetClassification {
  confidential,
  internal,
}

class AssetItem {
  const AssetItem({
    required this.id,
    required this.name,
    required this.type,
    required this.businessValue,
    required this.owner,
    required this.environment,
    required this.cloudProvider,
    required this.riskLevel,
    required this.classification,
    this.linkedRisks = const [],
    this.appliedControls = const [],
  });

  final String id;
  final String name;
  final AssetType type;
  final String businessValue;
  final String owner;
  final String environment;
  final String cloudProvider;
  final AssetRiskLevel riskLevel;
  final AssetClassification classification;
  final List<String> linkedRisks;
  final List<String> appliedControls;
}

class AssetsSummary {
  const AssetsSummary({
    required this.totalAssets,
    required this.applications,
    required this.cloud,
    required this.data,
    required this.totalValue,
  });

  final int totalAssets;
  final int applications;
  final int cloud;
  final int data;
  final String totalValue;
}

class AssetsData {
  const AssetsData({
    required this.summary,
    required this.assets,
  });

  final AssetsSummary summary;
  final List<AssetItem> assets;
}
