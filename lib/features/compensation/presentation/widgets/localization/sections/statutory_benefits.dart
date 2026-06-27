import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../dialogs/localization/statutory_role_dialog.dart';

class StatutoryBenefits extends ConsumerStatefulWidget {
  const StatutoryBenefits({super.key});

  @override
  ConsumerState<StatutoryBenefits> createState() => _StatutoryBenefitsState();
}

class _StatutoryBenefitsState extends ConsumerState<StatutoryBenefits> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Statutory Benefits Configuration',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            AppButton.primary(
              label: 'Add Statutory Rule',
              icon: Icons.add,
              onPressed: () => StatutoryRoleDialog.show(context),
            ),
          ],
        ),
        Gap(24.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBenefitCard(
              title: 'Social Insurance',
              subtitle: 'Kuwait',
              contributionBasis: 'Basic Salary',
              employerRate: '11.5%',
              employeeRate: '10.5%',
              ceilingAmount: '2,750 KWD',
              categories: 'Nationals Only',
              footerText: 'PIFSS Contribution',
            ),
            Gap(24.h),
            _buildBenefitCard(
              title: 'GOSI',
              subtitle: 'Saudi Arabia',
              contributionBasis: 'Basic Salary',
              employerRate: '12%',
              employeeRate: '10%',
              ceilingAmount: '45,000 SAR',
              categories: 'Nationals & GCC',
              footerText: 'General Organization for Social Insurance',
            ),
            Gap(24.h),
            _buildBenefitCard(
              title: 'Pension Fund',
              subtitle: 'UAE',
              contributionBasis: 'Basic Salary',
              employerRate: '15%',
              employeeRate: '5%',
              ceilingAmount: '50,000 AED',
              categories: 'UAE Nationals Only',
              footerText: 'GPSSA for Abu Dhabi, PIFSS for other Emirates',
            ),
            Gap(24.h),
            _buildBenefitCard(
              title: 'Medical Insurance',
              subtitle: 'UAE',
              contributionBasis: 'Fixed Premium',
              employerRate: '100%',
              employeeRate: '0%',
              ceilingAmount: 'As per policy',
              categories: 'All Employees',
              footerText: 'Mandatory for all employees and dependents',
            ),
            Gap(24.h),
            _buildBenefitCard(
              title: 'Gratuity',
              subtitle: 'UAE',
              contributionBasis: 'Basic Salary',
              employerRate: 'Accrual Based',
              employeeRate: '0%',
              ceilingAmount: 'No Ceiling',
              categories: 'Expatriates',
              footerText: '21 days for first 5 years, 30 days thereafter',
            ),
          ],
        ),
        Gap(24.h),
        _buildStatutoryComparison(),
      ],
    );
  }

  Widget _buildBenefitCard({
    required String title,
    required String subtitle,
    required String contributionBasis,
    required String employerRate,
    required String employeeRate,
    required String ceilingAmount,
    required String categories,
    required String footerText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.cardBorderDark
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignment: Alignment.center,
                  child: DigifyAsset(
                    assetPath: Assets.icons.securityIcon.path,
                    color: AppColors.primary,
                    width: 24,
                    height: 24,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                DigifyCapsule(
                  label: 'Enabled',
                  textColor: AppColors.success,
                  backgroundColor: AppColors.success.withValues(alpha: 0.1),
                ),
                Gap(12.w),
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                _buildInfoItem('CONTRIBUTION BASIS', contributionBasis),
                _buildInfoItem('EMPLOYER RATE', employerRate),
                _buildInfoItem('EMPLOYEE RATE', employeeRate),
                _buildInfoItem('CEILING AMOUNT', ceilingAmount),
              ],
            ),
          ),
          Gap(18.h),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories', style: context.textTheme.bodySmall),
                    Gap(8.h),
                    Text(categories, style: context.textTheme.titleSmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16.sp,
                      color: AppColors.textMuted,
                    ),
                    Gap(8.w),
                    Text(
                      footerText,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          Gap(8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatutoryComparison() {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.cardBorderDark
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Text(
              'Statutory Comparison',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                if (context.isMobile) ...[
                  _buildComparisonItem(
                    flag: '🇰🇼',
                    country: 'Kuwait',
                    benefit: 'Social Insurance',
                    rule: 'PIFSS for nationals',
                    rates: 'Employer: 11.5% | Employee: 10.5%',
                  ),
                  Gap(16.w),
                  _buildComparisonItem(
                    flag: '🇸🇦',
                    country: 'Saudi Arabia',
                    benefit: 'Social Insurance',
                    rule: 'GOSI',
                    rates: 'Employer: 12% | Employee: 10%',
                  ),
                  Gap(16.w),
                  _buildComparisonItem(
                    flag: '🇦🇪',
                    country: 'UAE',
                    benefit: 'Pension & Gratuity',
                    rule: 'Pension for nationals / Gratuity for expats',
                    rates: 'Employer: 15% | Employee: 5% (nationals)',
                  ),
                ] else ...[
                  Row(
                    children: [
                      _buildComparisonItem(
                        flag: '🇰🇼',
                        country: 'Kuwait',
                        benefit: 'Social Insurance',
                        rule: 'PIFSS for nationals',
                        rates: 'Employer: 11.5% | Employee: 10.5%',
                      ),
                      Gap(16.w),
                      _buildComparisonItem(
                        flag: '🇸🇦',
                        country: 'Saudi Arabia',
                        benefit: 'Social Insurance',
                        rule: 'GOSI',
                        rates: 'Employer: 12% | Employee: 10%',
                      ),
                      Gap(16.w),
                      _buildComparisonItem(
                        flag: '🇦🇪',
                        country: 'UAE',
                        benefit: 'Pension & Gratuity',
                        rule: 'Pension for nationals / Gratuity for expats',
                        rates: 'Employer: 15% | Employee: 5% (nationals)',
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonItem({
    required String flag,
    required String country,
    required String benefit,
    required String rule,
    required String rates,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(flag, style: TextStyle(fontSize: 16.sp)),
                Gap(8.w),
                Text(
                  country,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Gap(12.h),
            Text(
              benefit,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gap(4.h),
            Text(
              rule,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(8.h),
            Text(
              rates,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
