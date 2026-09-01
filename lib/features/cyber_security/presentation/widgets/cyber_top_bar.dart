import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CyberTopBar extends StatelessWidget {
  final VoidCallback? onToggleSidebar;

  const CyberTopBar({super.key, this.onToggleSidebar});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF090E1A),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Row(
        children: [
          if (onToggleSidebar != null) ...[
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF94A3B8)),
              onPressed: onToggleSidebar,
              tooltip: 'Toggle Cyber Sidebar',
            ),
            const Gap(10),
          ],

          const Spacer(),

          // Search Field
          Container(
            width: 280.w,
            height: 34.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 15.sp,
                  color: const Color(0xFF64748B),
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Search assets, findings, policies...',
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Text(
                    '⌘K',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Gap(14),

          // Notification Bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF131D31),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 16.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const Gap(14),

          // User Profile
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Gap(8),
              Text(
                'priya.nair',
                style: TextStyle(
                  color: const Color(0xFFCBD5E1),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
