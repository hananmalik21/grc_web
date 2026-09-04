import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class IdentityKpiRow extends StatelessWidget {
  const IdentityKpiRow({
    super.key,
    this.totalUsers = 0,
    this.privilegedUsers = 0,
    this.noMfa = 0,
    this.highRiskUsers = 0,
  });

  final int totalUsers;
  final int privilegedUsers;
  final int noMfa;
  final int highRiskUsers;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;

        final cards = [
          _IdentityKpiCard(
            title: 'TOTAL USERS',
            value: '$totalUsers',
            subtitle: 'across all systems',
            icon: Icons.people_outline_rounded,
            accentColor: AppColors.cyberLow,
          ),
          _IdentityKpiCard(
            title: 'PRIVILEGED USERS',
            value: '$privilegedUsers',
            subtitle: 'Admin / elevated access',
            icon: Icons.vpn_key_outlined,
            accentColor: AppColors.cyberMedium,
          ),
          _IdentityKpiCard(
            title: 'NO MFA',
            value: '$noMfa',
            subtitle: 'require immediate action',
            icon: Icons.warning_amber_rounded,
            accentColor: AppColors.cyberCritical,
          ),
          _IdentityKpiCard(
            title: 'HIGH-RISK USERS',
            value: '$highRiskUsers',
            subtitle: 'Risk score above 65',
            icon: Icons.info_outline_rounded,
            accentColor: AppColors.cyberHigh,
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

class _IdentityKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _IdentityKpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: EdgeInsets.all(14.r),
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
              Icon(icon, size: 15.sp, color: accentColor),
            ],
          ),
          Gap(8.h),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(4.h),
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
