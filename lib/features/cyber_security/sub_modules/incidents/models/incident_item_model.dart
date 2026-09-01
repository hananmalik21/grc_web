import 'package:flutter/material.dart';

enum IncidentSeverity {
  critical,
  high,
  medium,
  low,
}

enum IncidentStatus {
  open,
  investigating,
  contained,
  resolved,
  closed,
}

class IncidentItemModel {
  final String id;
  final String title;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final String owner;
  final String createdDate;
  final String mitreCode;
  final String description;
  final List<String> evidence;
  final List<String> containmentSteps;

  const IncidentItemModel({
    required this.id,
    required this.title,
    required this.severity,
    required this.status,
    required this.owner,
    required this.createdDate,
    required this.mitreCode,
    this.description = 'Security incident correlated by AI SOC telemetry.',
    this.evidence = const [],
    this.containmentSteps = const [],
  });

  String get severityLabel {
    switch (severity) {
      case IncidentSeverity.critical:
        return 'CRITICAL';
      case IncidentSeverity.high:
        return 'HIGH';
      case IncidentSeverity.medium:
        return 'MEDIUM';
      case IncidentSeverity.low:
        return 'LOW';
    }
  }

  Color get severityColor {
    switch (severity) {
      case IncidentSeverity.critical:
        return const Color(0xFFEF4444);
      case IncidentSeverity.high:
        return const Color(0xFFF97316);
      case IncidentSeverity.medium:
        return const Color(0xFFEAB308);
      case IncidentSeverity.low:
        return const Color(0xFF10B981);
    }
  }

  String get statusLabel {
    switch (status) {
      case IncidentStatus.open:
        return 'Open';
      case IncidentStatus.investigating:
        return 'Investigating';
      case IncidentStatus.contained:
        return 'Contained';
      case IncidentStatus.resolved:
        return 'Resolved';
      case IncidentStatus.closed:
        return 'Closed';
    }
  }

  Color get statusDotColor {
    switch (status) {
      case IncidentStatus.open:
        return const Color(0xFFEF4444);
      case IncidentStatus.investigating:
        return const Color(0xFFF59E0B);
      case IncidentStatus.contained:
        return const Color(0xFFF97316);
      case IncidentStatus.resolved:
        return const Color(0xFF10B981);
      case IncidentStatus.closed:
        return const Color(0xFF64748B);
    }
  }

  IncidentItemModel copyWith({
    String? id,
    String? title,
    IncidentSeverity? severity,
    IncidentStatus? status,
    String? owner,
    String? createdDate,
    String? mitreCode,
    String? description,
    List<String>? evidence,
    List<String>? containmentSteps,
  }) {
    return IncidentItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      owner: owner ?? this.owner,
      createdDate: createdDate ?? this.createdDate,
      mitreCode: mitreCode ?? this.mitreCode,
      description: description ?? this.description,
      evidence: evidence ?? this.evidence,
      containmentSteps: containmentSteps ?? this.containmentSteps,
    );
  }

  static List<IncidentItemModel> getMockIncidents() {
    return const [
      IncidentItemModel(
        id: 'INC-2847',
        title: 'Suspicious Login from Tor Exit Node',
        severity: IncidentSeverity.high,
        status: IncidentStatus.investigating,
        owner: 'P. Nair',
        createdDate: '28 Jun 14:23',
        mitreCode: 'T1078',
        description: '47 failed logins followed by successful auth from Frankfurt Tor node for Finance Analyst account.',
        evidence: [
          'User: j.martinez@corp.com',
          'Source IP: 185.220.101.47 (Tor Exit Node)',
          'MFA: Disabled on target account',
        ],
        containmentSteps: [
          'Temporarily disable account j.martinez',
          'Block IP 185.220.101.0/24 at perimeter WAF',
          'Force password reset with out-of-band notification',
        ],
      ),
      IncidentItemModel(
        id: 'INC-2846',
        title: 'Mass File Download — SharePoint Online',
        severity: IncidentSeverity.critical,
        status: IncidentStatus.open,
        owner: 'Unassigned',
        createdDate: '28 Jun 13:51',
        mitreCode: 'T1048',
        description: '4.7 GB downloaded across 2,847 files in 23 minutes by departing employee.',
        evidence: [
          'User: a.thompson@corp.com (Last day: 2026-06-30)',
          'Volume: 4.7 GB (Excel 47%, PDF 31%, Word 22%)',
          'Device: Unenrolled personal laptop',
        ],
        containmentSteps: [
          'Suspend SaaS account access',
          'Block personal cloud sync via DLP policy',
          'Apply legal hold on M365 logs',
        ],
      ),
      IncidentItemModel(
        id: 'INC-2845',
        title: 'Lateral Movement — Internal SSH Scanning',
        severity: IncidentSeverity.high,
        status: IncidentStatus.contained,
        owner: 'A. Wong',
        createdDate: '27 Jun 22:14',
        mitreCode: 'T1021',
        description: 'Compromised staging container attempted rapid SSH sweeps across internal RFC 1918 subnets.',
        evidence: [
          'Host: k8s-node-staging-04',
          'Port Scanned: TCP 22, 445',
          'Firewall: Microsegmentation rules dropped 98% of packets',
        ],
        containmentSteps: [
          'Isolated staging pod and killed malicious container instance',
          'Rotated cluster node service credentials',
        ],
      ),
      IncidentItemModel(
        id: 'INC-2844',
        title: 'API Key Leaked in Public GitHub Repo',
        severity: IncidentSeverity.critical,
        status: IncidentStatus.resolved,
        owner: 'C. Rodriguez',
        createdDate: '27 Jun 09:33',
        mitreCode: 'T1552',
        description: 'AWS secret key committed in public open-source repository by contractor.',
        evidence: [
          'Repository: github.com/external-dev/frontend-demo',
          'Detected in: 4 minutes via secret scanner',
        ],
        containmentSteps: [
          'AWS IAM access key automatically invalidated and rotated',
          'CloudTrail confirmed zero unauthorized API calls executed',
        ],
      ),
      IncidentItemModel(
        id: 'INC-2843',
        title: 'Privilege Escalation — IAM Role Modification',
        severity: IncidentSeverity.high,
        status: IncidentStatus.open,
        owner: 'Unassigned',
        createdDate: '26 Jun 18:07',
        mitreCode: 'T1548',
        description: 'Service account granted roles/owner without an approved change management request.',
        evidence: [
          'Principal: svc-cicd-runner@grc-cloud.iam',
          'Role: roles/owner (Project Level)',
          'Change Window: Outside standard deployment schedule',
        ],
        containmentSteps: [
          'Revoke roles/owner binding',
          'Audit session activity from service account',
        ],
      ),
      IncidentItemModel(
        id: 'INC-2842',
        title: 'Malware Detected — Endpoint EP-WKS-047',
        severity: IncidentSeverity.critical,
        status: IncidentStatus.resolved,
        owner: 'P. Nair',
        createdDate: '25 Jun 11:22',
        mitreCode: 'T1059',
        description: 'Ransomware executable blocked and quarantined by endpoint detection agent.',
        evidence: [
          'Host: DESKTOP-ENG-4491',
          'Hash: sha256:4b9a102...',
          'Block Time: 120ms',
        ],
        containmentSteps: [
          'Host isolated and re-imaged with clean golden image',
        ],
      ),
      IncidentItemModel(
        id: 'INC-2841',
        title: 'Brute-Force Attack — VPN Gateway',
        severity: IncidentSeverity.medium,
        status: IncidentStatus.closed,
        owner: 'A. Wong',
        createdDate: '24 Jun 08:45',
        mitreCode: 'T1110',
        description: 'Distributed brute-force attempt against external VPN endpoint blocked by rate limiting.',
        evidence: [
          'Gateway: vpn.corp.internal',
          'IP Blocked: 1,420 IPs added to temporary perimeter blacklist',
        ],
        containmentSteps: [
          'Rate limiting rule updated to lower failed attempt threshold',
        ],
      ),
      IncidentItemModel(
        id: 'INC-2840',
        title: 'Unusual Database Query Volume Spike',
        severity: IncidentSeverity.medium,
        status: IncidentStatus.investigating,
        owner: 'P. Nair',
        createdDate: '28 Jun 10:15',
        mitreCode: 'T1530',
        description: '300% query surge detected on production RDS PostgreSQL instance.',
        evidence: [
          'Database: rds-core-postgres-01',
          'Query: SELECT * FROM customer_transactions',
        ],
        containmentSteps: [
          'Analyzing application query caller logs and throttling read replicas',
        ],
      ),
    ];
  }
}
