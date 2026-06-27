import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/overview/edit_candidate_profile_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CandidateDetailHeaderMobile extends StatelessWidget {
  const CandidateDetailHeaderMobile({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
              Gap(12.w),
              AppAvatar(fallbackInitial: candidate.name, size: 48.r),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            candidate.name,
                            style: context.textTheme.titleLarge?.copyWith(
                              fontSize: 18.sp,
                              color: textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gap(8.w),
                        DigifyStatusCapsule(status: candidate.status),
                      ],
                    ),
                    Gap(2.h),
                    Text(
                      '${candidate.jobTitle} at ${candidate.company}',
                      style: context.textTheme.bodySmall?.copyWith(color: subTextColor, fontSize: 12.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRating(candidate.rating),
              Row(
                children: [
                  AppMobileButton.outline(
                    svgPath: Assets.icons.editIcon.path,
                    onPressed: () => EditCandidateProfileDialog.show(context, candidate),
                  ),
                  Gap(8.w),
                  AppMobileButton.primary(svgPath: Assets.icons.sendEmailPurple.path, onPressed: () {}),
                ],
              ),
            ],
          ),
          if (candidate.talentPoolLabels.isNotEmpty) ...[Gap(16.h), _buildTagsRow(context, subTextColor)],
        ],
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
            size: 16.r,
            color: AppColors.warning,
          ),
        Gap(6.w),
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow(BuildContext context, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: DigifyAsset(assetPath: Assets.icons.compensation.badge.path, width: 14.r, height: 14.r, color: color),
        ),
        Gap(8.w),
        Expanded(
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: candidate.talentPoolLabels
                .map(
                  (poolName) => DigifyCapsule(
                    label: poolName,
                    backgroundColor: isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.jobRoleBg,
                    textColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
