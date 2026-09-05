import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';

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
        final width = constraints.maxWidth;

        final cards = [
          _buildKpiConfig(
            title: 'OPEN',
            value: '$openCount',
            icon: Icons.error_outline_rounded,
            accentColor: const Color(0xFFEF4444),
          ),
          _buildKpiConfig(
            title: 'INVESTIGATING',
            value: '$investigatingCount',
            icon: Icons.visibility_outlined,
            accentColor: const Color(0xFFF59E0B),
          ),
          _buildKpiConfig(
            title: 'CONTAINED',
            value: '$containedCount',
            icon: Icons.shield_outlined,
            accentColor: const Color(0xFFF97316),
          ),
          _buildKpiConfig(
            title: 'RESOLVED',
            value: '$resolvedCount',
            icon: Icons.check_circle_outline_rounded,
            accentColor: const Color(0xFF10B981),
          ),
        ];

        return Wrap(
          spacing: 8.w,
          runSpacing: 10.h,
          children: List.generate(cards.length, (index) {
            final card = cards[index];
            // Calculate width: fit 4 on large screens, and exactly 2 on tablet/mobile screens.
            double cardWidth;
            if (width >= 1100) {
              cardWidth = (width - (3 * 8.w)) / 4;
            } else {
              cardWidth = (width - 8.w) / 2;
            }

            return SizedBox(
              width: cardWidth,
              child: CyberKpiCard(
                title: card.title,
                value: card.value,
                subtitle: card.subtitle,
                icon: card.icon,
                accentColor: card.accentColor,
                isSelected: false,
                badgeValue: card.value,
              ),
            );
          }),
        );
      },
    );
  }

  _KpiConfig _buildKpiConfig({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
    String subtitle = 'Queue status',
  }) {
    return _KpiConfig(
      title: title,
      value: value,
      icon: icon,
      accentColor: accentColor,
      subtitle: subtitle,
    );
  }
}

class _KpiConfig {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  _KpiConfig({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}
