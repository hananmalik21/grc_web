import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CyberKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData? icon;
  final Widget? trailingIcon;
  final Color? subtitleColor;
  final Color? accentColor;
  final bool isSelected;
  final String? badgeValue;

  const CyberKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.icon,
    this.trailingIcon,
    this.subtitleColor,
    this.accentColor,
    this.isSelected = false,
    this.badgeValue,
  });

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dotColor = accentColor ?? skyBlue;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12.w : 16.w,
        vertical: isMobile ? 10.h : 14.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24.r), // Soft aesthetic
        // No borders!
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row: Colored Dot + Title + Badge Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(6.w),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155),
                          fontSize: isMobile ? 9.sp : 10.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(4.w),
              // Badge count pill on top-right
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 6.w : 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D2D2F) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  badgeValue ?? value,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: isMobile ? 10.sp : 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Gap(isMobile ? 6.h : 10.h),

          // Value
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: isMobile ? 16.sp : 18.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          Gap(2.h),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              color: subtitleColor ?? const Color(0xFF64748B),
              fontSize: isMobile ? 10.sp : 11.sp,
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
