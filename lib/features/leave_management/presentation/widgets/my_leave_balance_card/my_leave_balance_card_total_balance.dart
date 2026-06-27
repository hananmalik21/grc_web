import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyLeaveBalanceCardTotalBalance extends StatelessWidget {
  final double totalBalance;
  final bool isDark;

  const MyLeaveBalanceCardTotalBalance({super.key, required this.totalBalance, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final secondaryTextStyle = context.textTheme.labelSmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? context.themeTextSecondary : AppColors.textSecondary,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total Balance', style: secondaryTextStyle, textAlign: TextAlign.center),
          Gap(4.h),
          Text(
            totalBalance.toString(),
            style: context.textTheme.displaySmall?.copyWith(
              fontSize: 31.sp,
              color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(4.h),
          Text('days available', style: secondaryTextStyle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
