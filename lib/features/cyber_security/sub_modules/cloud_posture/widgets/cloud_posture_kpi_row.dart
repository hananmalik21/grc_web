import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';

class CloudPostureKpiRow extends StatelessWidget {
  const CloudPostureKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;

        final cards = [
          const _PostureKpiCard(
            title: 'CRITICAL',
            count: '4',
            subtitle: 'action required',
            icon: Icons.warning_amber_rounded,
            accentColor: AppColors.cyberCritical,
          ),
          const _PostureKpiCard(
            title: 'HIGH',
            count: '5',
            subtitle: 'within 15 days',
            icon: Icons.info_outline_rounded,
            accentColor: AppColors.cyberHigh,
          ),
          const _PostureKpiCard(
            title: 'MEDIUM',
            count: '6',
            subtitle: 'within 30 days',
            icon: Icons.info_outline_rounded,
            accentColor: AppColors.cyberMedium,
          ),
          const _PostureKpiCard(
            title: 'LOW',
            count: '5',
            subtitle: 'within 60 days',
            icon: Icons.check_circle_outline_rounded,
            accentColor: AppColors.cyberLow,
          ),
        ];

        if (isDesktop) {
          return Row(
            children: cards
                .map(
                  (card) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: card,
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

class _PostureKpiCard extends StatelessWidget {
  final String title;
  final String count;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _PostureKpiCard({
    required this.title,
    required this.count,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textTertiaryDark,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, size: 15.sp, color: accentColor),
            ],
          ),
          Gap(8.h),
          Text(
            count,
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(4.h),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textPlaceholderDark,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
