import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum AssignmentType { department, employee }

class AssignmentTypeBadge extends StatelessWidget {
  final AssignmentType type;
  final String? customLabel;

  const AssignmentTypeBadge({super.key, required this.type, this.customLabel});

  String _getLabel() {
    if (customLabel != null) return customLabel!;
    switch (type) {
      case AssignmentType.department:
        return 'department';
      case AssignmentType.employee:
        return 'employee';
    }
  }

  String _getIconPath() {
    switch (type) {
      case AssignmentType.department:
        return Assets.icons.departmentIcon.path;
      case AssignmentType.employee:
        return Assets.icons.employeesIcon.path;
    }
  }

  Color _getBackgroundColor(bool isDark) {
    switch (type) {
      case AssignmentType.department:
        return isDark ? AppColors.successBgDark : AppColors.successBg;
      case AssignmentType.employee:
        return isDark ? AppColors.infoBgDark : AppColors.infoBg;
    }
  }

  Color _getTextColor(bool isDark) {
    switch (type) {
      case AssignmentType.department:
        return isDark ? AppColors.successTextDark : AppColors.successText;
      case AssignmentType.employee:
        return isDark ? AppColors.infoTextDark : AppColors.infoText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: _getBackgroundColor(isDark), borderRadius: BorderRadius.circular(4.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAsset(assetPath: _getIconPath(), width: 16, height: 16, color: _getTextColor(isDark)),
          Gap(8.w),
          Text(
            _getLabel(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: _getTextColor(isDark),
              height: 16 / 12,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
