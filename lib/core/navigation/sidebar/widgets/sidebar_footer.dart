import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.sidebarSearchBg,
        border: Border(top: BorderSide(color: const Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Container(
            width: 35.r,
            height: 35.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF155DFC), Color(0xFF4F39F6)],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'A',
              style: TextStyle(color: Colors.white, fontSize: 12.3.sp, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 10.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(fontSize: 12.3.sp, fontWeight: FontWeight.w500, color: const Color(0xFF101828)),
                ),
                Text(
                  'System Administrator',
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.sidebarSecondaryText,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, size: 18.sp, color: const Color(0xFF6A7282)),
        ],
      ),
    );
  }
}
