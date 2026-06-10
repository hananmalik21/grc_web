import 'package:dio/dio.dart';
import 'package:grc_web/features/dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:grc_web/features/dashboard/domain/entities/stat_card_item.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  const DashboardRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<DashboardData> getDashboardData() async {
    // Mocked dashboard data (replace with real API later).
    _dio.options.headers;
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency
    return DashboardData(
      stats: [
        const StatCardItem(
          type: StatCardType.totalRiskExposure,
          value: r'$16.4M',
          trendLabel: '-4.8%',
          isTrendUp: false,
          iconAsset: '',
        ),
        const StatCardItem(
          type: StatCardType.criticalRisks,
          value: '23',
          trendLabel: '+2',
          isTrendUp: true,
          iconAsset: '',
        ),
        const StatCardItem(
          type: StatCardType.controlEffectiveness,
          value: '87%',
          trendLabel: '+3%',
          isTrendUp: true,
          iconAsset: '',
        ),
        const StatCardItem(
          type: StatCardType.vendorRiskScore,
          value: '68/100',
          trendLabel: '+5',
          isTrendUp: true,
          iconAsset: '',
        ),
      ],
      topRiskAssets: const [
        RiskAssetRow(
          riskId: 'R-001',
          asset: 'Customer Database',
          impactVar: r'$4.50M',
          likelihood: Likelihood.high,
          status: RiskStatus.critical,
        ),
        RiskAssetRow(
          riskId: 'R-002',
          asset: 'Payment Gateway',
          impactVar: r'$3.20M',
          likelihood: Likelihood.medium,
          status: RiskStatus.high,
        ),
        RiskAssetRow(
          riskId: 'R-003',
          asset: 'AWS Production',
          impactVar: r'$2.80M',
          likelihood: Likelihood.medium,
          status: RiskStatus.high,
        ),
        RiskAssetRow(
          riskId: 'R-004',
          asset: 'Auth Service',
          impactVar: r'$2.40M',
          likelihood: Likelihood.low,
          status: RiskStatus.medium,
        ),
        RiskAssetRow(
          riskId: 'R-005',
          asset: 'Vendor Portal',
          impactVar: r'$1.90M',
          likelihood: Likelihood.medium,
          status: RiskStatus.medium,
        ),
      ],
      summaryCards: const [
        SummaryCardItem(
          type: SummaryCardType.cloudWorkloads,
          value: '342',
          iconAsset: 'assets/figma/dashboard/svg/summary_cloud_icon.svg',
        ),
        SummaryCardItem(
          type: SummaryCardType.activeControls,
          value: '156',
          iconAsset: 'assets/figma/dashboard/svg/security_icon.svg',
        ),
        SummaryCardItem(
          type: SummaryCardType.securityEvents,
          value: '1,234',
          iconAsset: 'assets/figma/dashboard/svg/sec_events_icon.svg',
        ),
      ],
    );
  }
}
