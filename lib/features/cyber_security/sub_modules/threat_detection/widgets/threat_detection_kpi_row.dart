import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';

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
        final isDesktop = constraints.maxWidth >= 950;

        final cards = [
          _ThreatKpiCard(
            label: 'NEW ALERTS',
            value: '$newAlertsCount',
            icon: Icons.sensors,
            iconColor: AppColors.teal,
          ),
          _ThreatKpiCard(
            label: 'INVESTIGATING',
            value: '$investigatingCount',
            icon: Icons.visibility_outlined,
            iconColor: AppColors.alertMedium,
          ),
          _ThreatKpiCard(
            label: 'CRITICAL TODAY',
            value: '$criticalTodayCount',
            subtitle: 'needs triage',
            icon: Icons.error_outline_rounded,
            iconColor: AppColors.cyberCritical,
          ),
          _ThreatKpiCard(
            label: 'DETECTION RULES',
            value: '$detectionRulesCount',
            subtitle: '218 active',
            icon: Icons.bolt_rounded,
            iconColor: AppColors.barPurple,
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
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textPlaceholderDark,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Gap(4),
              Icon(
                icon,
                size: 15.sp,
                color: iconColor,
              ),
            ],
          ),
          const Gap(6),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          if (subtitle != null) ...[
            const Gap(3),
            Text(
              subtitle!,
              style: TextStyle(
                color: AppColors.textPlaceholderDark,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
