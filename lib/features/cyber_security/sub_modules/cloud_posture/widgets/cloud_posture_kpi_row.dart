import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';

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
    final isDark = context.isDark;
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
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
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, size: 18.sp, color: accentColor),
            ],
          ),
          Gap(12.h),
          Text(
            count,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(6.h),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontSize: 11.sp,
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
