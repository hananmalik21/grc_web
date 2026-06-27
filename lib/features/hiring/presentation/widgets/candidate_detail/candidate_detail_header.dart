import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/candidate_detail_header_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/overview/edit_candidate_profile_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CandidateDetailHeader extends StatelessWidget {
  const CandidateDetailHeader({super.key, required this.candidate, required this.isDark, required this.isMobile});

  final CandidateData candidate;
  final bool isDark;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return CandidateDetailHeaderMobile(candidate: candidate, isDark: isDark);
    }

    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context, textPrimary, subTextColor),
          if (candidate.talentPoolLabels.isNotEmpty) ...[Gap(16.h), _buildTagsRow(context, subTextColor)],
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, Color textPrimary, Color subTextColor) {
    final nameSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              candidate.name,
              style: context.textTheme.titleLarge?.copyWith(
                fontSize: 24.sp,
                color: textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(12.w),
            DigifyStatusCapsule(status: candidate.status),
            Gap(12.w),
            _buildRating(candidate.rating),
          ],
        ),
        Gap(4.h),
        Text(
          '${candidate.jobTitle} at ${candidate.company}',
          style: context.textTheme.bodyMedium?.copyWith(color: subTextColor),
        ),
      ],
    );

    final actionButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(
          label: 'Edit',
          svgPath: Assets.icons.editIcon.path,
          onPressed: () => EditCandidateProfileDialog.show(context, candidate),
        ),
        Gap(8.w),
        AppButton.primary(label: 'Send Message', svgPath: Assets.icons.sendEmailPurple.path, onPressed: () {}),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
        Gap(24.w),
        AppAvatar(fallbackInitial: candidate.name, size: 64.r),
        Gap(24.w),
        Expanded(child: nameSection),
        actionButtons,
      ],
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
            size: 18.r,
            color: AppColors.warning,
          ),
        Gap(8.w),
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow(BuildContext context, Color color) {
    return Row(
      children: [
        Gap(112.w),
        DigifyAsset(assetPath: Assets.icons.compensation.badge.path, width: 16.r, height: 16.r, color: color),
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
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
