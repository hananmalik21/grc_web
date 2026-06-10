import 'package:dio/dio.dart';
import 'package:grc_web/features/assets/data/data_sources/assets_remote_data_source.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';

class AssetsRemoteDataSourceImpl implements AssetsRemoteDataSource {
  const AssetsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AssetsData> getAssets() async {
    _dio.options.headers;
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return const AssetsData(
      summary: AssetsSummary(
        totalAssets: 8,
        applications: 5,
        cloud: 0,
        data: 1,
        totalValue: r'$22.2M',
      ),
      assets: [
        AssetItem(
          id: 'AST-001',
          name: 'Customer Database',
          type: AssetType.data,
          businessValue: r'$4.50M',
          owner: 'John Smith',
          environment: 'Production',
          cloudProvider: 'AWS',
          riskLevel: AssetRiskLevel.critical,
          classification: AssetClassification.confidential,
          linkedRisks: ['R-001', 'R-003'],
          appliedControls: ['CTL-001', 'CTL-002', 'CTL-010'],
        ),
        AssetItem(
          id: 'AST-002',
          name: 'Payment Gateway API',
          type: AssetType.application,
          businessValue: r'$3.80M',
          owner: 'Sarah Johnson',
          environment: 'Production',
          cloudProvider: 'Azure',
          riskLevel: AssetRiskLevel.high,
          classification: AssetClassification.confidential,
        ),
        AssetItem(
          id: 'AST-003',
          name: 'ERP System',
          type: AssetType.application,
          businessValue: r'$3.20M',
          owner: 'Mike Chen',
          environment: 'Production',
          cloudProvider: 'On-Prem',
          riskLevel: AssetRiskLevel.high,
          classification: AssetClassification.internal,
        ),
        AssetItem(
          id: 'AST-004',
          name: 'AWS Production VPC',
          type: AssetType.infrastructure,
          businessValue: r'$2.80M',
          owner: 'DevOps Team',
          environment: 'Production',
          cloudProvider: 'AWS',
          riskLevel: AssetRiskLevel.medium,
          classification: AssetClassification.internal,
        ),
        AssetItem(
          id: 'AST-005',
          name: 'Analytics Platform',
          type: AssetType.application,
          businessValue: r'$2.40M',
          owner: 'Data Team',
          environment: 'Production',
          cloudProvider: 'GCP',
          riskLevel: AssetRiskLevel.medium,
          classification: AssetClassification.internal,
        ),
        AssetItem(
          id: 'AST-006',
          name: 'Auth Service',
          type: AssetType.application,
          businessValue: r'$2.10M',
          owner: 'Security Team',
          environment: 'Production',
          cloudProvider: 'AWS',
          riskLevel: AssetRiskLevel.high,
          classification: AssetClassification.confidential,
        ),
        AssetItem(
          id: 'AST-007',
          name: 'Vendor Management Portal',
          type: AssetType.application,
          businessValue: r'$1.90M',
          owner: 'Procurement',
          environment: 'Production',
          cloudProvider: 'Azure',
          riskLevel: AssetRiskLevel.medium,
          classification: AssetClassification.internal,
        ),
        AssetItem(
          id: 'AST-008',
          name: 'Log Aggregation',
          type: AssetType.infrastructure,
          businessValue: r'$1.50M',
          owner: 'DevOps Team',
          environment: 'Production',
          cloudProvider: 'AWS',
          riskLevel: AssetRiskLevel.low,
          classification: AssetClassification.internal,
        ),
      ],
    );
  }
}
