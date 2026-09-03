import 'package:flutter/material.dart';

enum IncidentSeverity {
  critical,
  high,
  medium,
  low,
}

class OpenIncidentItemModel {
  final String id;
  final String incidentNumber;
  final String title;
  final IncidentSeverity severity;
  final String queryPrompt;

  const OpenIncidentItemModel({
    required this.id,
    required this.incidentNumber,
    required this.title,
    required this.severity,
    required this.queryPrompt,
  });

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

  static List<OpenIncidentItemModel> getMockOpenIncidents() {
    return const [
      OpenIncidentItemModel(
        id: 'inc-1',
        incidentNumber: 'INC-2847',
        title: 'Suspicious Login from Tor Exit Node',
        severity: IncidentSeverity.high,
        queryPrompt: 'Investigate INC-2847 suspicious login',
      ),
      OpenIncidentItemModel(
        id: 'inc-2',
        incidentNumber: 'INC-2846',
        title: 'Mass File Download — SharePoint Online',
        severity: IncidentSeverity.critical,
        queryPrompt: 'Investigate SharePoint data download',
      ),
      OpenIncidentItemModel(
        id: 'inc-3',
        incidentNumber: 'INC-2843',
        title: 'Privilege Escalation — IAM Role Modification',
        severity: IncidentSeverity.high,
        queryPrompt: 'Investigate INC-2843 IAM privilege escalation and unauthorized role binding',
      ),
      OpenIncidentItemModel(
        id: 'inc-4',
        incidentNumber: 'INC-2840',
        title: 'Unusual Database Query Volume Spike',
        severity: IncidentSeverity.medium,
        queryPrompt: 'Investigate INC-2840 unusual database query volume spike on RDS cluster',
      ),
    ];
  }
}
