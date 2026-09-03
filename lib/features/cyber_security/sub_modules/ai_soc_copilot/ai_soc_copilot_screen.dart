import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_soc_copilot/ai_soc_copilot_models.dart';
import 'package:grc/core/permissions/permission_gate.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/data/models/ai_copilot_dto.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/presentation/providers/ai_copilot_provider.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/ai_soc_copilot_header.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/copilot_input_bar.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/copilot_message_bubble.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/open_incidents_panel.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_soc_copilot/widgets/quick_investigations_panel.dart';

class AiSocCopilotScreen extends ConsumerStatefulWidget {
  const AiSocCopilotScreen({super.key});

  @override
  ConsumerState<AiSocCopilotScreen> createState() => _AiSocCopilotScreenState();
}

class _AiSocCopilotScreenState extends ConsumerState<AiSocCopilotScreen> {
  final ScrollController _scrollController = ScrollController();
  late List<CopilotMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      const CopilotMessage(
        id: 'msg-intro-1',
        sender: MessageSender.copilot,
        isIntro: true,
        timestamp: 'now',
        content:
            "I'm your AI SOC Copilot. I correlate evidence across identity, cloud, network, application, and data layers to help you investigate faster.\n\nTry asking me about:\n• Suspicious login activity or brute force (e.g. \"INC-2847\")\n• Public cloud storage exposure (\"S3 bucket\" or \"F-2401\")\n• Privileged access and IAM risk\n• Compliance framework scores (\"NIST CSF\" or \"SOC 2\")\n• Malware incidents (\"INC-2842\")\n• Data exfiltration patterns (\"SharePoint download\")\n\nDescribe any security event and I'll correlate available evidence to assist your investigation.\n\n⚠ All containment actions require human approval before execution.",
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
        source:
            'Microsoft 365 audit log · DLP telemetry · MDM inventory · HR system',
      ),
    ];
    _messages = [_messages.first];
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
    if (query.trim().isEmpty || ref.read(aiCopilotProvider).isSending) return;
    ref.read(aiCopilotProvider.notifier).sendMessage(query);
  }

  CopilotMessage _toCopilotMessage(AiMessageDto message) {
    final createdAt = message.createdAt?.toLocal();
    final timestamp = createdAt == null
        ? 'now'
        : '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
    return CopilotMessage(
      id: message.id,
      sender: message.role == 'USER'
          ? MessageSender.user
          : MessageSender.copilot,
      timestamp: timestamp,
      content: message.content,
      evidence: message.citations
          .map((citation) => '${citation.sourceType}: ${citation.sourceId}')
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authProvider);
    if (!PermissionService.instance.can(CyberPermKeys.aiCopilotQuery)) {
      return PermissionGate(
        permKey: CyberPermKeys.aiCopilotQuery,
        fallback: _buildPermissionDenied(),
        child: const SizedBox.shrink(),
      );
    }
    final copilotState = ref.watch(aiCopilotProvider);
    ref.listen<AiCopilotState>(aiCopilotProvider, (_, next) {
      if (!next.isSending) _scrollToBottom();
    });
    final messages = [
      ..._messages,
      ...copilotState.messages.map(_toCopilotMessage),
    ];

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
                Expanded(child: _buildChatColumn(messages, copilotState)),
                const Gap(20),
                SizedBox(width: 290.w, child: _buildRightSidePane()),
              ],
            )
          : Column(
              children: [
                Expanded(child: _buildChatColumn(messages, copilotState)),
              ],
            ),
    );
  }

  Widget _buildPermissionDenied() {
    return Container(
      color: AppColors.cyberDarkBg,
      alignment: Alignment.center,
      child: const Text(
        'You do not have permission to use AI SOC Copilot.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildChatColumn(
    List<CopilotMessage> messages,
    AiCopilotState copilotState,
  ) {
    return Column(
      children: [
        const AiSocCopilotHeader(),
        const Gap(12),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return CopilotMessageBubble(message: messages[index]);
            },
          ),
        ),
        const Gap(12),
        CopilotInputBar(
          onSend: _handleSendQuery,
          isGenerating: copilotState.isSending,
        ),
      ],
    );
  }

  Widget _buildRightSidePane() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuickInvestigationsPanel(onSelectPrompt: _handleSendQuery),
          const Gap(20),
          OpenIncidentsPanel(onSelectIncident: _handleSendQuery),
        ],
      ),
    );
  }
}
