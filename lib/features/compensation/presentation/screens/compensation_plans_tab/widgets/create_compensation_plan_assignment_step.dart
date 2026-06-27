import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_compensation_plan_employee_selection.dart';
import 'create_compensation_plan_section_card.dart';

class CreateCompensationPlanAssignmentStep extends ConsumerWidget {
  const CreateCompensationPlanAssignmentStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);
    final enterpriseId = ref.watch(compensationPlansTabEnterpriseIdProvider);
    final isDark = context.isDark;

    return Column(
      key: const ValueKey('plan-assignment-step'),
      children: [
        CreateCompensationPlanSectionCard(
          title: 'Employee Assignments',
          subtitle: 'Employees currently assigned to this plan',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (enterpriseId != null)
                CreateCompensationPlanEmployeeSelection(
                  enterpriseId: enterpriseId,
                  selectedEmployees: state.assignedEmployees,
                  onChanged: notifier.setAssignedEmployees,
                )
              else
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.infoCircleBlue.path,
                        width: 20.w,
                        height: 20.w,
                        color: AppColors.info,
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Text(
                          'Select an enterprise first to search for employees.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Gap(24.h),
              if (state.assignedEmployees.isNotEmpty) ...[
                Text(
                  'Selected Employees (${state.assignedEmployees.length})',
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Gap(12.h),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.assignedEmployees.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                    ),
                    itemBuilder: (context, index) {
                      final employee = state.assignedEmployees[index];
                      return ListTile(
                        dense: true,
                        leading: AppAvatar(
                          size: 32,
                          fallbackInitial: employee.fullName,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        ),
                        title: Text(
                          employee.fullName,
                          style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          employee.employeeNumber ?? 'No Employee ID',
                          style: context.textTheme.bodySmall?.copyWith(color: context.themeTextSecondary),
                        ),
                        trailing: DigifyAssetButton(
                          assetPath: Assets.icons.closeIcon.path,
                          height: 25.w,
                          width: 25.w,
                          color: AppColors.alertCritical,
                          onTap: () => notifier.removeAssignedEmployee(employee.id),
                        ),
                      );
                    },
                  ),
                ),
              ] else
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Column(
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.compensation.users.path,
                          width: 48.w,
                          height: 48.w,
                          color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                        ),
                        Gap(12.h),
                        Text(
                          'No employees assigned yet',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
