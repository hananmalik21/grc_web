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

  static List<AiPromptLogItem> getMockPromptLogs() {
    return const [
      AiPromptLogItem(
        promptId: 'P-0892',
        user: 'priya.nair',
        actionQuery: 'Investigate alert ALT-4817',
        model: 'Claude Sonnet',
        timeAgo: '8 min ago',
      ),
      AiPromptLogItem(
        promptId: 'P-0891',
        user: 'ashley.wong',
        actionQuery: 'Generate IAM remediation playbook',
        model: 'Claude Sonnet',
        timeAgo: '22 min ago',
      ),
      AiPromptLogItem(
        promptId: 'P-0890',
        user: 'carlos.rodriguez',
        actionQuery: 'Draft executive incident report INC-2847',
        model: 'Claude Sonnet',
        timeAgo: '48 min ago',
      ),
      AiPromptLogItem(
        promptId: 'P-0889',
        user: 'priya.nair',
        actionQuery: 'Correlate logs for INC-2846',
        model: 'Claude Sonnet',
        timeAgo: '1.2 hr ago',
      ),
      AiPromptLogItem(
        promptId: 'P-0888',
        user: 'system',
        actionQuery: 'Auto-generate daily compliance summary',
        model: 'Claude Haiku',
        timeAgo: '3 hr ago',
      ),
      AiPromptLogItem(
        promptId: 'P-0887',
        user: 'jen.martinez',
        actionQuery: 'Query: which databases contain payroll data?',
        model: 'Claude Sonnet',
        timeAgo: '4 hr ago',
      ),
      AiPromptLogItem(
        promptId: 'P-0886',
        user: 'system',
        actionQuery: 'Risk score recalculation — 312 assets',
        model: 'Claude Haiku',
        timeAgo: '6 hr ago',
      ),
      AiPromptLogItem(
        promptId: 'P-0885',
        user: 'ashley.wong',
        actionQuery: 'Generate NIST CSF gap report',
        model: 'Claude Sonnet',
        timeAgo: '8 hr ago',
      ),
    ];
  }
}

class AiSecurityControl {
  final String name;
  final bool isPartial; // false = active (green), true = partial (amber)

  const AiSecurityControl({
    required this.name,
    this.isPartial = false,
  });

  String get statusLabel => isPartial ? 'partial' : 'active';
  Color get statusColor =>
      isPartial ? const Color(0xFFF59E0B) : const Color(0xFF10B981);

  static List<AiSecurityControl> getMockControls() {
    return const [
      AiSecurityControl(name: 'Prompt injection prevention'),
      AiSecurityControl(name: 'Output validation before action'),
      AiSecurityControl(name: 'Tenant data isolation'),
      AiSecurityControl(name: 'Sensitive data masking (PII, secrets)'),
      AiSecurityControl(name: 'Prompt + response audit logging'),
      AiSecurityControl(name: 'Human approval for prod actions'),
      AiSecurityControl(name: 'Model performance monitoring'),
      AiSecurityControl(name: 'Hallucination detection', isPartial: true),
    ];
  }
}

class AiApprovalItem {
  final String title;
  final String agent;
  final String timeAgo;
  final bool isApproved; // true = checkmark green, false = cross red

  const AiApprovalItem({
    required this.title,
    required this.agent,
    required this.timeAgo,
    this.isApproved = true,
  });

  static List<AiApprovalItem> getMockApprovals() {
    return const [
      AiApprovalItem(
        title: 'Disable account j.martinez',
        agent: 'AI SOC Copilot',
        timeAgo: '32 min ago',
        isApproved: true,
      ),
      AiApprovalItem(
        title: 'Block IP range 185.220.101.0/24',
        agent: 'AI SOC Copilot',
        timeAgo: '32 min ago',
        isApproved: true,
      ),
      AiApprovalItem(
        title: 'Create ticket for finding F-2401',
        agent: 'AI CSPM',
        timeAgo: '1 hr ago',
        isApproved: true,
      ),
      AiApprovalItem(
        title: 'Draft executive report INC-2847',
        agent: 'AI Reporting',
        timeAgo: '2 hr ago',
        isApproved: true,
      ),
      AiApprovalItem(
        title: 'Send customer breach notification',
        agent: 'AI GRC',
        timeAgo: '1 day ago',
        isApproved: false,
      ),
    ];
  }
}
