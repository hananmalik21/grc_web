import 'package:flutter/material.dart';

enum FindingSeverity {
  critical('CRITICAL', Color(0xFFEF4444)),
  high('HIGH', Color(0xFFF97316)),
  medium('MEDIUM', Color(0xFFFBBF24)),
  low('LOW', Color(0xFF38BDF8));

  final String label;
  final Color color;
  const FindingSeverity(this.label, this.color);
}

enum FindingStatus {
  open('Open', Color(0xFFEF4444)),
  remediating('Remediating', Color(0xFFA855F7)),
  resolved('Resolved', Color(0xFF10B981)),
  acknowledged('Acknowledged', Color(0xFF64748B));

  final String label;
  final Color color;
  const FindingStatus(this.label, this.color);
}

class FindingItemModel {
  final String id;
  final String resource;
  final String finding;
  final FindingSeverity severity;
  final String account;
  final String service;
  final int riskScore;
  final String age;
  final FindingStatus status;
  final String? resourceUri;
  final String? aiRiskExplanation;
  final List<String> remediationSteps;
  final Map<String, String> controlMappings;
  final List<SimilarFinding> similarFindings;

  const FindingItemModel({
    required this.id,
    required this.resource,
    required this.finding,
    required this.severity,
    required this.account,
    required this.service,
    required this.riskScore,
    required this.age,
    required this.status,
    this.resourceUri,
    this.aiRiskExplanation,
    this.remediationSteps = const [],
    this.controlMappings = const {},
    this.similarFindings = const [],
  });
}

class SimilarFinding {
  final String severity;
  final String id;
  final String title;
  final Color color;

  const SimilarFinding({
    required this.severity,
    required this.id,
    required this.title,
    required this.color,
  });
}
