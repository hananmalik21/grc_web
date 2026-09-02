import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CloudPostureKpiRow extends StatelessWidget {
  const CloudPostureKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 950;

        final cards = [
          const _PostureKpiCard(
            title: 'CRITICAL',
            count: '4',
            subtitle: 'action required',
            icon: Icons.warning_amber_rounded,
            accentColor: Color(0xFFEF4444),
          ),
          const _PostureKpiCard(
            title: 'HIGH',
            count: '5',
            subtitle: 'within 15 days',
            icon: Icons.info_outline_rounded,
            accentColor: Color(0xFFF97316),
          ),
          const _PostureKpiCard(
            title: 'MEDIUM',
            count: '6',
            subtitle: 'within 30 days',
            icon: Icons.info_outline_rounded,
            accentColor: Color(0xFFFBBF24),
          ),
          const _PostureKpiCard(
            title: 'LOW',
            count: '5',
            subtitle: 'within 60 days',
            icon: Icons.check_circle_outline_rounded,
            accentColor: Color(0xFF38BDF8),
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
                (card) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: card,
                ),
              )
              .toList(),
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
            count,
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
