import 'package:flutter/material.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/dashboard/cyber_dashboard_models.dart';

class CyberDashboardMockData {
  CyberDashboardMockData._();

  static const List<CyberKpiModel> kpiCards = [
    CyberKpiModel(
      title: 'OPEN FINDINGS',
      value: '312',
      subtitle: '4 critical need action',
      subtitleColor: AppColors.textPlaceholderDark,
      icon: Icons.warning_amber_rounded,
      accentColor: AppColors.cyberMedium,
    ),
    CyberKpiModel(
      title: 'ACTIVE INCIDENTS',
      value: '4',
      subtitle: '2 unassigned',
      subtitleColor: AppColors.textPlaceholderDark,
      icon: Icons.error_outline_rounded,
      accentColor: AppColors.cyberCritical,
    ),
    CyberKpiModel(
      title: 'POSTURE SCORE',
      value: '73%',
      subtitle: '+2% from last month',
      subtitleColor: AppColors.cyberLiveGreen,
      icon: Icons.shield_outlined,
      accentColor: AppColors.cyberLiveGreen,
    ),
    CyberKpiModel(
      title: 'PROTECTED ASSETS',
      value: '2,847',
      subtitle: 'Across 3 cloud platforms',
      subtitleColor: AppColors.textPlaceholderDark,
      icon: Icons.dns_outlined,
      accentColor: AppColors.cyberLow,
    ),
  ];

  static const List<String> alertVolumeXLabels = ['6/1', '6/6', '6/11', '6/16', '6/21', '6/26'];
  static const List<int> alertVolumeYLabels = [0, 30, 60, 90, 120];

  static const List<List<double>> alertVolumeSeriesData = [
    [42, 38, 68, 52, 106, 50],
    [24, 28, 40, 35, 68, 30],
    [14, 16, 22, 19, 38, 18],
    [4, 5, 8, 6, 16, 6],
  ];

  static const List<Color> alertVolumeSeriesColors = [
    AppColors.cyberLow,
    AppColors.cyberMedium,
    AppColors.cyberHigh,
    AppColors.cyberCritical,
  ];

  static const List<double> findingSeverityValues = [4, 14, 84, 210];
  static const List<Color> findingSeverityColors = [
    AppColors.cyberCritical,
    AppColors.cyberHigh,
    AppColors.cyberMedium,
    AppColors.cyberLow,
  ];

  static const List<IncidentItem> recentIncidents = [
    IncidentItem(
      severity: 'HIGH',
      title: 'Suspicious Login from Tor Exit Node',
      incidentId: 'INC-2847',
      timestamp: '28 Jun 14:23',
      status: 'Investigating',
      severityColor: AppColors.cyberHigh,
      statusColor: AppColors.cyberMedium,
    ),
    IncidentItem(
      severity: 'CRITICAL',
      title: 'Mass File Download — SharePoint Online',
      incidentId: 'INC-2846',
      timestamp: '28 Jun 13:51',
      status: 'Open',
      severityColor: AppColors.cyberCritical,
      statusColor: AppColors.cyberCritical,
    ),
    IncidentItem(
      severity: 'HIGH',
      title: 'Lateral Movement — Internal SSH Scanning',
      incidentId: 'INC-2845',
      timestamp: '27 Jun 22:14',
      status: 'Contained',
      severityColor: AppColors.cyberHigh,
      statusColor: AppColors.cyberHigh,
    ),
    IncidentItem(
      severity: 'CRITICAL',
      title: 'API Key Leaked in Public GitHub Repo',
      incidentId: 'INC-2844',
      timestamp: '27 Jun 09:33',
      status: 'Resolved',
      severityColor: AppColors.cyberCritical,
      statusColor: AppColors.cyberLiveGreen,
    ),
  ];
}
