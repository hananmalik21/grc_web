import 'package:flutter/material.dart';

class AiPromptLogItem {
  final String promptId;
  final String user;
  final String actionQuery;
  final String model;
  final String timeAgo;
  final String status;

  const AiPromptLogItem({
    required this.promptId,
    required this.user,
    required this.actionQuery,
    required this.model,
    required this.timeAgo,
    this.status = 'Logged',
  });
}

class AiSecurityControl {
  final String name;
  final bool isPartial;

  const AiSecurityControl({
    required this.name,
    this.isPartial = false,
  });

  String get statusLabel => isPartial ? 'partial' : 'active';
  Color get statusColor =>
      isPartial ? const Color(0xFFF59E0B) : const Color(0xFF10B981);
}

class AiApprovalItem {
  final String title;
  final String agent;
  final String timeAgo;
  final bool isApproved;

  const AiApprovalItem({
    required this.title,
    required this.agent,
    required this.timeAgo,
    this.isApproved = true,
  });
}
