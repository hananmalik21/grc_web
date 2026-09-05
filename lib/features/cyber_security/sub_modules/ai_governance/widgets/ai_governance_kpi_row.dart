import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';

class AiGovernanceKpiRow extends StatelessWidget {
  final int promptsToday;
  final int humanApprovals;
  final int blockedPrompts;
  final int modelsInUse;

  const AiGovernanceKpiRow({
    super.key,
    this.promptsToday = 47,
    this.humanApprovals = 6,
    this.blockedPrompts = 2,
    this.modelsInUse = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600
            ? 2
            : constraints.maxWidth < 900
                ? 2
                : 4;
        final double spacing = 14.w;
        final double totalSpacing = spacing * (crossAxisCount - 1);
        final double cardWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: 14.h,
          children: [
            SizedBox(
              width: cardWidth,
              child: CyberKpiCard(
                title: 'AI PROMPTS TODAY',
                value: '$promptsToday',
                subtitle: 'all reviewed',
                icon: Icons.info_outline_rounded,
                accentColor: const Color(0xFF2DD4BF),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: CyberKpiCard(
                title: 'HUMAN APPROVALS',
                value: '$humanApprovals',
                subtitle: 'pending: 0',
                icon: Icons.verified_outlined,
                accentColor: const Color(0xFF10B981),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: CyberKpiCard(
                title: 'BLOCKED PROMPTS',
                value: '$blockedPrompts',
                subtitle: 'injection attempts',
                icon: Icons.lock_outline_rounded,
                accentColor: const Color(0xFFEF4444),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: CyberKpiCard(
                title: 'MODELS IN USE',
                value: '$modelsInUse',
                subtitle: 'Claude Sonnet/Haiku',
                icon: Icons.psychology_outlined,
                accentColor: const Color(0xFFA855F7),
              ),
            ),
          ],
        );
      },
    );
  }
}
