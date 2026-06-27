import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:grc/features/hiring/presentation/utils/job_offer_pdf_opener.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/transfer_to_hr_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HrInterfaceOfferCardMobile extends StatelessWidget {
  const HrInterfaceOfferCardMobile({required this.offer, super.key});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(fallbackInitial: offer.candidateName, size: 44.w),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.candidateName,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${offer.position} • ${offer.id}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              DigifyCapsule(
                label: loc.hiringHrInterfaceOfferAccepted,
                backgroundColor: AppColors.successBg,
                borderColor: AppColors.successBorder,
                textColor: AppColors.successText,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ],
          ),
          Gap(16.h),
          const DigifyDivider(),
          Gap(16.h),
          _buildDetailRow(context, [
            _buildMobileDetailItem(context, loc.hiringHrInterfaceDepartment, offer.department),
            _buildMobileDetailItem(context, loc.hiringHrInterfaceGrade, offer.level),
          ]),
          Gap(12.h),
          _buildDetailRow(context, [
            _buildMobileDetailItem(context, loc.hiringHrInterfaceLocation, offer.location),
            _buildMobileDetailItem(context, loc.hiringHrInterfaceEmploymentType, offer.type),
          ]),
          Gap(12.h),
          _buildDetailRow(context, [
            _buildMobileDetailItem(context, loc.hiringHrInterfaceStartDate, offer.startDate),
            _buildMobileDetailItem(context, loc.hiringHrInterfaceAnnualSalary, offer.annualSalary, isBold: true),
          ]),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Expanded(
              //   child: Text(
              //     '${loc.hiringHrInterfaceAcceptedOn} ${offer.signedDate}',
              //     style: context.textTheme.labelSmall?.copyWith(
              //       color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              //     ),
              //   ),
              // ),
              Row(
                children: [
                  AppMobileButton.outline(
                    onPressed: () => openJobOfferPdf(context, offer),
                    svgPath: Assets.icons.eyesIcon.path,
                  ),
                  Gap(8.w),
                  AppMobileButton.outline(onPressed: () {}, svgPath: Assets.icons.employeeManagement.document.path),
                  Gap(8.w),
                  AppMobileButton.primary(
                    onPressed: () => TransferToHrDialog.show(context, offer),
                    svgPath: Assets.icons.securityManager.addUser.path,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, List<Widget> children) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) Gap(12.w),
        ],
      ],
    );
  }

  Widget _buildMobileDetailItem(BuildContext context, String label, String value, {bool isBold = false}) {
    final isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            fontSize: 11.sp,
          ),
        ),
        Gap(2.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
