import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class CloudPostureFilterDropdown extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CloudPostureFilterDropdown({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? const Color(0xFF333333) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(8.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.sp,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}
