import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String? iconPath;
  final Color backgroundColor;
  final Color foregroundColor;
  final double? width;

  const ActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.iconPath,
    required this.backgroundColor,
    required this.foregroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(4.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (iconPath != null) ...[
                DigifyAsset(assetPath: iconPath!, width: 16, height: 16, color: foregroundColor),
                SizedBox(width: 8.w),
              ],
              Text(
                label,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: foregroundColor, height: 24 / 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
