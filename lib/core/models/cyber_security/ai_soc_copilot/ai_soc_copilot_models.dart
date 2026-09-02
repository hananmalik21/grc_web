import 'package:flutter/material.dart';

enum MessageSender {
  copilot,
  user,
}

class CopilotMessage {
  final String id;
  final MessageSender sender;
  final String content;
  final String timestamp;
  final String? incidentId;
  final String? status;
  final String? confidence;
  final String? mitreMapping;
  final String? riskLevel;
  final Color? riskColor;
  final List<String> evidence;
  final List<String> recommendedActions;
  final String? source;
  final bool isIntro;

  const CopilotMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.incidentId,
    this.status,
    this.confidence,
    this.mitreMapping,
    this.riskLevel,
    this.riskColor,
    this.evidence = const [],
    this.recommendedActions = const [],
    this.source,
    this.isIntro = false,
  });
}

class OpenIncidentItemModel {
  final String id;
  final String incidentNumber;
  final String title;
  final String severity;
  final Color severityColor;
  final String queryPrompt;

  const OpenIncidentItemModel({
    required this.id,
    required this.incidentNumber,
    required this.title,
    required this.severity,
    required this.severityColor,
    required this.queryPrompt,
  });
}

class QuickInvestigationModel {
  final String id;
  final String title;
  final String queryPrompt;

  const QuickInvestigationModel({
    required this.id,
    required this.title,
    required this.queryPrompt,
  });
}
