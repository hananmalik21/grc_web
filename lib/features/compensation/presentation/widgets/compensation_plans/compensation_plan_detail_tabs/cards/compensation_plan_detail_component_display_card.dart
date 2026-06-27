import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanDetailComponentDisplayCard extends StatelessWidget {
  final String name;
  final String code;
  final String type;
  final String category;
  final String status;
  final String description;

  const CompensationPlanDetailComponentDisplayCard({
    super.key,
    required this.name,
    required this.code,
    required this.type,
    required this.category,
    required this.status,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Gap(8.w),
                    DigifyCapsule(
                      label: type,
                      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                      backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                      textColor: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                    ),
                  ],
                ),
              ),
              Gap(12.w),
              DigifyStatusCapsule(status: status),
            ],
          ),
          Gap(4.h),
          Row(
            children: [
              Text(
                code,
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
              ),
              Gap(12.w),
              Text(
                '•',
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
              ),
              Gap(12.w),
              Text(
                category,
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            description,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
