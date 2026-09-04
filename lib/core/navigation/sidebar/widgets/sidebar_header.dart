import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarHeader extends ConsumerWidget {
  const SidebarHeader({super.key, required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: EdgeInsets.symmetric(horizontal: isExpanded ? 12.w : 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.cardBorder.withValues(alpha: 0.7))),
      ),
      child: isExpanded
          ? Row(
              children: [
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(9.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 17),
                ),
                Gap(8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'DIGIFY GRC',
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Text(
                        'ENTERPRISE SECURITY OS',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: const Icon(Icons.shield_outlined, color: Colors.white, size: 17),
              ),
            ),
    );
  }
}
