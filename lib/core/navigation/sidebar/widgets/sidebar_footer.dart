import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Logout logic can be added here
          },
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: 20.sp,
                color: const Color(0xFFEF4444),
              ),
              SizedBox(width: 12.w),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
