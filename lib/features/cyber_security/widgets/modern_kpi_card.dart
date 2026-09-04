import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class ModernKpiCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? trend;
  final bool isPositiveTrend;

  const ModernKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  State<ModernKpiCard> createState() => _ModernKpiCardState();
}

class _ModernKpiCardState extends State<ModernKpiCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -2, 0))
            : Matrix4.identity(),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(24.r), // Soft large radius
          // No border for soft UI
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04), // Subtler flat shadow
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Icon Badge & Trend/Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: widget.iconColor.withValues(alpha: 0.22),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20.r,
                    color: widget.iconColor,
                  ),
                ),
              ],
            ),
            const Gap(8),

            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontSize: 11.sp, // Match subtitle size
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                Gap(4.h),
                Text(
                  widget.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                if (widget.trend != null) ...[
                  Gap(4.h),
                  Text(
                    widget.trend!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
