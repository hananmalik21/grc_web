import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IncidentKpiRow extends StatelessWidget {
  final int openCount;
  final int investigatingCount;
  final int containedCount;
  final int resolvedCount;

  const IncidentKpiRow({
    super.key,
    this.openCount = 2,
    this.investigatingCount = 2,
    this.containedCount = 1,
    this.resolvedCount = 3,
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
                    child: _IncidentKpiCard(
                      label: 'OPEN',
                      value: '$openCount',
                      icon: Icons.error_outline_rounded,
                      iconColor: const Color(0xFFEF4444),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _IncidentKpiCard(
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
                    child: _IncidentKpiCard(
                      label: 'CONTAINED',
                      value: '$containedCount',
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFFF97316),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _IncidentKpiCard(
                      label: 'RESOLVED',
                      value: '$resolvedCount',
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: const Color(0xFF10B981),
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
              child: _IncidentKpiCard(
                label: 'OPEN',
                value: '$openCount',
                icon: Icons.error_outline_rounded,
                iconColor: const Color(0xFFEF4444),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _IncidentKpiCard(
                label: 'INVESTIGATING',
                value: '$investigatingCount',
                icon: Icons.visibility_outlined,
                iconColor: const Color(0xFFF59E0B),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _IncidentKpiCard(
                label: 'CONTAINED',
                value: '$containedCount',
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFFF97316),
              ),
            ),
            const Gap(14),
            Expanded(
              child: _IncidentKpiCard(
                label: 'RESOLVED',
                value: '$resolvedCount',
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF10B981),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _IncidentKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _IncidentKpiCard({
    required this.label,
    required this.value,
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
            child: Icon(icon, size: 17.sp, color: iconColor),
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
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
