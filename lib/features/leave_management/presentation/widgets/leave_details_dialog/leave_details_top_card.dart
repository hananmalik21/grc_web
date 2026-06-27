import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_dialog_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveDetailsTopCard extends StatelessWidget {
  const LeaveDetailsTopCard({super.key, required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.infoBg;
    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: leaveDetailsCardDecoration(isDark, color: cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
            ),
          ),
          Gap(4.h),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: 14.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
