import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 950;

        final cards = [
          _IdentityKpiCard(
            title: 'TOTAL USERS',
            value: '$totalUsers',
            subtitle: 'across all systems',
            icon: Icons.people_outline_rounded,
            accentColor: Color(0xFF00BCD4),
          ),
          _IdentityKpiCard(
            title: 'PRIVILEGED USERS',
            value: '$privilegedUsers',
            subtitle: 'Admin / elevated access',
            icon: Icons.vpn_key_outlined,
            accentColor: Color(0xFFF59E0B),
          ),
          _IdentityKpiCard(
            title: 'NO MFA',
            value: '$noMfa',
            subtitle: 'require immediate action',
            icon: Icons.warning_amber_rounded,
            accentColor: Color(0xFFEF4444),
          ),
          _IdentityKpiCard(
            title: 'HIGH-RISK USERS',
            value: '$highRiskUsers',
            subtitle: 'Risk score above 65',
            icon: Icons.info_outline_rounded,
            accentColor: Color(0xFFF97316),
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

        if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const Gap(10),
                  Expanded(child: cards[1]),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const Gap(10),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        }

        return Column(
          children: cards
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: c,
                ),
              )
              .toList(),
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
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF09101F),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF142036)),
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
                  color: const Color(0xFF5E738E),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, size: 15.sp, color: accentColor),
            ],
          ),
          const Gap(8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(4),
          Text(
            subtitle,
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
