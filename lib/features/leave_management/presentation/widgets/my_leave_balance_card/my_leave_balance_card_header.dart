import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/leave_management/presentation/widgets/my_leave_balance_card/my_leave_balance_card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyLeaveBalanceCardHeader extends StatelessWidget {
  final MyLeaveBalanceCardData data;
  final bool isDark;

  const MyLeaveBalanceCardHeader({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [AppColors.primaryLight, AppColors.primary],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: data.iconPath, width: 18, height: 18, color: AppColors.cardBackground),
          ),
          Gap(11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.leaveType,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.cardBackground,
                  ),
                ),
                Text(
                  data.leaveTypeArabic,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.cardBackground.withValues(alpha: 0.8),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          if (data.isAtRisk) _AtRiskBadge(),
        ],
      ),
    );
  }
}

class _AtRiskBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DigifyCapsule(
      label: 'At Risk',
      iconPath: Assets.icons.leaveManagement.warning.path,
      backgroundColor: AppColors.cardBackground.withValues(alpha: 0.2),
      textColor: AppColors.cardBackground,
    );
  }
}
