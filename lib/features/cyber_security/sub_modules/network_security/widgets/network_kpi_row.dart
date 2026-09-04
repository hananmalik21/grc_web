import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/widgets/modern_kpi_card.dart';

class NetworkKpiRow extends StatelessWidget {
  const NetworkKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;

        final cards = [
          const _NetworkKpiCard(
            title: 'INTERNET-EXPOSED',
            value: '34',
            subtitle: 'assets with public IPs',
            icon: Icons.language_rounded,
            accentColor: AppColors.cyberHigh,
          ),
          const _NetworkKpiCard(
            title: 'RISKY RULES',
            value: '6',
            subtitle: 'need remediation',
            icon: Icons.warning_amber_rounded,
            accentColor: AppColors.cyberCritical,
          ),
          const _NetworkKpiCard(
            title: 'VPCS / VNETS',
            value: '12',
            subtitle: 'across 3 platforms',
            icon: Icons.hub_outlined,
            accentColor: AppColors.cyberLow,
          ),
          const _NetworkKpiCard(
            title: 'WAF COVERAGE',
            value: '67%',
            subtitle: 'of public endpoints',
            icon: Icons.shield_outlined,
            accentColor: AppColors.cyberLiveGreen,
          ),
        ];

        if (isDesktop) {
          return Row(
            children: cards
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: c,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(child: cards[0]),
                Gap(10.w),
                Expanded(child: cards[1]),
              ],
            ),
            Gap(10.h),
            Row(
              children: [
                Expanded(child: cards[2]),
                Gap(10.w),
                Expanded(child: cards[3]),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _NetworkKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _NetworkKpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ModernKpiCard(
      label: title,
      value: value,
      icon: icon,
      iconColor: accentColor,
      trend: subtitle,
      isPositiveTrend: true,
    );
  }
}
