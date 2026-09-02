import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_soc_copilot/ai_soc_copilot_models.dart';
import 'package:grc/core/services/responsive_service.dart';
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
    _messages = [
      const CopilotMessage(
        id: 'msg-intro-1',
        sender: MessageSender.copilot,
        isIntro: true,
        timestamp: 'now',
        content: "I'm your AI SOC Copilot. I correlate evidence across identity, cloud, network, application, and data layers to help you investigate faster.\n\nTry asking me about:\n• Suspicious login activity or brute force (e.g. \"INC-2847\")\n• Public cloud storage exposure (\"S3 bucket\" or \"F-2401\")\n• Privileged access and IAM risk\n• Compliance framework scores (\"NIST CSF\" or \"SOC 2\")\n• Malware incidents (\"INC-2842\")\n• Data exfiltration patterns (\"SharePoint download\")\n\nDescribe any security event and I'll correlate available evidence to assist your investigation.\n\n⚠ All containment actions require human approval before execution.",
      ),
      const CopilotMessage(
        id: 'msg-user-1',
        sender: MessageSender.user,
        timestamp: '11:01 PM',
        content: 'Investigate SharePoint data download',
      ),
      const CopilotMessage(
        id: 'msg-ai-1',
        sender: MessageSender.copilot,
        timestamp: '11:01 PM',
        incidentId: 'INC-2846',
        content: 'Data Exfiltration Investigation — INC-2846',
        status: 'Status: OPEN — Requires immediate action ⚠',
        riskLevel: '🔴 CRITICAL — Potential IP theft by departing employee',
        riskColor: AppColors.cyberCritical,
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
    ];
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
          riskColor: AppColors.cyberCritical,
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
          riskColor: AppColors.cyberHigh,
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
      } else {
        response = CopilotMessage(
          id: 'msg-ai-${DateTime.now().millisecondsSinceEpoch}',
          sender: MessageSender.copilot,
          timestamp: timeString,
          content: 'Security Telemetry Correlation Report',
          confidence: 'CONFIRMED',
          mitreMapping: 'MITRE ATT&CK Enterprise Matrix',
          riskLevel: '🔵 MEDIUM — Contextual Analysis Available',
          riskColor: AppColors.primaryLight,
          evidence: [
            'Cross-layer security telemetry analyzed for: "$query"',
            'Correlated 14 cloud telemetry logs, 3 active identity sessions, and 2 firewall rule sets',
            'All critical perimeter boundaries remain actively defended',
          ],
          recommendedActions: [
            'Review corresponding sub-module findings for remediation details',
            'Run automated posture scan to update threat baseline',
          ],
          source: 'Unified SIEM & AI Security Graph',
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

    return Container(
      color: AppColors.cyberDarkBg,
      height: MediaQuery.of(context).size.height - 70.h,
      padding: padding.copyWith(bottom: 16.h),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildChatColumn(),
                ),
                const Gap(20),
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
        const AiSocCopilotHeader(),
        const Gap(12),
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
          QuickInvestigationsPanel(
            onSelectPrompt: _handleSendQuery,
          ),
          const Gap(20),
          OpenIncidentsPanel(
            onSelectIncident: _handleSendQuery,
          ),
        ],
      ),
    );
  }
}
