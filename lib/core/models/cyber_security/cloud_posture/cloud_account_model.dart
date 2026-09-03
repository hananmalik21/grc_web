import 'package:flutter/material.dart';

enum CloudPlatform {
  aws('AWS', Color(0xFFFF9900)),
  gcp('GCP', Color(0xFF4285F4)),
  azure('Azure', Color(0xFF0078D4)),
  oci('OCI', Color(0xFFF04E23)),
  okta('OKTA', Color(0xFF007DC1));

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
}
