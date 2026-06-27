import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/employee_self_service/presentation/providers/my_payslips/my_payslips_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PayslipDetailedBreakdownCard extends StatelessWidget {
  final PayslipDetailedBreakdown details;

  const PayslipDetailedBreakdownCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Breakdown',
            style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
          Gap(10.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 700;
              final earningsSection = _BreakdownSection(
                title: 'Earnings & Allowances',
                items: details.earnings,
                totalLabel: 'Gross Earnings',
                totalValue: details.grossEarnings,
              );
              final deductionsSection = _BreakdownSection(
                title: 'Statutory Deductions',
                items: details.deductions,
                totalLabel: 'Total Deductions',
                totalValue: details.totalDeductions,
                useNegativeAccent: true,
              );

              if (isStacked) {
                return Column(children: [earningsSection, Gap(20.h), deductionsSection]);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: earningsSection),
                  Gap(20.w),
                  Expanded(child: deductionsSection),
                ],
              );
            },
          ),
          Gap(16.h),
          _NetTransferCard(
            netTransferAmount: details.netTransferAmount,
            disbursementMethod: details.disbursementMethod,
          ),
        ],
      ),
    );
  }
}

class _BreakdownSection extends StatelessWidget {
  final String title;
  final List<PayslipBreakdownItem> items;
  final String totalLabel;
  final String totalValue;
  final bool useNegativeAccent;

  const _BreakdownSection({
    required this.title,
    required this.items,
    required this.totalLabel,
    required this.totalValue,
    this.useNegativeAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalColor = useNegativeAccent ? AppColors.error : context.themeTextPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(fontSize: 12.sp, color: AppColors.primary),
        ),
        Gap(12.h),
        for (final item in items) ...[_BreakdownLineItem(item: item), Gap(9.h)],
        DigifyDivider(
          margin: EdgeInsets.only(top: 2.h, bottom: 10.h),
          height: 1,
          thickness: 2,
          color: AppColors.inputBg,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                totalLabel,
                style: context.textTheme.labelLarge?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: context.themeTextPrimary,
                ),
              ),
            ),
            Text(
              totalValue,
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: totalColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BreakdownLineItem extends StatelessWidget {
  final PayslipBreakdownItem item;

  const _BreakdownLineItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final valueColor = item.isNegative ? AppColors.error : context.themeTextPrimary;

    return Row(
      children: [
        Expanded(
          child: Text(
            item.label,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.sidebarSecondaryText),
          ),
        ),
        Gap(16.w),
        Text(
          item.value,
          style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: valueColor),
        ),
      ],
    );
  }
}

class _NetTransferCard extends StatelessWidget {
  final String netTransferAmount;
  final String disbursementMethod;

  const _NetTransferCard({required this.netTransferAmount, required this.disbursementMethod});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.jobRoleBg),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isStacked = constraints.maxWidth < 540;
          final amountBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Net Transfer Amount',
                style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
              ),
              Gap(4.h),
              Text(
                netTransferAmount,
                style: context.textTheme.displaySmall?.copyWith(fontSize: 26.sp, color: AppColors.textPrimary),
              ),
            ],
          );
          final methodBlock = Column(
            crossAxisAlignment: isStacked ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                'Disbursement Method',
                style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
              ),
              Gap(6.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.employeeManagement.banking.path,
                    width: 16,
                    height: 16,
                    color: AppColors.primary,
                  ),
                  Gap(6.w),
                  Text(
                    disbursementMethod,
                    style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          );

          if (isStacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [amountBlock, Gap(16.h), methodBlock],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [amountBlock, methodBlock],
          );
        },
      ),
    );
  }
}
