import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/models/copilot_message_model.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/ai_soc_copilot_header.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/copilot_input_bar.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/copilot_message_bubble.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/open_incidents_panel.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/quick_investigations_panel.dart';

class AiSocCopilotScreen extends StatefulWidget {
  const AiSocCopilotScreen({super.key});

  @override
  State<AiSocCopilotScreen> createState() => _AiSocCopilotScreenState();
}

class _AiSocCopilotScreenState extends State<AiSocCopilotScreen> {
  final ScrollController _scrollController = ScrollController();
  late List<CopilotMessage> _messages;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(CopilotMessage.getInitialMessages());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendQuery(String query) {
    if (query.trim().isEmpty || _isGenerating) return;

    final now = TimeOfDay.now();
    final minuteStr = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final timeString = '$hour:$minuteStr $period';

    // 1. Append user message
    setState(() {
      _messages.add(
        CopilotMessage(
          id: 'msg-user-${DateTime.now().millisecondsSinceEpoch}',
          sender: MessageSender.user,
          timestamp: timeString,
          content: query,
        ),
      );
      _isGenerating = true;
    });
    _scrollToBottom();

    // 2. Simulate AI SOC correlation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      final lower = query.toLowerCase();
      CopilotMessage response;

      if (lower.contains('s3') || lower.contains('f-2401')) {
        response = CopilotMessage(
          id: 'msg-ai-${DateTime.now().millisecondsSinceEpoch}',
          sender: MessageSender.copilot,
          timestamp: timeString,
          incidentId: 'FINDING-2401',
          content: 'Cloud Storage Exposure Analysis — F-2401 (S3 Bucket)',
          confidence: 'VERY HIGH',
          mitreMapping: 'MITRE ATT&CK T1530: Data from Cloud Storage',
          riskLevel: '🔴 CRITICAL — Public Object Read & Write Permission',
          riskColor: const Color(0xFFEF4444),
          evidence: [
            'Bucket Name: prod-analytics-backup-2026 (AWS us-east-1)',
            'Access Control: Principal "*" granted s3:GetObject, s3:PutObject in bucket policy',
            'Discovered Content: 1.2 TB of unmasked transactional database dumps',
            'Access Logs: 4 external unauthenticated GET requests detected from foreign IP ranges in past 2 hours',
          ],
          recommendedActions: [
            'Enable S3 Public Access Block at AWS Account and Bucket level',
            'Revoke overly permissive bucket policy and enforce IAM role authentication',
            'Rotate API credentials embedded in recent dump files',
            'Initiate digital forensics timeline on external IPs',
          ],
          source: 'AWS GuardDuty · Macie Data Classification · CloudTrail Access Log',
        );
      } else if (lower.contains('tor') || lower.contains('2847')) {
        response = CopilotMessage(
          id: 'msg-ai-${DateTime.now().millisecondsSinceEpoch}',
          sender: MessageSender.copilot,
          timestamp: timeString,
          incidentId: 'INC-2847',
          content: 'Tor Exit Node Correlation & Lateral Movement Analysis',
          confidence: 'HIGH',
          mitreMapping: 'MITRE ATT&CK T1078: Valid Accounts · T1090.003: Multi-hop Proxy',
          riskLevel: '🟠 HIGH — Authenticated Session from Known Tor Exit Node',
          riskColor: const Color(0xFFF97316),
          evidence: [
            'Source IP: 185.220.101.5 (Tor Exit Relay — Frankfurt, DE)',
            'Target Identity: svc-analytics-prod@digify.internal',
            'MFA Status: MFA challenged and approved via push notification',
            'Post-Auth Actions: 12 API calls to IAM DescribeRoles and KMS ListKeys in 30s',
          ],
          recommendedActions: [
            'Immediately revoke active OAuth refresh tokens and session for svc-analytics-prod',
            'Enforce Conditional Access policy blocking known Tor/Anonymizer exit IPs',
            'Rotate KMS master key KMS-KEY-9883',
            'Quarantine the originating EC2/lambda session',
          ],
          source: 'Okta System Log · AWS CloudTrail · CrowdStrike Threat Graph',
        );
      } else if (lower.contains('sharepoint') || lower.contains('2846')) {
        response = CopilotMessage(
          id: 'msg-ai-${DateTime.now().millisecondsSinceEpoch}',
          sender: MessageSender.copilot,
          timestamp: timeString,
          incidentId: 'INC-2846',
          content: 'Data Exfiltration Pattern — SharePoint Mass Download',
          confidence: 'MEDIUM-HIGH',
          mitreMapping: 'MITRE ATT&CK T1567: Exfiltration Over Web Service',
          riskLevel: '🟠 HIGH — 412 Confidential Documents Downloaded',
          riskColor: const Color(0xFFF97316),
          evidence: [
            'User: sarah.chen@company.com (Contractor, Finance Dept)',
            'Volume: 412 files (6.8 GB) downloaded in 14 minutes',
            'Normal Baseline: ~5-10 files/day',
            'File Tags: #restricted, #financial-q2, #payroll-2026',
          ],
          recommendedActions: [
            'Temporarily suspend SharePoint download privileges for account',
            'Notify HR & Legal Compliance officer for contractor audit',
            'Review DLP alerts on USB storage and web upload channels',
          ],
          source: 'Microsoft Purview Audit · Microsoft Defender for Cloud Apps',
        );
      } else {
        response = CopilotMessage(
          id: 'msg-ai-${DateTime.now().millisecondsSinceEpoch}',
          sender: MessageSender.copilot,
          timestamp: timeString,
          content: 'Autonomous Investigation Response',
          confidence: 'CONFIRMED',
          riskLevel: 'ℹ️ Telemetry Search Completed',
          riskColor: const Color(0xFF38BDF8),
          evidence: [
            'Query: "$query"',
            'Searched across: 14,820 Cloud Resources, 3,410 Identities, 42 VPCs, 890 Endpoints',
            'No critical zero-day indicators found matching this pattern in active memory',
          ],
          recommendedActions: [
            'Submit specific incident ID (e.g. INC-2847, INC-2846) for deep automated triage',
            'Configure custom alert rule for this query pattern',
          ],
          source: 'Cross-Domain Cyber SIEM · Unified Threat Graph · Cloud Trail',
        );
      }

      setState(() {
        _messages.add(response);
        _isGenerating = false;
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final padding = ResponsiveHelper.getPagePadding(context);

    return Padding(
      padding: padding.copyWith(bottom: 16.h),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Chat Section (Left / Center)
                Expanded(
                  flex: 7,
                  child: _buildChatColumn(),
                ),
                const Gap(20),
                // Right Side Pane (Quick Investigations & Open Incidents)
                SizedBox(
                  width: 290.w,
                  child: _buildRightSidePane(),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: _buildChatColumn(),
                ),
              ],
            ),
    );
  }

  Widget _buildChatColumn() {
    return Column(
      children: [
        // AI SOC Copilot Header Bar
        const AiSocCopilotHeader(),
        const Gap(12),

        // Chat Message List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return CopilotMessageBubble(
                message: _messages[index],
              );
            },
          ),
        ),
        const Gap(12),

        // Input Bar
        CopilotInputBar(
          onSend: _handleSendQuery,
          isGenerating: _isGenerating,
        ),
      ],
    );
  }

  Widget _buildRightSidePane() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Investigations
          QuickInvestigationsPanel(
            onSelectPrompt: _handleSendQuery,
          ),
          const Gap(20),

          // Open Incidents
          OpenIncidentsPanel(
            onSelectIncident: _handleSendQuery,
          ),
        ],
      ),
    );
  }
}
