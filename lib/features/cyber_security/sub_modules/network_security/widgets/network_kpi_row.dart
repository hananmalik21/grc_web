import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NetworkKpiRow extends StatelessWidget {
  const NetworkKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 950;

        final cards = [
          const _NetworkKpiCard(
            title: 'INTERNET-EXPOSED',
            value: '34',
            subtitle: 'assets with public IPs',
            icon: Icons.language_rounded,
            accentColor: Color(0xFFF97316),
          ),
          const _NetworkKpiCard(
            title: 'RISKY RULES',
            value: '6',
            subtitle: 'need remediation',
            icon: Icons.warning_amber_rounded,
            accentColor: Color(0xFFEF4444),
          ),
          const _NetworkKpiCard(
            title: 'VPCS / VNETS',
            value: '12',
            subtitle: 'across 3 platforms',
            icon: Icons.hub_outlined,
            accentColor: Color(0xFF00BCD4),
          ),
          const _NetworkKpiCard(
            title: 'WAF COVERAGE',
            value: '67%',
            subtitle: 'of public endpoints',
            icon: Icons.shield_outlined,
            accentColor: Color(0xFF10B981),
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
