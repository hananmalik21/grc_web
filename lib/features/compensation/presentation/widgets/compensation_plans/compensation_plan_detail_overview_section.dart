import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_blinking_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanDetailOverviewSection extends StatelessWidget {
  final CompensationPlan plan;

  const CompensationPlanDetailOverviewSection({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;
    final cards = _buildOverviewCards();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12.w,
                  runSpacing: 8.h,
                  children: [
                    DigifySquareCapsule(
                      label: plan.planCode,
                      backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                      textColor: isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    DigifyBlinkingStatusCapsule(
                      isActive: plan.isPayrollMapped,
                      activeLabel: 'Payroll Mapped',
                      inactiveLabel: 'Payroll Not Mapped',
                    ),
                  ],
                ),
              ),
              Gap(12.w),
              DigifyStatusCapsule(status: plan.statusCode),
            ],
          ),
          Gap(12.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800.w),
            child: Text(
              plan.displayDescription,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark,
              ),
            ),
          ),
          Gap(isMobile ? 20.h : 44.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 700;
              final isTablet = constraints.maxWidth < 1100;
              final columns = isNarrow ? 2 : (isTablet ? 3 : 6);
              final spacing = 12.w;
              final itemWidth = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: 12.h,
                children: [
                  for (final card in cards)
                    SizedBox(
                      width: itemWidth,
                      child: _OverviewStatCard(data: card, isCompact: isNarrow),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<_OverviewStatCardData> _buildOverviewCards() {
    return [
      _OverviewStatCardData(
        label: 'Effective Date',
        value: plan.formattedStartDate,
        iconPath: Assets.icons.auditTrailIconDepartment.path,
      ),
      _OverviewStatCardData(
        label: 'Expiry Date',
        value: plan.formattedEndDate,
        iconPath: Assets.icons.auditTrailIconDepartment.path,
      ),
      _OverviewStatCardData(label: 'Budget', value: plan.displayBudget, iconPath: Assets.icons.websiteIcon.path),
      _OverviewStatCardData(label: 'Currency', value: plan.currencyCode, iconPath: Assets.icons.metricsIcon.path),
      _OverviewStatCardData(label: 'Owner', value: plan.displayOwnerName, iconPath: Assets.icons.employeeListIcon.path),
      _OverviewStatCardData(label: 'Region', value: plan.displayRegion, iconPath: Assets.icons.mapPinGray.path),
    ];
  }
}

class _OverviewStatCardData {
  final String label;
  final String value;
  final String iconPath;

  const _OverviewStatCardData({required this.label, required this.value, required this.iconPath});
}

class _OverviewStatCard extends StatelessWidget {
  final _OverviewStatCardData data;
  final bool isCompact;

  const _OverviewStatCard({required this.data, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final pad = isCompact ? 12.w : 24.w;
    final iconSize = isCompact ? 32.w : 40.w;
    final iconInnerSize = isCompact ? 16.w : 20.w;
    final valueGap = isCompact ? 12.h : 26.h;

    return Container(
      constraints: BoxConstraints(minHeight: isCompact ? 90.h : 130.h),
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
                  ),
                ),
              ),
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.24) : AppColors.infoBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: DigifyAsset(
                  assetPath: data.iconPath,
                  width: iconInnerSize,
                  height: iconInnerSize,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Gap(valueGap),
          Text(
            data.value,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: isCompact ? 13.sp : 15.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
            ),
          ),
        ],
      ),
    );
  }
}
