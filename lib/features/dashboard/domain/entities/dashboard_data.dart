import 'package:grc_web/features/dashboard/domain/entities/stat_card_item.dart';

enum Likelihood { high, medium, low }
enum RiskStatus { critical, high, medium }
enum SummaryCardType { cloudWorkloads, activeControls, securityEvents }

class RiskAssetRow {
  const RiskAssetRow({
    required this.riskId,
    required this.asset,
    required this.impactVar,
    required this.likelihood,
    required this.status,
  });

  final String riskId;
  final String asset;
  final String impactVar;
  final Likelihood likelihood;
  final RiskStatus status;
}

class SummaryCardItem {
  const SummaryCardItem({
    required this.type,
    required this.value,
    required this.iconAsset,
  });

  final SummaryCardType type;
  final String value;
  final String iconAsset;
}

class DashboardData {
  const DashboardData({
    required this.stats,
    required this.topRiskAssets,
    required this.summaryCards,
  });

  final List<StatCardItem> stats;
  final List<RiskAssetRow> topRiskAssets;
  final List<SummaryCardItem> summaryCards;
}
