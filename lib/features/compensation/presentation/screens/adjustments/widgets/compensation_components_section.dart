import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/compensation_components_table.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/compensation_components_table_skeleton.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/component_adjustment_card.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/new_components_section.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationComponentsSection extends ConsumerWidget {
  const CompensationComponentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final formState = ref.watch(createAdjustmentFormProvider);
    final formNotifier = ref.read(createAdjustmentFormProvider.notifier);
    final employeeGuid = formState.selectedEmployee?.guid ?? '';

    final existingActive = formState.componentAdjustments.where((a) => !a.deleteFlag).toList();

    return Column(
      children: [
        // ── Current assigned components ──────────────────────────────
        _SectionCard(
          isDark: isDark,
          icon: Assets.icons.departmentMetric3Icon.path,
          title: 'Compensation Components Management',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16.w,
                runSpacing: 8.h,
                children: [
                  Text('Current Compensation Components', style: context.textTheme.titleSmall),
                  Text(
                    formState.isLoadingComponents ? 'Fetching...' : '${existingActive.length} Active Components',
                    style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.textTertiary),
                  ),
                ],
              ),
              Gap(12.h),
              if (formState.isLoadingComponents)
                CompensationComponentsTableSkeleton(isDark: isDark)
              else if (formState.componentAdjustments.isEmpty)
                TableEmptyState(
                  title: 'No Components Found',
                  message: 'There are no compensation components assigned to this employee.',
                  iconPath: Assets.icons.compensation.components.path,
                  height: 250.h,
                )
              else
                CompensationComponentsTable(adjustments: existingActive, isDark: isDark),
            ],
          ),
        ),

        // ── Modify existing components ───────────────────────────────
        if (!formState.isLoadingComponents && existingActive.isNotEmpty) ...[
          Gap(24.h),
          _SectionCard(
            isDark: isDark,
            icon: Assets.icons.editIconPurple.path,
            title: 'Modify Component Values',
            subtitle:
                'Adjust the values of existing compensation components. '
                'You can increase, decrease, or set new values for each component individually.',
            child: _ComponentList(adjustments: existingActive, notifier: formNotifier, isDark: isDark),
          ),
        ],

        // ── Add new components ───────────────────────────────────────
        if (!formState.isLoadingComponents && employeeGuid.isNotEmpty) ...[Gap(24.h), const NewComponentsSection()],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String icon;
  final String title;
  final String? subtitle;
  final Widget child;

  const _SectionCard({
    required this.isDark,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyAsset(assetPath: icon, width: 20.w, height: 20.w, color: AppColors.primary),
              Gap(8.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 18.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            Gap(8.h),
            Text(
              subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textTertiary,
              ),
            ),
          ],
          Gap(24.h),
          child,
        ],
      ),
    );
  }
}

class _ComponentList extends StatelessWidget {
  final List<ComponentAdjustment> adjustments;
  final CreateAdjustmentFormNotifier notifier;
  final bool isDark;

  const _ComponentList({required this.adjustments, required this.notifier, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: adjustments.length,
      separatorBuilder: (_, _) => Gap(16.h),
      itemBuilder: (context, index) => ComponentAdjustmentCard(
        index: index,
        adjustment: adjustments[index],
        notifier: notifier,
        isDark: isDark,
        isNew: false,
      ),
    );
  }
}
