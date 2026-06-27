import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalanceBadge extends StatelessWidget {
  final String text;
  final LeaveBadgeType type;

  const LeaveBalanceBadge({super.key, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final colors = _getColors(type, isDark);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: colors.backgroundColor, borderRadius: BorderRadius.circular(100.r)),
      child: Text(text, style: context.textTheme.labelMedium?.copyWith(color: colors.textColor)),
    );
  }

  _BadgeColors _getColors(LeaveBadgeType type, bool isDark) {
    switch (type) {
      case LeaveBadgeType.annualLeave:
      case LeaveBadgeType.sickLeave:
        return _BadgeColors(
          backgroundColor: isDark ? AppColors.successBgDark : AppColors.shiftActiveStatusBg,
          textColor: isDark ? AppColors.successTextDark : AppColors.activeStatusTextLight,
        );
      case LeaveBadgeType.unpaidLeave:
        return _BadgeColors(
          backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
          textColor: isDark ? AppColors.grayTextDark : AppColors.textPrimary,
        );
      case LeaveBadgeType.totalAvailable:
        return _BadgeColors(
          backgroundColor: isDark ? AppColors.leaveTotalAvailableBgDark : AppColors.leaveTotalAvailableBg,
          textColor: isDark ? AppColors.leaveTotalAvailableTextDark : AppColors.leaveTotalAvailableText,
        );
    }
  }
}

enum LeaveBadgeType { annualLeave, sickLeave, unpaidLeave, totalAvailable }

class _BadgeColors {
  final Color backgroundColor;
  final Color textColor;

  _BadgeColors({required this.backgroundColor, required this.textColor});
}
