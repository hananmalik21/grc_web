enum StatCardType {
  totalRiskExposure,
  criticalRisks,
  controlEffectiveness,
  vendorRiskScore,
}

class StatCardItem {
  const StatCardItem({
    required this.type,
    required this.value,
    required this.trendLabel,
    required this.isTrendUp,
    required this.iconAsset,
  });

  final StatCardType type;
  final String value;
  final String trendLabel; // e.g. "-4.8%", "+2", "+3%"
  final bool isTrendUp;
  final String iconAsset; // local asset path for the icon (svg/png)
}
