import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';

class CompensationComponentsEditor extends ConsumerWidget {
  const CompensationComponentsEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeCompensationDetailProvider);
    final details = state.details;

    return CompensationSectionCard(
      title: 'Compensation Components',
      child: Builder(
        builder: (context) {
          final groups = details?.displayComponentGroups ?? const <EmployeeCompensationComponentGroup>[];

          if (groups.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.isDark ? AppColors.infoBgDark : AppColors.infoBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: context.isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No compensation components',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < groups.length; i++) ...[
                _buildGroupContainer(context, groups[i]),
                if (i != groups.length - 1) Gap(16.h),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupContainer(BuildContext context, EmployeeCompensationComponentGroup group) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.displayTypeLabel,
            style: context.textTheme.labelMedium?.copyWith(
              fontSize: 11.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(12.h),
          DigifyDivider.horizontal(),
          Gap(12.h),
          for (var i = 0; i < group.components.length; i++) ...[
            _buildComponentRow(context, group.components[i]),
            if (i != group.components.length - 1) Gap(4.h),
          ],
        ],
      ),
    );
  }

  Widget _buildComponentRow(BuildContext context, EmployeeCompensationComponent component) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              component.displayLabel,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(12.w),
          Text(
            component.displayAmountValue,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
