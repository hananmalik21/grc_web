import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
        final isNarrow = constraints.maxWidth < 800;

        if (isNarrow) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _AiKpiCard(
                      label: 'AI PROMPTS TODAY',
                      value: '$promptsToday',
                      subtitle: 'all reviewed',
                      icon: Icons.info_outline_rounded,
                      iconColor: const Color(0xFF2DD4BF),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _AiKpiCard(
                      label: 'HUMAN APPROVALS',
                      value: '$humanApprovals',
                      subtitle: 'pending: 0',
                      icon: Icons.verified_outlined,
                      iconColor: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: _AiKpiCard(
                      label: 'BLOCKED PROMPTS',
                      value: '$blockedPrompts',
                      subtitle: 'injection attempts',
                      icon: Icons.lock_outline_rounded,
                      iconColor: const Color(0xFFEF4444),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _AiKpiCard(
                      label: 'MODELS IN USE',
                      value: '$modelsInUse',
                      subtitle: 'Claude Sonnet/Haiku',
                      icon: Icons.psychology_outlined,
                      iconColor: const Color(0xFFA855F7),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _AiKpiCard(
                label: 'AI PROMPTS TODAY',
                value: '$promptsToday',
                subtitle: 'all reviewed',
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF2DD4BF),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _AiKpiCard(
                label: 'HUMAN APPROVALS',
                value: '$humanApprovals',
                subtitle: 'pending: 0',
                icon: Icons.verified_outlined,
                iconColor: const Color(0xFF10B981),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _AiKpiCard(
                label: 'BLOCKED PROMPTS',
                value: '$blockedPrompts',
                subtitle: 'injection attempts',
                icon: Icons.lock_outline_rounded,
                iconColor: const Color(0xFFEF4444),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _AiKpiCard(
                label: 'MODELS IN USE',
                value: '$modelsInUse',
                subtitle: 'Claude Sonnet/Haiku',
                icon: Icons.psychology_outlined,
                iconColor: const Color(0xFFA855F7),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AiKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _AiKpiCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 95.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              icon,
              size: 16.sp,
              color: iconColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const Gap(3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
