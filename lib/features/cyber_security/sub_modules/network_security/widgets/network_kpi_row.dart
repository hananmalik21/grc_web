import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';

class NetworkKpiRow extends StatelessWidget {
  const NetworkKpiRow({super.key});

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
              child: const CyberKpiCard(
                title: 'INTERNET-EXPOSED',
                value: '34',
                subtitle: 'assets with public IPs',
                accentColor: AppColors.cyberHigh,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: const CyberKpiCard(
                title: 'RISKY RULES',
                value: '6',
                subtitle: 'need remediation',
                accentColor: AppColors.cyberCritical,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: const CyberKpiCard(
                title: 'VPCS / VNETS',
                value: '12',
                subtitle: 'across 3 platforms',
                accentColor: AppColors.cyberLow,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: const CyberKpiCard(
                title: 'WAF COVERAGE',
                value: '67%',
                subtitle: 'of public endpoints',
                accentColor: AppColors.cyberLiveGreen,
              ),
            ),
          ],
        );
      },
    );
  }
}
