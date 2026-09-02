import 'package:flutter/material.dart';

enum ThreatSeverity {
  critical,
  high,
  medium,
  low,
}

enum ThreatSource {
  identity,
  cloud,
  iam,
  data,
  network,
  appSec,
}

enum ThreatStatus {
  new_,
  investigating,
  closed,
}

class ThreatAlertModel {
  final String alertId;
  final String title;
  final ThreatSeverity severity;
  final ThreatSource source;
  final String timeAgo;
  final ThreatStatus status;
  final String mitreTechnique;
  final String description;
  final String affectedResource;

  const ThreatAlertModel({
    required this.alertId,
    required this.title,
    required this.severity,
    required this.source,
    required this.timeAgo,
    required this.status,
    this.mitreTechnique = 'T1078 (Valid Accounts)',
    this.description = 'Real-time telemetry flagged anomalous behavior matching threat detection heuristic rules.',
    this.affectedResource = 'prod-cluster-01',
  });

  String get severityLabel {
    switch (severity) {
      case ThreatSeverity.critical:
        return 'CRITICAL';
      case ThreatSeverity.high:
        return 'HIGH';
      case ThreatSeverity.medium:
        return 'MEDIUM';
      case ThreatSeverity.low:
        return 'LOW';
    }
  }

  Color get severityColor {
    switch (severity) {
      case ThreatSeverity.critical:
        return const Color(0xFFEF4444);
      case ThreatSeverity.high:
        return const Color(0xFFF97316);
      case ThreatSeverity.medium:
        return const Color(0xFFEAB308);
      case ThreatSeverity.low:
        return const Color(0xFF10B981);
    }
  }

  String get sourceLabel {
    switch (source) {
      case ThreatSource.identity:
        return 'Identity';
      case ThreatSource.cloud:
        return 'Cloud';
      case ThreatSource.iam:
        return 'IAM';
      case ThreatSource.data:
        return 'Data';
      case ThreatSource.network:
        return 'Network';
      case ThreatSource.appSec:
        return 'AppSec';
    }
  }

  String get statusLabel {
    switch (status) {
      case ThreatStatus.new_:
        return 'New';
      case ThreatStatus.investigating:
        return 'Investigating';
      case ThreatStatus.closed:
        return 'Closed';
    }
  }

  Color get statusDotColor {
    switch (status) {
      case ThreatStatus.new_:
        return const Color(0xFF00B4D8);
      case ThreatStatus.investigating:
        return const Color(0xFFF59E0B);
      case ThreatStatus.closed:
        return const Color(0xFF64748B);
    }
  }

  static List<ThreatAlertModel> getMockThreatAlerts() {
    return const [
      ThreatAlertModel(
        alertId: 'ALT-4821',
        title: 'Impossible Travel Detected',
        severity: ThreatSeverity.high,
        source: ThreatSource.identity,
        timeAgo: '8 min ago',
        status: ThreatStatus.new_,
        mitreTechnique: 'T1078 (Valid Accounts)',
        description: 'User logged in from Madrid and Frankfurt within 12 minutes.',
        affectedResource: 'j.martinez@corp.com',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4820',
        title: 'Sensitive S3 Bucket Accessed from External IP',
        severity: ThreatSeverity.critical,
        source: ThreatSource.cloud,
        timeAgo: '14 min ago',
        status: ThreatStatus.new_,
        mitreTechnique: 'T1530 (Data from Cloud Storage)',
        description: 'Unauthenticated GET request to S3 bucket containing financial dumps.',
        affectedResource: 'prod-analytics-backup-2026',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4819',
        title: 'Admin Account Created Outside Change Window',
        severity: ThreatSeverity.high,
        source: ThreatSource.iam,
        timeAgo: '31 min ago',
        status: ThreatStatus.investigating,
        mitreTechnique: 'T1098 (Account Manipulation)',
        description: 'New IAM admin role granted to service account outside business hours.',
        affectedResource: 'svc-cicd-runner',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4818',
        title: 'Database Query Volume Spike (3× Baseline)',
        severity: ThreatSeverity.medium,
        source: ThreatSource.data,
        timeAgo: '45 min ago',
        status: ThreatStatus.new_,
        mitreTechnique: 'T1005 (Data from Local System)',
        description: 'Postgres RDS instance received 300% query spike across customer tables.',
        affectedResource: 'rds-core-postgres-01',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4817',
        title: 'Outbound DNS Query to Known Malware Domain',
        severity: ThreatSeverity.critical,
        source: ThreatSource.network,
        timeAgo: '1 hr ago',
        status: ThreatStatus.investigating,
        mitreTechnique: 'T1071.004 (DNS Communication)',
        description: 'Container pod initiated egress DNS lookup to blacklisted C2 domain.',
        affectedResource: 'k8s-pod-billing-worker-7b',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4816',
        title: 'API Rate Limit Exceeded (500+ req/min)',
        severity: ThreatSeverity.medium,
        source: ThreatSource.appSec,
        timeAgo: '1.5 hr ago',
        status: ThreatStatus.new_,
        mitreTechnique: 'T1499 (Endpoint Denial of Service)',
        description: 'Public API gateway triggered rate limiting against external IP subnet.',
        affectedResource: 'api.cybershield.io/v1/auth',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4815',
        title: 'SSH Login from New Geographic Location',
        severity: ThreatSeverity.medium,
        source: ThreatSource.identity,
        timeAgo: '2 hr ago',
        status: ThreatStatus.closed,
        mitreTechnique: 'T1021.004 (SSH Remote Services)',
        description: 'Verified DevOps engineer logging into staging bastion host via VPN.',
        affectedResource: 'bastion-eu-west-1',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4814',
        title: 'CloudTrail Log Tampering Detected',
        severity: ThreatSeverity.critical,
        source: ThreatSource.cloud,
        timeAgo: '3 hr ago',
        status: ThreatStatus.investigating,
        mitreTechnique: 'T1562.008 (Disable Cloud Logs)',
        description: 'StopLogging call executed on CloudTrail trail in member AWS account.',
        affectedResource: 'arn:aws:cloudtrail:us-east-1:123456:trail/main',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4813',
        title: 'Lateral Movement — SMB Traffic on Port 445',
        severity: ThreatSeverity.high,
        source: ThreatSource.network,
        timeAgo: '4 hr ago',
        status: ThreatStatus.closed,
        mitreTechnique: 'T1021.002 (SMB/Windows Admin Shares)',
        description: 'Blocked SMB connection between staging VPC and production VPC.',
        affectedResource: 'vpc-staging-to-prod-peer',
      ),
      ThreatAlertModel(
        alertId: 'ALT-4812',
        title: 'Secrets Manager Access — Anomalous Lambda',
        severity: ThreatSeverity.medium,
        source: ThreatSource.cloud,
        timeAgo: '5 hr ago',
        status: ThreatStatus.new_,
        mitreTechnique: 'T1552 (Unsecured Credentials)',
        description: 'Lambda function retrieved database master credentials outside routine execution.',
        affectedResource: 'arn:aws:secretsmanager:db-master-creds',
      ),
    ];
  }
}
