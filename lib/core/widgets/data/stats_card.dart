import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsCardData {
  final String label;
  final String value;
  final String iconPath;
  final Color iconColor;
  final Color iconBackground;

  const StatsCardData({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.iconColor,
    required this.iconBackground,
  });
}

class StatsCard extends StatelessWidget {
  final StatsCardData data;

  const StatsCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.themeCardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), offset: const Offset(0, 1), blurRadius: 3),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 15.1.sp,
                    fontWeight: FontWeight.w400,
                    color: context.themeTextSecondary,
                    height: 24 / 15.1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: context.themeTextPrimary,
                    height: 24 / 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(color: data.iconBackground, borderRadius: BorderRadius.circular(10.r)),
            child: Center(
              child: DigifyAsset(assetPath: data.iconPath, width: 24, height: 24, color: data.iconColor),
            ),
          ),
        ],
      ),
    );
  }
}
