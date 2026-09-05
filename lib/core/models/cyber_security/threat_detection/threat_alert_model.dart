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
}
