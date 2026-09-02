import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/models/ai_governance_models.dart';
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
  final List<AiPromptLogItem> _logs = AiPromptLogItem.getMockPromptLogs();

  void _exportLogs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF131D31),
        content: Text(
          'AI model activity and prompt audit logs exported to JSON.',
          style: TextStyle(color: Color(0xFF00B4D8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop;
    final padding = ResponsiveHelper.getPagePadding(context);

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Governance',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          'Model activity log, prompt audit, approval queue, and security controls',
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: isMobile ? 11.sp : 12.sp,
          ),
        ),
      ],
    );

    final actionButton = InkWell(
      onTap: _exportLogs,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.file_download_outlined,
              size: 14.sp,
              color: const Color(0xFFCBD5E1),
            ),
            const Gap(6),
            Text(
              'Export Log',
              style: TextStyle(
                color: const Color(0xFFCBD5E1),
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    return SingleChildScrollView(
      padding: padding.copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          if (isMobile) ...[
            titleSection,
            const Gap(12),
            actionButton,
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: titleSection),
                actionButton,
              ],
            ),
          ],
          const Gap(20),

          // 4 Top KPI Cards
          const AiGovernanceKpiRow(),
          const Gap(20),

          // Middle 2-Column Grid (Security Controls + Recent Approval Queue)
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

          // Prompt Audit Log Table
          PromptAuditLogTable(logs: _logs),
        ],
      ),
    );
  }
}
