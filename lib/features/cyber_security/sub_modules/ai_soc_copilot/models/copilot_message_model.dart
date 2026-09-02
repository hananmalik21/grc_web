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
  final String? riskLevel; // e.g., 'CRITICAL', 'HIGH', 'MEDIUM'
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

  static List<CopilotMessage> getInitialMessages() {
    return [
      // 1. Initial Introduction Message
      const CopilotMessage(
        id: 'msg-intro-1',
        sender: MessageSender.copilot,
        isIntro: true,
        timestamp: 'now',
        content: "I'm your AI SOC Copilot. I correlate evidence across identity, cloud, network, application, and data layers to help you investigate faster.\n\nTry asking me about:\n• Suspicious login activity or brute force (e.g. \"INC-2847\")\n• Public cloud storage exposure (\"S3 bucket\" or \"F-2401\")\n• Privileged access and IAM risk\n• Compliance framework scores (\"NIST CSF\" or \"SOC 2\")\n• Malware incidents (\"INC-2842\")\n• Data exfiltration patterns (\"SharePoint download\")\n\nDescribe any security event and I'll correlate available evidence to assist your investigation.\n\n⚠ All containment actions require human approval before execution.",
      ),

      // 2. User prompt 1
      const CopilotMessage(
        id: 'msg-user-1',
        sender: MessageSender.user,
        timestamp: '11:01 PM',
        content: 'Investigate SharePoint data download',
      ),

      // 3. Copilot analysis response 1
      const CopilotMessage(
        id: 'msg-ai-1',
        sender: MessageSender.copilot,
        timestamp: '11:01 PM',
        incidentId: 'INC-2846',
        content: 'Data Exfiltration Investigation — INC-2846',
        status: 'Status: OPEN — Requires immediate action ⚠',
        riskLevel: '🔴 CRITICAL — Potential IP theft by departing employee',
        riskColor: Color(0xFFEF4444),
        evidence: [
          'User: a.thompson@corp.com (resignation accepted, last day 2026-06-30)',
          'Activity: 4.7 GB across 2,847 files downloaded in 23 minutes at 13:47 UTC',
          'File types: Excel (47%), PDF (31%), Word (22%) — strategic plans, HR data, finance models',
          'Device: Not enrolled in MDM — personal laptop, MAC not in inventory',
          'Location: Home IP 203.0.113.88 (consistent with user\'s home address)',
        ],
        recommendedActions: [
          'Suspend a.thompson access to all SaaS platforms',
          'Enable DLP policy to block personal cloud storage sync',
          'Place legal evidence hold on Microsoft 365 audit logs',
          'Notify HR and Legal immediately',
          'Assess whether downloaded files contain PII (GDPR 72hr notification)',
        ],
        source: 'Microsoft 365 audit log · DLP telemetry · MDM inventory · HR system',
      ),

      // 4. User prompt 2
      const CopilotMessage(
        id: 'msg-user-2',
        sender: MessageSender.user,
        timestamp: '11:01 PM',
        content: 'Investigate INC-2847 suspicious login',
      ),

      // 5. Copilot analysis response 2
      const CopilotMessage(
        id: 'msg-ai-2',
        sender: MessageSender.copilot,
        timestamp: '11:01 PM',
        incidentId: 'INC-2847',
        content: 'Threat Analysis — INC-2847: Suspicious Login',
        confidence: 'HIGH',
        mitreMapping: 'MITRE ATT&CK T1078',
        riskLevel: '🔴 HIGH',
        riskColor: Color(0xFFF97316),
        evidence: [
          '47 failed login attempts for j.martinez@corp.com (14:15–14:38 UTC)',
          'Source IP 185.220.101.47 — registered Tor exit node, flagged in 3 threat intel feeds',
          'Geographic anomaly: last successful login from Madrid; attempt from Frankfurt Tor node',
          'MFA status: DISABLED on this account ⚠',
          'Account privilege: Finance Analyst — access to AP, payroll, and GL systems',
        ],
        recommendedActions: [
          'Temporarily disable account j.martinez',
          'Block IP range 185.220.101.0/24 at perimeter WAF',
          'Force password reset via out-of-band notification',
          'Enable conditional access — require MFA for unrecognized locations',
          'Review recent access to finance systems for anomalies',
        ],
        source: 'Identity logs · IP reputation feed (ThreatFox, AbuseIPDB) · IAM database',
      ),
    ];
  }
}
