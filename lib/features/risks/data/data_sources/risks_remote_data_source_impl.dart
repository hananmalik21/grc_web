import 'package:dio/dio.dart';
import 'package:grc_web/features/risks/data/data_sources/risks_remote_data_source.dart';
import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';

class RisksRemoteDataSourceImpl implements RisksRemoteDataSource {
  RisksRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<RisksData> getRisks() async {
    // Simulate network latency.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    // ignore: unused_local_variable
    final headers = _dio.options.headers;

    return const RisksData(
      summary: RisksSummary(
        inherentRiskVar: r'$76.8M',
        residualRiskVar: r'$18.0M',
        controlEffectiveness: '78%',
        riskReduction: '76.6%',
      ),
      // heat map: [row][col] row 0=VeryHigh…4=VeryLow, col 0=Low(1-4)…3=Critical(15-25)
      heatMap: [
        [0, 0, 2, 1], // Very High (5)
        [0, 0, 2, 0], // High (4)
        [0, 1, 2, 0], // Medium (3)
        [1, 1, 0, 0], // Low (2)
        [0, 0, 0, 0], // Very Low (1)
      ],
      risks: [
        RiskItem(
          id: 'R-001',
          title: 'Data Breach - Customer Database',
          assetCount: 1,
          category: 'Data Security',
          status: RiskStatus.assessed,
          likelihood: RiskLikelihood.veryHigh,
          impactValue: r'$4.50M',
          inherentValue: r'$22.50M',
          inherentSeverity: RiskSeverity.critical,
          residualValue: r'$5.63M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.mitigate,
          owner: 'CISO',
          controlEffectiveness: 75,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-001', name: 'Customer Database'),
          ],
        ),
        RiskItem(
          id: 'R-002',
          title: 'Payment System Downtime',
          assetCount: 1,
          category: 'Operational',
          status: RiskStatus.treated,
          likelihood: RiskLikelihood.high,
          impactValue: r'$3.20M',
          inherentValue: r'$12.80M',
          inherentSeverity: RiskSeverity.critical,
          residualValue: r'$2.56M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.mitigate,
          owner: 'VP Engineering',
          controlEffectiveness: 80,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-002', name: 'Payment Gateway'),
          ],
        ),
        RiskItem(
          id: 'R-003',
          title: 'Cloud Misconfiguration',
          assetCount: 1,
          category: 'Cloud Security',
          status: RiskStatus.monitored,
          likelihood: RiskLikelihood.high,
          impactValue: r'$2.80M',
          inherentValue: r'$11.20M',
          inherentSeverity: RiskSeverity.critical,
          residualValue: r'$3.36M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.mitigate,
          owner: 'Cloud Architect',
          controlEffectiveness: 70,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-003', name: 'Cloud Infrastructure'),
          ],
        ),
        RiskItem(
          id: 'R-004',
          title: 'Authentication Bypass',
          assetCount: 1,
          category: 'Access Control',
          status: RiskStatus.treated,
          likelihood: RiskLikelihood.medium,
          impactValue: r'$2.40M',
          inherentValue: r'$7.20M',
          inherentSeverity: RiskSeverity.critical,
          residualValue: r'$1.08M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.mitigate,
          owner: 'Security Team',
          controlEffectiveness: 85,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-004', name: 'Auth Service'),
          ],
        ),
        RiskItem(
          id: 'R-005',
          title: 'Third-Party Data Leak',
          assetCount: 1,
          category: 'Third-Party Risk',
          status: RiskStatus.treated,
          likelihood: RiskLikelihood.medium,
          impactValue: r'$1.90M',
          inherentValue: r'$5.70M',
          inherentSeverity: RiskSeverity.critical,
          residualValue: r'$2.00M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.transfer,
          owner: 'Vendor Manager',
          controlEffectiveness: 65,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-005', name: 'Vendor Portal'),
          ],
        ),
        RiskItem(
          id: 'R-006',
          title: 'Ransomware Attack',
          assetCount: 1,
          category: 'Cyber Security',
          status: RiskStatus.monitored,
          likelihood: RiskLikelihood.medium,
          impactValue: r'$3.20M',
          inherentValue: r'$9.60M',
          inherentSeverity: RiskSeverity.critical,
          residualValue: r'$2.11M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.mitigate,
          owner: 'IT Director',
          controlEffectiveness: 78,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-006', name: 'Endpoint Systems'),
          ],
        ),
        RiskItem(
          id: 'R-007',
          title: 'Data Loss - Analytics',
          assetCount: 1,
          category: 'Data Security',
          status: RiskStatus.treated,
          likelihood: RiskLikelihood.low,
          impactValue: r'$2.40M',
          inherentValue: r'$4.80M',
          inherentSeverity: RiskSeverity.high,
          residualValue: r'$0.86M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.accept,
          owner: 'Data Team Lead',
          controlEffectiveness: 82,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-007', name: 'Analytics Platform'),
          ],
        ),
        RiskItem(
          id: 'R-008',
          title: 'Log System Failure',
          assetCount: 1,
          category: 'Technology',
          status: RiskStatus.monitored,
          likelihood: RiskLikelihood.low,
          impactValue: r'$1.50M',
          inherentValue: r'$3.00M',
          inherentSeverity: RiskSeverity.high,
          residualValue: r'$0.36M',
          residualSeverity: RiskSeverity.medium,
          treatment: RiskTreatment.accept,
          owner: 'DevOps Lead',
          controlEffectiveness: 88,
          linkedAssets: [
            RiskLinkedAsset(id: 'AST-008', name: 'Logging Infrastructure'),
          ],
        ),
      ],
    );
  }
}

