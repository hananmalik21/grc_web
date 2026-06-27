import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_as_applicant_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'candidate_data.dart';

class RequisitionCandidateCard extends StatelessWidget {
  const RequisitionCandidateCard({super.key, required this.data, required this.isDark});

  final CandidateData data;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(isMobile ? 16.w : 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isMobile),
          Gap(12.h),
          _buildInfoGrid(context, isMobile),
          Gap(16.h),
          _buildSkillsSection(context),
          Gap(20.h),
          const DigifyDivider.horizontal(),
          Gap(20.h),
          _buildFooter(context, isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(fallbackInitial: data.name, size: isMobile ? 48.w : 64.w),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    data.name,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(12.w),
                  _buildMatchBadge(context),
                ],
              ),
              Gap(4.h),
              Text(
                '${data.role} at ${data.company}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          Gap(16.w),
          AppButton.primary(
            label: 'Add as Applicant',
            onPressed: () => _showAddAsApplicantDialog(context),
            svgPath: Assets.icons.securityManager.addUser.path,
          ),
        ],
      ],
    );
  }

  Widget _buildMatchBadge(BuildContext context) {
    return DigifySquareCapsule(
      label: '${data.matchPercentage}% Match',
      backgroundColor: isDark ? AppColors.successBgDark : AppColors.activeStatusBgLight,
      textColor: isDark ? AppColors.successTextDark : AppColors.activeStatusTextLight,
      borderColor: isDark ? AppColors.successBorderDark : AppColors.activeStatusBorderLight,
      borderRadius: BorderRadius.circular(10.r),
    );
  }

  Widget _buildInfoGrid(BuildContext context, bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      childAspectRatio: isMobile ? 2.5 : 3.5,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 16.w,
      children: [
        _buildInfoItem(context, Assets.icons.compensation.badge.path, 'Experience', data.experience),
        _buildInfoItem(context, Assets.icons.checkCircleGreen.path, 'Location', data.location),
        _buildInfoItem(context, Assets.icons.emailCardIcon.path, 'Email', data.email),
        _buildInfoItem(context, Assets.icons.clockIcon.path, 'Availability', data.availability),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String assetPath, String label, String value) {
    return Row(
      children: [
        DigifyAsset(assetPath: assetPath, color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText),
        Gap(8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                value,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Skills',
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
            fontSize: 12.sp,
          ),
        ),
        Gap(8.h),
        Wrap(spacing: 8.w, runSpacing: 8.h, children: data.keySkills.map((skill) => _buildSkillBadge(skill)).toList()),
      ],
    );
  }

  Widget _buildSkillBadge(String label) {
    return DigifyCapsule(
      label: label,
      backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.authDivider,
    );
  }

  Widget _buildFooter(BuildContext context, bool isMobile) {
    final fromSection = Expanded(
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'From: ',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    text: data.talentPool,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    final educationSection = Expanded(
      child: Row(
        children: [
          DigifyAsset(
            assetPath: Assets.icons.employeeSelfService.education.path,
            color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
          ),
          Gap(4.w),
          Expanded(
            child: Text(
              data.education,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    final contactButton = AppButton.outline(
      label: 'Contact',
      onPressed: () {},
      svgPath: Assets.icons.emailCardIcon.path,
      height: 36.w,
    );

    final viewProfileButton = AppButton.outline(
      label: 'View Profile',
      onPressed: () {},
      svgPath: Assets.icons.userIcon.path,
      height: 36.w,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [fromSection]),
          Gap(8.h),
          Row(children: [educationSection]),
          Gap(16.h),
          Row(
            children: [
              Expanded(child: contactButton),
              Gap(8.w),
              Expanded(child: viewProfileButton),
            ],
          ),
          Gap(12.h),
          AppButton.primary(
            label: 'Add as Applicant',
            onPressed: () => _showAddAsApplicantDialog(context),
            svgPath: Assets.icons.securityManager.addUser.path,
            width: double.infinity,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Row(children: [fromSection, Gap(16.w), educationSection])),
        Row(children: [contactButton, Gap(8.w), viewProfileButton]),
      ],
    );
  }

  void _showAddAsApplicantDialog(BuildContext context) {
    AddCandidateAsApplicantDialog.show(context, data);
  }
}
