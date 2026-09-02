import 'package:flutter/material.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/dashboard/cyber_dashboard_models.dart';
import 'package:grc/features/cyber_security/data/datasources/cyber_dashboard_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cyber_dashboard_dto.dart';

class CyberDashboardData {
  final List<CyberKpiModel> kpiCards;
  final List<double> findingSeverityValues;
  final List<Color> findingSeverityColors;
  final List<IncidentItem> recentIncidents;
  final double complianceScore;
  final int totalThreats;
  final int totalRisks;

  const CyberDashboardData({
    required this.kpiCards,
    required this.findingSeverityValues,
    required this.findingSeverityColors,
    required this.recentIncidents,
    required this.complianceScore,
    required this.totalThreats,
    required this.totalRisks,
  });
}

abstract class CyberDashboardRepository {
  Future<CyberDashboardData> getDashboardData();
}

class CyberDashboardRepositoryImpl implements CyberDashboardRepository {
  const CyberDashboardRepositoryImpl({required CyberDashboardRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final CyberDashboardRemoteDataSource _remoteDataSource;

  @override
  Future<CyberDashboardData> getDashboardData() async {
    final dto = await _remoteDataSource.getOverview();
    return _mapDtoToData(dto);
  }

  CyberDashboardData _mapDtoToData(CyberDashboardOverviewDto dto) {
    // 1. Map KPI Cards directly from backend response
    final openFindings = dto.risksSummary.totalOpen + dto.threatsSummary.totalOpen;
    final activeIncidents = dto.threatsSummary.critical + dto.threatsSummary.high;
    final postureScore = '${dto.complianceScore.round()}%';
    final cloudCount = dto.cloudCoverage.length;

    final kpiCards = [
      CyberKpiModel(
        title: 'OPEN FINDINGS',
        value: openFindings.toString(),
        subtitle: '${dto.risksSummary.critical + dto.threatsSummary.critical} critical need action',
        subtitleColor: AppColors.textPlaceholderDark,
        icon: Icons.warning_amber_rounded,
        accentColor: AppColors.cyberMedium,
      ),
      CyberKpiModel(
        title: 'ACTIVE INCIDENTS',
        value: activeIncidents.toString(),
        subtitle: '${dto.threatsSummary.high} high severity',
        subtitleColor: AppColors.textPlaceholderDark,
        icon: Icons.error_outline_rounded,
        accentColor: AppColors.cyberCritical,
      ),
      CyberKpiModel(
        title: 'POSTURE SCORE',
        value: postureScore,
        subtitle: dto.complianceScore > 0 ? '+2% from last month' : 'Needs baseline scan',
        subtitleColor: dto.complianceScore > 0 ? AppColors.cyberLiveGreen : AppColors.cyberMedium,
        icon: Icons.shield_outlined,
        accentColor: AppColors.cyberLiveGreen,
      ),
      CyberKpiModel(
        title: 'PROTECTED ASSETS',
        value: '${dto.cloudCoverage.length}',
        subtitle: 'Across $cloudCount connected cloud providers',
        subtitleColor: AppColors.textPlaceholderDark,
        icon: Icons.dns_outlined,
        accentColor: AppColors.cyberLow,
      ),
    ];

    // 2. Map Finding Severities (Critical, High, Medium, Low)
    final critical = (dto.risksSummary.critical + dto.threatsSummary.critical).toDouble();
    final high = (dto.risksSummary.high + dto.threatsSummary.high).toDouble();
    final medium = (dto.risksSummary.medium + dto.threatsSummary.medium).toDouble();
    final low = (dto.risksSummary.low + dto.threatsSummary.low).toDouble();

    final findingSeverityValues = [critical, high, medium, low];

    final findingSeverityColors = [
      AppColors.cyberCritical,
      AppColors.cyberHigh,
      AppColors.cyberMedium,
      AppColors.cyberLow,
    ];

    // 3. Map Recent Incidents / Detected Threats
    final recentIncidents = dto.recentThreats.map((threat) {
      Color sevColor = AppColors.cyberLow;
      if (threat.severity == 'CRITICAL') sevColor = AppColors.cyberCritical;
      if (threat.severity == 'HIGH') sevColor = AppColors.cyberHigh;
      if (threat.severity == 'MEDIUM') sevColor = AppColors.cyberMedium;

      Color statColor = AppColors.cyberMedium;
      if (threat.status == 'MITIGATED') statColor = AppColors.cyberLiveGreen;
      if (threat.status == 'OPEN') statColor = AppColors.cyberCritical;
      if (threat.status == 'INVESTIGATING') statColor = AppColors.cyberHigh;

      String dateStr = threat.occurredAt ?? '';
      if (dateStr.length > 16) {
        dateStr = dateStr.substring(5, 16).replaceAll('T', ' ');
      }

      return IncidentItem(
        severity: threat.severity,
        title: threat.title,
        incidentId: threat.id.length > 8 ? 'INC-${threat.id.substring(0, 8).toUpperCase()}' : threat.id,
        timestamp: dateStr.isNotEmpty ? dateStr : 'Recently',
        status: threat.status,
        severityColor: sevColor,
        statusColor: statColor,
      );
    }).toList();

    return CyberDashboardData(
      kpiCards: kpiCards,
      findingSeverityValues: findingSeverityValues,
      findingSeverityColors: findingSeverityColors,
      recentIncidents: recentIncidents,
      complianceScore: dto.complianceScore,
      totalThreats: dto.threatsSummary.totalOpen,
      totalRisks: dto.risksSummary.totalOpen,
    );
  }
}
