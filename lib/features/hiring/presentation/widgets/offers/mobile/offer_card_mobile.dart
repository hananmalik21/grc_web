import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offer_status_actions.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OfferCardMobile extends StatelessWidget {
  const OfferCardMobile({required this.offer, this.onDownloadSigned, this.onConvertToEmployee, super.key});

  final Offer offer;
  final VoidCallback? onDownloadSigned;
  final VoidCallback? onConvertToEmployee;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDark, textTheme),
          Gap(12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [_buildTag(offer.level, isDark), _buildTag(offer.type, isDark)],
          ),
          Gap(16.h),
          _buildDetailsSection(context, isDark, textTheme),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 16.h)),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildTag('Probation: ${offer.probationPeriod}', isDark),
              if (offer.signedDate != null) _buildTag('Signed on ${offer.signedDate}', isDark, isSuccess: true),
            ],
          ),
          Gap(12.h),
          OfferStatusActions(offer: offer, expanded: true),
          if (offer.status == OfferStatusCode.approved) ...[Gap(12.h), _buildApprovedActions()],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(fallbackInitial: offer.candidateInitials, size: 40.r),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.candidateName,
                style: textTheme.titleSmall?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(4.h),
              Text(
                '${offer.position} • ${offer.id}',
                style: textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Gap(8.w),
        DigifyStatusCapsule(status: offer.status),
      ],
    );
  }

  Widget _buildTag(String label, bool isDark, {bool isSuccess = false}) {
    if (isSuccess) {
      return DigifySquareCapsule(
        label: label,
        backgroundColor: AppColors.shiftActiveStatusBg,
        textColor: AppColors.roleBadgeSystemText,
        borderColor: AppColors.successBorder,
        borderRadius: BorderRadius.circular(8.r),
      );
    }

    return DigifySquareCapsule(
      label: label,
      backgroundColor: Colors.transparent,
      textColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      borderColor: isDark ? AppColors.borderGreyDark : AppColors.borderGrey,
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  Widget _buildDetailsSection(BuildContext context, bool isDark, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Position', offer.position, isDark, textTheme),
          Gap(12.h),
          _buildDetailItem('Department', offer.department, isDark, textTheme),
          Gap(12.h),
          _buildDetailItem('Location', offer.location, isDark, textTheme),
          Gap(12.h),
          _buildDetailItem('Start Date', offer.startDate, isDark, textTheme),
          Gap(12.h),
          _buildDetailItem('Annual Salary', offer.annualSalary, isDark, textTheme, isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark, TextTheme textTheme, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontSize: 11.sp,
          ),
        ),
        Gap(2.h),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildApprovedActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          label: 'Convert to Employee',
          onPressed: onConvertToEmployee,
          svgPath: Assets.icons.employeeListIcon.path,
        ),
        Gap(8.h),
        AppButton.outline(
          label: 'Download Signed',
          onPressed: onDownloadSigned,
          svgPath: Assets.icons.downloadIcon.path,
        ),
      ],
    );
  }
}
