import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/ai_governance/ai_governance_models.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/widgets/ai_governance_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/widgets/ai_security_controls_card.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/widgets/prompt_audit_log_table.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/widgets/recent_approval_queue_card.dart';

class AiGovernanceScreen extends StatefulWidget {
  const AiGovernanceScreen({super.key});

  @override
  State<AiGovernanceScreen> createState() => _AiGovernanceScreenState();
}

class _AiGovernanceScreenState extends State<AiGovernanceScreen> {
  final List<AiPromptLogItem> _logs = const [
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

  void _exportLogs() {
    ToastService.show(
      context: context,
      message: 'AI model activity and prompt audit logs exported to JSON.',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return CyberScreenLayout(
      title: 'AI Governance',
      subtitle: 'Model activity log, prompt audit, approval queue, and security controls',
      actions: [
        AppButton(
          label: 'Export Log',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: _exportLogs,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AiGovernanceKpiRow(),
          const Gap(20),
          if (isDesktop)
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AiSecurityControlsCard()),
                Gap(16),
                Expanded(child: RecentApprovalQueueCard()),
              ],
            )
          else
            const Column(
              children: [
                AiSecurityControlsCard(),
                Gap(16),
                RecentApprovalQueueCard(),
              ],
            ),
          const Gap(24),
          PromptAuditLogTable(logs: _logs),
        ],
      ),
    );
  }
}
