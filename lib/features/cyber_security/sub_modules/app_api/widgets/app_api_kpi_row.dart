import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AppApiKpiRow extends StatelessWidget {
  const AppApiKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 950;

        final cards = [
          const _AppKpiCard(
            title: 'API ENDPOINTS',
            value: '142',
            icon: Icons.language_rounded,
            accentColor: Color(0xFF00BCD4),
          ),
          const _AppKpiCard(
            title: 'OWASP FINDINGS',
            value: '23',
            icon: Icons.warning_amber_rounded,
            accentColor: Color(0xFFF97316),
          ),
          const _AppKpiCard(
            title: 'EXPOSED ENDPOINTS',
            value: '3',
            icon: Icons.error_outline_rounded,
            accentColor: Color(0xFFEF4444),
          ),
          const _AppKpiCard(
            title: 'SECRETS IN CODE',
            value: '7',
            icon: Icons.vpn_key_outlined,
            accentColor: Color(0xFFF59E0B),
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

class _AppKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  const _AppKpiCard({
    required this.title,
    required this.value,
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
          const Gap(10),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
