import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CloudPostureTabBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const CloudPostureTabBar({
    super.key,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab(context, index: 0, label: 'Findings', badge: '20'),
          const Gap(24),
          _buildTab(context, index: 1, label: 'Cloud Accounts', badge: '4'),
          const Gap(24),
          _buildTab(context, index: 2, label: 'Compliance Mapping'),
          const Gap(24),
          _buildTab(context, index: 3, label: 'Scan History', badge: '7'),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, {required int index, required String label, String? badge}) {
    final isSelected = activeIndex == index;
    final isDark = context.isDark;

    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF00B4D8) : Colors.transparent,
              width: 2.2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                  ? (isDark ? Colors.white : const Color(0xFF0F172A)) 
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (badge != null) ...[
              const Gap(6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00B4D8).withValues(alpha: 0.2)
                      : (isDark ? const Color(0xFF2D2D2F) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF00B4D8)
                        : (isDark ? const Color(0xFF64748B) : const Color(0xFF64748B)),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
