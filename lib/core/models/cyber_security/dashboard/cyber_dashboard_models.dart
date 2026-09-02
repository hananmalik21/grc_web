import 'package:flutter/material.dart';

class CyberKpiModel {
  final String title;
  final String value;
  final String subtitle;
  final IconData? icon;
  final Color? subtitleColor;
  final Color? accentColor;

  const CyberKpiModel({
    required this.title,
    required this.value,
    required this.subtitle,
    this.icon,
    this.subtitleColor,
    this.accentColor,
  });
}

class IncidentItem {
  final String severity;
  final String title;
  final String incidentId;
  final String timestamp;
  final String status;
  final Color severityColor;
  final Color statusColor;

  const IncidentItem({
    required this.severity,
    required this.title,
    required this.incidentId,
    required this.timestamp,
    required this.status,
    required this.severityColor,
    required this.statusColor,
  });
}
