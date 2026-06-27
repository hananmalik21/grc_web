import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'approval_step_data.dart';

class ApprovalStepCard extends StatelessWidget {
  const ApprovalStepCard({super.key, required this.data, required this.isDark});

  final ApprovalStepData data;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DigifyAsset(
                                assetPath: Assets.icons.userIcon.path,
                                width: 14.w,
                                height: 14.w,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                              ),
                              Gap(8.w),
                              Text(
                                data.name,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            data.role,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DigifyStatusCapsule(status: data.status),
                  ],
                ),
                if (data.comment.isNotEmpty || data.date != '-') ...[
                  DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 8.h)),
                  Text(
                    data.date,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  if (data.comment.isNotEmpty) ...[
                    Gap(4.h),
                    Text(
                      '"${data.comment}"',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
