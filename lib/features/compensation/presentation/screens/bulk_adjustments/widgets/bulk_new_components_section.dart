import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_add_component_panel_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_eligible_plans_provider.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_add_component_panel.dart';
import 'package:grc/features/compensation/presentation/utils/bulk_eligible_plans_intersection.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_component_adjustment_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BulkNewComponentsSection extends ConsumerWidget {
  const BulkNewComponentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(bulkAdjustmentsFormProvider);
    final newGroups = formState.newFromPlanActiveGroups;
    final panelState = ref.watch(bulkAddComponentPanelProvider);
    final eligibleAsync = ref.watch(bulkEligiblePlansByEmployeeProvider);

    final linkedIds = {for (final group in formState.activeGroups) group.componentId};

    final hasAvailable = eligibleAsync.when(
      data: (entries) {
        final plans = intersectEligiblePlansAcrossEmployees(entries);
        for (final plan in plans) {
          final shared = intersectPlanComponentsAcrossEmployees(entries: entries, planId: plan.planId);
          if (shared.any((c) => !linkedIds.contains(c.componentId))) return true;
        }
        return false;
      },
      loading: () => true,
      error: (_, _) => false,
    );

    if (!hasAvailable && newGroups.isEmpty && !panelState.isLoadingPlans) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 24.h),
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
                localizations.bulkAdjustmentsNewComponentsTitle,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(8.h),
          Text(
            localizations.bulkAdjustmentsNewComponentsSubtitle,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textTertiary,
            ),
          ),
          Gap(24.h),
          const BulkAddComponentPanel(),
          if (newGroups.isNotEmpty) ...[
            Gap(20.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newGroups.length,
              separatorBuilder: (_, _) => Gap(16.h),
              itemBuilder: (context, index) => BulkComponentAdjustmentCard(group: newGroups[index], isDark: isDark),
            ),
          ],
        ],
      ),
    );
  }
}
