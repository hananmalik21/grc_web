import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CommunicationCard extends StatelessWidget {
  const CommunicationCard({super.key, required this.communication, required this.isDark});

  final CandidateCommunicationData communication;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;
    final cardBg = isDark ? AppColors.cardBackgroundDark : Colors.white;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16.w : 25.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textDarkSlate = isDark ? AppColors.textPrimaryDark : AppColors.textDarkSlate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            _buildIconContainer(context),
            Gap(12.w),
            // Title and Channel Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    communication.title,
                    style: context.textTheme.titleMedium?.copyWith(color: textPrimary, fontSize: 15.sp),
                  ),
                  Gap(4.h),
                  Row(
                    children: [
                      Text(communication.type, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: DigifyStatusDot(color: textSecondary, size: 4.r),
                      ),
                      Text(
                        communication.direction,
                        style: context.textTheme.bodyMedium?.copyWith(color: textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(16.w),
            // Date & Time Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(communication.date, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
                Text(communication.time, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
              ],
            ),
          ],
        ),
        Gap(12.h),
        // Body Description
        Text(communication.description, style: context.textTheme.bodyLarge?.copyWith(color: textDarkSlate)),

        // Divider
        DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 12.h)),

        // Footer Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(communication.detail, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
            DigifyStatusCapsule(status: communication.status),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textDarkSlate = isDark ? AppColors.textPrimaryDark : AppColors.textDarkSlate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Icon + Title & Type
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconContainer(context),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    communication.title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                      fontSize: 15.sp,
                      height: 1.2,
                    ),
                  ),
                  Gap(4.h),
                  Row(
                    children: [
                      Text(
                        communication.type,
                        style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontSize: 13.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: DigifyStatusDot(color: textSecondary, size: 4.r),
                      ),
                      Text(
                        communication.direction,
                        style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Gap(12.h),
        // Date and Time (Mobile optimized placement)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ${communication.date}',
              style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontSize: 13.sp),
            ),
            Text(
              communication.time,
              style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontSize: 13.sp),
            ),
          ],
        ),
        Gap(12.h),
        // Description
        Text(
          communication.description,
          style: context.textTheme.bodyLarge?.copyWith(color: textDarkSlate, fontSize: 14.sp, height: 1.4),
        ),
        Gap(12.h),
        const DigifyDivider.horizontal(),
        Gap(12.h),
        // Footer: To/From + Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              communication.detail,
              style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontSize: 13.sp),
            ),
            DigifyStatusCapsule(status: communication.status),
          ],
        ),
      ],
    );
  }

  Widget _buildIconContainer(BuildContext context) {
    final isEmail = communication.type.toLowerCase() == 'email';
    final iconPath = isEmail ? Assets.icons.emailEnvelopeBlue.path : Assets.icons.phoneCardIcon.path;
    final iconColor = isDark ? AppColors.primaryLight : AppColors.primary;
    final containerBg = isDark ? AppColors.infoBgDark : AppColors.infoBg;

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(color: containerBg, borderRadius: BorderRadius.circular(10.r)),
      alignment: Alignment.center,
      child: DigifyAsset(assetPath: iconPath, color: iconColor, width: 20.w, height: 20.w),
    );
  }
}
