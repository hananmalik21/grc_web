import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/info_banner_card.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:grc/features/hiring/presentation/utils/job_offer_pdf_opener.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/transfer_to_hr_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HrInterfaceOfferCardDesktop extends StatelessWidget {
  const HrInterfaceOfferCardDesktop({required this.offer, this.isSelected = false, this.onSelected, super.key});

  final Offer offer;
  final bool isSelected;
  final ValueChanged<bool?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AppAvatar(fallbackInitial: offer.candidateName, size: 48.w),
                            Gap(16.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.candidateName,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                  ),
                                ),
                                Gap(4.h),
                                Text(
                                  '${offer.position} • ${offer.id}',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                  ),
                                ),
                                Gap(4.h),
                                Text(
                                  'alex.martinez@email.com • +1-555-0101',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DigifyCapsule(
                              label: loc.hiringHrInterfaceOfferAccepted,
                              backgroundColor: AppColors.successBg,
                              borderColor: AppColors.successBorder,
                              textColor: AppColors.successText,
                            ),
                            // Gap(8.h),
                            // Text(
                            //   '${loc.hiringHrInterfaceAcceptedOn} ${offer.signedDate}',
                            //   style: context.textTheme.labelSmall?.copyWith(
                            //     color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                            //     fontSize: 12.sp,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    Gap(16.h),
                    _buildDetailsGrid(context),
                    Gap(16.h),
                    InfoBannerCard(
                      iconAssetPath: Assets.icons.infoCircleBlue.path,
                      message: loc.hiringHrInterfaceReadyForTransferDesc,
                    ),
                    Gap(16.h),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 3.5,
        children: [
          _buildDetailItem(context, loc.hiringHrInterfacePosition, offer.position),
          _buildDetailItem(context, loc.hiringHrInterfaceDepartment, offer.department),
          _buildDetailItem(context, loc.hiringHrInterfaceGrade, offer.level),
          _buildDetailItem(context, loc.hiringHrInterfaceLocation, offer.location),
          _buildDetailItem(context, loc.hiringHrInterfaceStartDate, offer.startDate),
          _buildDetailItem(context, loc.hiringHrInterfaceEmploymentType, offer.type),
          _buildDetailItem(context, loc.hiringHrInterfaceAnnualSalary, offer.annualSalary, isBold: true),
          _buildDetailItem(context, loc.hiringHrInterfaceProbation, offer.probationPeriod),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value, {bool isBold = false}) {
    final isDark = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton.outline(
          label: loc.hiringHrInterfaceViewOffer,
          onPressed: () => openJobOfferPdf(context, offer),
          svgPath: Assets.icons.eyesIcon.path,
        ),
        Gap(8.w),
        AppButton.outline(
          label: loc.hiringHrInterfaceViewDocuments,
          onPressed: () {},
          svgPath: Assets.icons.employeeManagement.document.path,
        ),
        Gap(8.w),
        AppButton.outline(
          label: loc.hiringHrInterfaceExportData,
          onPressed: () {},
          svgPath: Assets.icons.downloadIcon.path,
        ),
        Gap(8.w),
        AppButton.primary(
          label: loc.hiringHrInterfaceTransferToHr,
          onPressed: () => TransferToHrDialog.show(context, offer),
          svgPath: Assets.icons.securityManager.addUser.path,
        ),
      ],
    );
  }
}
