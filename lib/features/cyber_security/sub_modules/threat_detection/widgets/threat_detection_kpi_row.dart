import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ThreatDetectionKpiRow extends StatelessWidget {
  final int newAlertsCount;
  final int investigatingCount;
  final int criticalTodayCount;
  final int detectionRulesCount;

  const ThreatDetectionKpiRow({
    super.key,
    this.newAlertsCount = 5,
    this.investigatingCount = 3,
    this.criticalTodayCount = 3,
    this.detectionRulesCount = 247,
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
                    child: _ThreatKpiCard(
                      label: 'NEW ALERTS',
                      value: '$newAlertsCount',
                      icon: Icons.sensors,
                      iconColor: const Color(0xFF2DD4BF),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _ThreatKpiCard(
                      label: 'INVESTIGATING',
                      value: '$investigatingCount',
                      icon: Icons.visibility_outlined,
                      iconColor: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: _ThreatKpiCard(
                      label: 'CRITICAL TODAY',
                      value: '$criticalTodayCount',
                      subtitle: 'needs triage',
                      icon: Icons.error_outline_rounded,
                      iconColor: const Color(0xFFEF4444),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _ThreatKpiCard(
                      label: 'DETECTION RULES',
                      value: '$detectionRulesCount',
                      subtitle: '218 active',
                      icon: Icons.bolt_rounded,
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
              child: _ThreatKpiCard(
                label: 'NEW ALERTS',
                value: '$newAlertsCount',
                icon: Icons.sensors,
                iconColor: const Color(0xFF2DD4BF),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _ThreatKpiCard(
                label: 'INVESTIGATING',
                value: '$investigatingCount',
                icon: Icons.visibility_outlined,
                iconColor: const Color(0xFFF59E0B),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _ThreatKpiCard(
                label: 'CRITICAL TODAY',
                value: '$criticalTodayCount',
                subtitle: 'needs triage',
                icon: Icons.error_outline_rounded,
                iconColor: const Color(0xFFEF4444),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _ThreatKpiCard(
                label: 'DETECTION RULES',
                value: '$detectionRulesCount',
                subtitle: '218 active',
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFFA855F7),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ThreatKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;

  const _ThreatKpiCard({
    required this.label,
    required this.value,
    this.subtitle,
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
          // Top-right Icon
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              icon,
              size: 17.sp,
              color: iconColor,
            ),
          ),

          // Content
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
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
                  if (subtitle != null) ...[
                    const Gap(8),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
