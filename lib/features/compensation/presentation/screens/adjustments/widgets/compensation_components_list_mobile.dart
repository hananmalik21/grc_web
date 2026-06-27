import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/common/compensation_component_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationComponentsListMobile extends StatelessWidget {
  final List<ComponentAdjustment> adjustments;
  final bool isDark;

  const CompensationComponentsListMobile({super.key, required this.adjustments, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: adjustments.map((adj) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(adj.componentName, style: context.textTheme.titleSmall)),
                  CompensationComponentTypeBadge(type: adj.componentType),
                ],
              ),
              Gap(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Frequency:',
                    style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textTertiary),
                  ),
                  Text(
                    adj.frequencyLabel,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Gap(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Amount:',
                    style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textTertiary),
                  ),
                  Text(
                    adj.formattedCurrentAmount,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Gap(8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Annual Value:',
                    style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textTertiary),
                  ),
                  Text(
                    adj.formattedAnnualValue,
                    style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
