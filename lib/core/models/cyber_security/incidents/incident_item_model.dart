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
}
