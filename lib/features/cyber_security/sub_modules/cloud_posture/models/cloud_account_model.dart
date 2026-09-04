import 'package:flutter/material.dart';

enum CloudPlatform {
  aws('AWS', Color(0xFFFF9900)),
  gcp('GCP', Color(0xFF4285F4)),
  azure('Azure', Color(0xFF0078D4));

  final String label;
  final Color color;
  const CloudPlatform(this.label, this.color);
}

class CloudAccountModel {
  final String name;
  final CloudPlatform platform;
  final String accountId;
  final String region;
  final String healthStatus;
  final Color healthColor;
  final int riskScore;
  final Color riskScoreColor;
  final int criticalCount;
  final int highCount;
  final int mediumCount;
  final int lowCount;
  final int totalResources;
  final String lastScan;

  const CloudAccountModel({
    required this.name,
    required this.platform,
    required this.accountId,
    required this.region,
    required this.healthStatus,
    required this.healthColor,
    required this.riskScore,
    required this.riskScoreColor,
    required this.criticalCount,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
    required this.totalResources,
    required this.lastScan,
  });

  static List<CloudAccountModel> getMockAccounts() => [
    const CloudAccountModel(
      name: 'AWS Production',
      platform: CloudPlatform.aws,
      accountId: '123456789012',
      region: 'us-east-1',
      healthStatus: 'healthy',
      healthColor: Color(0xFF10B981),
      riskScore: 89,
      riskScoreColor: Color(0xFFEF4444),
      criticalCount: 4,
      highCount: 5,
      mediumCount: 6,
      lowCount: 5,
      totalResources: 847,
      lastScan: '28 Jun 16:30',
    ),
    const CloudAccountModel(
      name: 'GCP Production',
      platform: CloudPlatform.gcp,
      accountId: 'cybershield-prod',
      region: 'us-central1',
      healthStatus: 'warning',
      healthColor: Color(0xFFF97316),
      riskScore: 72,
      riskScoreColor: Color(0xFFF97316),
      criticalCount: 0,
      highCount: 2,
      mediumCount: 3,
      lowCount: 2,
      totalResources: 312,
      lastScan: '28 Jun 16:28',
    ),
    const CloudAccountModel(
      name: 'Azure Production',
      platform: CloudPlatform.azure,
      accountId: 'a1b2c3d4-ef56-7890',
      region: 'eastus',
      healthStatus: 'warning',
      healthColor: Color(0xFFF97316),
      riskScore: 65,
      riskScoreColor: Color(0xFFF97316),
      criticalCount: 0,
      highCount: 2,
      mediumCount: 2,
      lowCount: 2,
      totalResources: 218,
      lastScan: '28 Jun 16:25',
    ),
    const CloudAccountModel(
      name: 'AWS Development',
      platform: CloudPlatform.aws,
      accountId: '987654321098',
      region: 'eu-west-1',
      healthStatus: 'healthy',
      healthColor: Color(0xFF10B981),
      riskScore: 42,
      riskScoreColor: Color(0xFFFBBF24),
      criticalCount: 0,
      highCount: 0,
      mediumCount: 3,
      lowCount: 3,
      totalResources: 156,
      lastScan: '28 Jun 16:20',
    ),
  ];
}
