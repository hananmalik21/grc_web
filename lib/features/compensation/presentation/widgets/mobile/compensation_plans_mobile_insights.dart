import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlansMobileInsights extends StatelessWidget {
  const CompensationPlansMobileInsights({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surfaceColor = isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final items = const [
      _MobileInsightItem(label: 'Total Plans', value: '6', subtext: '+2 this quarter'),
      _MobileInsightItem(label: 'Active Plans', value: '5', subtext: 'Currently effective'),
      _MobileInsightItem(label: 'Draft Plans', value: '1', subtext: 'In preparation'),
      _MobileInsightItem(label: 'Pending Approval', value: '0', subtext: 'Awaiting review'),
      _MobileInsightItem(label: 'Employees Covered', value: '335', subtext: 'Total coverage'),
      _MobileInsightItem(label: 'Monthly Cost', value: '175K', subtext: '+2.3% MoM'),
      _MobileInsightItem(label: 'Annual Cost', value: '21.06M', subtext: 'KWD projected'),
    ];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan Summary',
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          Gap(12.h),
          for (var index = 0; index < items.length; index++) ...[
            _InsightRow(item: items[index]),
            if (index < items.length - 1) ...[
              Gap(10.h),
              Divider(
                height: 1,
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
              ),
              Gap(10.h),
            ],
          ],
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.item});

  final _MobileInsightItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final accentColor = item.subtext.contains('+') ? AppColors.statIconBlue : secondaryColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(4.h),
              Text(
                item.subtext,
                style: context.textTheme.bodySmall?.copyWith(color: accentColor),
              ),
            ],
          ),
        ),
        Gap(12.w),
        Text(
          item.value,
          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _MobileInsightItem {
  const _MobileInsightItem({
    required this.label,
    required this.value,
    required this.subtext,
  });

  final String label;
  final String value;
  final String subtext;
}
