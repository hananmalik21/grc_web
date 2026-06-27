import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_compensation_plan_available_components_section.dart';
import 'salary_structure_selection.dart';

class CreateCompensationPlanComponentsStep extends ConsumerWidget {
  const CreateCompensationPlanComponentsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);

    return Container(
      key: const ValueKey('plan-components-step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SalaryStructureSelection(
            selectedId: state.selectedSalaryStructureId,
            selectedValue: state.selectedSalaryStructure,
            onChanged: (selected) {
              notifier.updateSelectedSalaryStructure(
                selected?.structureName,
                id: selected?.structureId,
                guid: selected?.structureGuid,
              );
            },
          ),
          Gap(20.h),
          Container(
            constraints: BoxConstraints(minHeight: 600.h),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.compensation.box.path,
                      width: 20.w,
                      height: 20.w,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    Gap(8.w),
                    Text(
                      'Available Components',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
                Gap(24.h),
                const CreateCompensationPlanAvailableComponentsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
