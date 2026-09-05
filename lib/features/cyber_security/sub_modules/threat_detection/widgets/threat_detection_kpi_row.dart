import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';

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
        final width = constraints.maxWidth;

        final cards = [
          _buildKpiConfig(
            title: 'NEW ALERTS',
            value: '$newAlertsCount',
            icon: Icons.sensors,
            accentColor: AppColors.teal,
          ),
          _buildKpiConfig(
            title: 'INVESTIGATING',
            value: '$investigatingCount',
            icon: Icons.visibility_outlined,
            accentColor: AppColors.alertMedium,
          ),
          _buildKpiConfig(
            title: 'CRITICAL TODAY',
            value: '$criticalTodayCount',
            subtitle: 'needs triage',
            icon: Icons.error_outline_rounded,
            accentColor: AppColors.cyberCritical,
          ),
          _buildKpiConfig(
            title: 'DETECTION RULES',
            value: '$detectionRulesCount',
            subtitle: '218 active',
            icon: Icons.bolt_rounded,
            accentColor: AppColors.barPurple,
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
    String subtitle = 'Active monitoring',
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
