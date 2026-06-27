import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/employee_self_service/presentation/providers/my_payslips/my_payslips_state.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/my_payslips/widgets/payslip_detailed_breakdown_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/my_payslips/widgets/payslip_metric_item.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PayslipRecordCard extends StatelessWidget {
  final PayslipRecord record;
  final bool isExpanded;
  final VoidCallback onToggleDetails;

  const PayslipRecordCard({super.key, required this.record, required this.isExpanded, required this.onToggleDetails});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isStacked = constraints.maxWidth < 980;
        final header = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: DigifyAsset(
                assetPath: Assets.icons.employeeManagement.document.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10.w,
                    runSpacing: 6.h,
                    children: [
                      Text(record.period.monthLabel, style: context.textTheme.titleMedium?.copyWith(fontSize: 16.sp)),
                      DigifySquareCapsule(
                        label: record.period.statusLabel,
                        backgroundColor: context.themeInfoBg,
                        textColor: AppColors.roleActionBlue,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                    ],
                  ),
                  Gap(2.h),
                  Text(
                    record.period.periodLabel,
                    style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText),
                  ),
                ],
              ),
            ),
          ],
        );

        final actions = _PayslipActions(isStacked: isStacked, isExpanded: isExpanded, onToggleDetails: onToggleDetails);
        final breakdown = Wrap(
          spacing: 18.w,
          runSpacing: 12.h,
          children: [
            for (final item in record.breakdown)
              SizedBox(
                width: isStacked ? constraints.maxWidth / 2 - 18.w : 140.w,
                child: PayslipMetricItem(item: item),
              ),
          ],
        );

        if (isStacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              Gap(16.h),
              breakdown,
              Gap(16.h),
              actions,
              if (isExpanded) ...[Gap(16.h), PayslipDetailedBreakdownCard(details: record.detailedBreakdown)],
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [header, Gap(12.h), breakdown]),
                ),
                Gap(20.w),
                actions,
              ],
            ),
            if (isExpanded) ...[Gap(16.h), PayslipDetailedBreakdownCard(details: record.detailedBreakdown)],
          ],
        );
      },
    );
  }
}

class _PayslipActions extends StatelessWidget {
  final bool isStacked;
  final bool isExpanded;
  final VoidCallback onToggleDetails;

  const _PayslipActions({required this.isStacked, required this.isExpanded, required this.onToggleDetails});

  Widget _buildActionButton({
    required String label,
    required AppButtonType type,
    required String? svgPath,
    required IconData? icon,
    required Color? svgAssetColor,
    required Color? foregroundColor,
    required VoidCallback onPressed,
  }) {
    final button = AppButton(
      label: label,
      onPressed: onPressed,
      type: type,
      svgPath: svgPath,
      icon: icon,
      svgAssetColor: svgAssetColor,
      foregroundColor: foregroundColor,
      height: 32.h,
      fontSize: 12.sp,
      iconSize: 13,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      borderRadius: BorderRadius.circular(8.r),
    );

    return SizedBox(width: isStacked ? double.infinity : 120.w, child: button);
  }

  @override
  Widget build(BuildContext context) {
    final viewButton = _buildActionButton(
      label: isExpanded ? 'Hide Details' : 'View Details',
      type: AppButtonType.outline,
      svgPath: Assets.icons.previewIcon.path,
      icon: null,
      svgAssetColor: AppColors.blackTextColor,
      foregroundColor: AppColors.blackTextColor,
      onPressed: onToggleDetails,
    );
    final downloadButton = _buildActionButton(
      label: 'Download',
      type: AppButtonType.primary,
      svgPath: Assets.icons.downloadIcon.path,
      icon: null,
      svgAssetColor: Colors.white,
      foregroundColor: Colors.white,
      onPressed: () {
        ToastService.info(context, 'Download is coming soon', title: 'Payslip');
      },
    );
    final printButton = _buildActionButton(
      label: 'Print',
      type: AppButtonType.outline,
      svgPath: null,
      icon: Icons.print_outlined,
      svgAssetColor: AppColors.blackTextColor,
      foregroundColor: AppColors.blackTextColor,
      onPressed: () {
        ToastService.info(context, 'Print is coming soon', title: 'Payslip');
      },
    );

    return SizedBox(
      width: isStacked ? double.infinity : 120.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [viewButton, Gap(8.h), downloadButton, Gap(8.h), printButton],
      ),
    );
  }
}
