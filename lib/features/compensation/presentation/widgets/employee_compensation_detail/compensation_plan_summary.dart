import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanSummary extends ConsumerWidget {
  const CompensationPlanSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeCompensationDetailProvider);
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;

    return CompensationSectionCard(
      title: 'Compensation Plan & Structure',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMPENSATION PLAN',
            style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, color: AppColors.grayBorderDark),
          ),
          Gap(8.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.planName,
                        style: context.textTheme.labelLarge?.copyWith(color: AppColors.primary, fontSize: 14.sp),
                      ),
                      Gap(4.h),
                      Text(
                        'Code: ${state.planCode}',
                        style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.grayBorderDark),
                      ),
                    ],
                  ),
                ),
                const DigifyStatusCapsule(status: 'Active'),
              ],
            ),
          ),
          Gap(24.h),
          if (isMobile) ...[
            _buildLabel(context, 'SALARY STRUCTURE'),
            Gap(4.h),
            Text(
              state.salaryStructure,
              style: context.textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            Text(state.structureCode, style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
            Gap(16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildMetaItem(context, isDark, 'EFFECTIVE DATE', state.effectiveDate)),
                Gap(16.w),
                Expanded(child: _buildMetaItem(context, isDark, 'CURRENCY', state.currency)),
              ],
            ),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(context, 'SALARY STRUCTURE'),
                      Gap(4.h),
                      Text(
                        state.salaryStructure,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        state.structureCode,
                        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMetaItem(context, isDark, 'EFFECTIVE DATE', state.effectiveDate)),
                      Gap(16.w),
                      Expanded(child: _buildMetaItem(context, isDark, 'CURRENCY', state.currency)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, color: AppColors.grayBorderDark),
    );
  }

  Widget _buildMetaItem(BuildContext context, bool isDark, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        Gap(6.h),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
