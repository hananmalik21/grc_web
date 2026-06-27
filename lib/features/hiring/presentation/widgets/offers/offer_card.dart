import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offer_status_actions.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({required this.offer, this.onDownloadSigned, this.onConvertToEmployee, super.key});

  final Offer offer;
  final VoidCallback? onDownloadSigned;
  final VoidCallback? onConvertToEmployee;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isDark, textTheme),
          Gap(16.h),
          _buildDetailsGrid(context, isDark, textTheme),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 16.h)),
          _buildFooter(context, isDark, textTheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(fallbackInitial: offer.candidateInitials, size: 48.r),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                offer.candidateName,
                style: textTheme.titleLarge?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(4.h),
              Row(
                children: [
                  Text(
                    offer.position,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  Gap(8.w),
                  DigifyStatusDot(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, size: 3.w),
                  Gap(8.w),
                  Text(
                    offer.id,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Gap(8.h),
              Row(children: [_buildTag(offer.level, isDark), Gap(8.w), _buildTag(offer.type, isDark)]),
            ],
          ),
        ),
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

  Widget _buildDetailsGrid(BuildContext context, bool isDark, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 500;
          if (isSmall) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Position', offer.position, isDark, textTheme)),
                    Expanded(child: _buildDetailItem('Department', offer.department, isDark, textTheme)),
                  ],
                ),
                Gap(16.h),
                Row(
                  children: [
                    Expanded(child: _buildDetailItem('Location', offer.location, isDark, textTheme)),
                    Expanded(child: _buildDetailItem('Start Date', offer.startDate, isDark, textTheme)),
                  ],
                ),
                Gap(16.h),
                _buildDetailItem('Annual Salary', offer.annualSalary, isDark, textTheme, isHighlight: true),
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem('Position', offer.position, isDark, textTheme),
              _buildDetailItem('Department', offer.department, isDark, textTheme),
              _buildDetailItem('Location', offer.location, isDark, textTheme),
              _buildDetailItem('Start Date', offer.startDate, isDark, textTheme),
              _buildDetailItem('Annual Salary', offer.annualSalary, isDark, textTheme, isHighlight: true),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark, TextTheme textTheme, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
        ),
        Gap(4.h),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark, TextTheme textTheme) {
    final tags = Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildTag('Probation: ${offer.probationPeriod}', isDark),
        if (offer.signedDate != null) _buildTag('Signed on ${offer.signedDate}', isDark, isSuccess: true),
      ],
    );

    final actions = Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.end,
      children: [
        OfferStatusActions(offer: offer),
        if (offer.status == OfferStatusCode.approved) ...[
          AppButton.outline(
            label: 'Download Signed',
            onPressed: onDownloadSigned,
            svgPath: Assets.icons.downloadIcon.path,
          ),
          AppButton.primary(
            label: 'Convert to Employee',
            onPressed: onConvertToEmployee,
            svgPath: Assets.icons.employeeListIcon.path,
          ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 720) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [tags, Gap(12.h), actions]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: tags),
            Gap(16.w),
            actions,
          ],
        );
      },
    );
  }
}
