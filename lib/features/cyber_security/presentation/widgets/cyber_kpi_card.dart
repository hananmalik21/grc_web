import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CyberKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData? icon;
  final Widget? trailingIcon;
  final Color? subtitleColor;
  final Color? accentColor;

  const CyberKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.icon,
    this.trailingIcon,
    this.subtitleColor,
    this.accentColor,
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
                title.toUpperCase(),
                style: TextStyle(
                  color: const Color(0xFF5E738E),
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              if (icon != null)
                Icon(icon, size: 15.sp, color: accentColor ?? const Color(0xFF94A3B8))
              else
                ?trailingIcon,
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
              color: subtitleColor ?? const Color(0xFF64748B),
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
