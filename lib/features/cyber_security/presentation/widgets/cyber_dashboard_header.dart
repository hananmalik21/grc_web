import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CyberDashboardHeader extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onExport;

  const CyberDashboardHeader({
    super.key,
    this.onRefresh,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;

        final titleSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Security Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: isNarrow ? 20.sp : 24.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const Gap(4),
            Text(
              'Real-time posture monitoring - 2026-06-28 16:41 UTC',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: isNarrow ? 11.sp : 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );

        final actionsSection = Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Live indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7.r,
                    height: 7.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF10B981),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const Gap(6),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: const Color(0xFF10B981),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            // Refresh Button
            _HeaderActionButton(
              icon: Icons.refresh_rounded,
              label: 'Refresh',
              onTap: onRefresh,
            ),
            // Export Button
            _HeaderActionButton(
              icon: Icons.download_rounded,
              label: 'Export',
              onTap: onExport,
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleSection,
              const Gap(12),
              actionsSection,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: titleSection),
            const Gap(16),
            actionsSection,
          ],
        );
      },
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _HeaderActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: const Color(0xFFCBD5E1)),
              const Gap(6),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFFCBD5E1),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
