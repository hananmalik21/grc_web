import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/eligible_components_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/add_component_panel.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/component_adjustment_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewComponentsSection extends ConsumerWidget {
  const NewComponentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final formState = ref.watch(createAdjustmentFormProvider);
    final formNotifier = ref.read(createAdjustmentFormProvider.notifier);
    final employeeGuid = formState.selectedEmployee?.guid ?? '';
    final newComponents = ComponentAdjustment.sortedWithEarningFirst(formState.newComponentAdjustments);

    final eligibleAsync = ref.watch(eligiblePlanComponentsProvider(employeeGuid));
    final hasAvailable = eligibleAsync.when(
      data: (all) {
        final linkedIds = {
          ...formState.componentAdjustments.map((a) => a.componentId),
          ...newComponents.map((a) => a.componentId),
        };
        return all.any((c) => !linkedIds.contains(c.componentId));
      },
      loading: () => true,
      error: (_, _) => false,
    );

    if (!hasAvailable && newComponents.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.componentsIcon.path,
                width: 20.w,
                height: 20.w,
                color: AppColors.primary,
              ),
              Gap(8.w),
              Text(
                'Add New Components',
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(8.h),
          Text(
            'Select components from the eligible plan to add to this adjustment.',
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textTertiary,
            ),
          ),
          Gap(24.h),
          AddComponentPanel(employeeGuid: employeeGuid),
          if (newComponents.isNotEmpty) ...[
            Gap(20.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newComponents.length,
              separatorBuilder: (_, _) => Gap(16.h),
              itemBuilder: (context, index) => ComponentAdjustmentCard(
                index: index,
                adjustment: newComponents[index],
                notifier: formNotifier,
                isDark: isDark,
                isNew: true,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
