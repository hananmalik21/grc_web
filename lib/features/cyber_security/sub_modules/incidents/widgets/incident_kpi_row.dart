import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/widgets/modern_kpi_card.dart';

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
    return ModernKpiCard(
      label: label,
      value: value,
      icon: icon,
      iconColor: iconColor,
    );
  }
}
