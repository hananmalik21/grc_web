import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_detail_component.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_component_frequency_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_component_pay_basis_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_state.dart';
import 'package:grc/features/compensation/presentation/screens/compensation_plans_tab/widgets/create_compensation_plan_component_flags_section.dart';

import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_salary_structure_details_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateCompensationPlanAvailableComponentsSection extends ConsumerWidget {
  const CreateCompensationPlanAvailableComponentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(createCompensationPlanProvider);
    final detailsAsync = ref.watch(createCompensationPlanSalaryStructureDetailsProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);

    if (planState.selectedSalaryStructureGuid == null || planState.selectedSalaryStructureId == null) {
      return const _CreateCompensationPlanComponentsEmptyState();
    }

    final details = detailsAsync.valueOrNull;
    final allComponents = details?.components ?? const <SalaryStructureDetailComponent>[];

    if (details != null && !planState.isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        notifier.syncComponentsFromSalaryStructureDetails(allComponents);
        notifier.prefillEligibilityFromSalaryStructureDetails(details);
      });
    }

    final planComponentIds = planState.isEditMode
        ? planState.selectedComponents.map((component) => component.componentId).toSet()
        : null;
    final components = planState.isEditMode && planComponentIds != null && planComponentIds.isNotEmpty
        ? allComponents.where((component) => planComponentIds.contains(component.componentId)).toList()
        : allComponents;

    if (detailsAsync.isLoading) {
      return Skeletonizer(
        enabled: true,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (context, index) => Gap(12.h),
          itemBuilder: (context, index) {
            return const _SalaryStructureComponentCardSkeleton();
          },
        ),
      );
    }

    if (detailsAsync.hasError && details == null) {
      return _CreateCompensationPlanComponentsErrorState(
        error: detailsAsync.error.toString(),
        onRetry: () => ref.invalidate(createCompensationPlanSalaryStructureDetailsProvider),
      );
    }

    if (components.isEmpty) {
      return const _CreateCompensationPlanComponentsEmptyState(
        message: 'No components defined for this salary structure.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: components.length,
          separatorBuilder: (context, index) => Gap(12.h),
          itemBuilder: (context, index) {
            final component = components[index];
            return _SalaryStructureComponentCard(component: component);
          },
        ),
      ],
    );
  }
}

class _SalaryStructureComponentCard extends ConsumerWidget {
  final SalaryStructureDetailComponent component;

  const _SalaryStructureComponentCard({required this.component});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final frequencyAsync = ref.watch(compensationPlanFrequencyLookupProvider);
    final frequencyItems = frequencyAsync.valueOrNull ?? const [];
    final payBasisAsync = ref.watch(compensationPlanPayBasisLookupProvider);
    final payBasisItems = payBasisAsync.valueOrNull ?? const [];
    final planState = ref.watch(createCompensationPlanProvider);
    final planNotifier = ref.read(createCompensationPlanProvider.notifier);
    final selectedFrequency = planState.componentFrequencies[component.componentId];
    final selectedPayBasis = planState.componentPayBases[component.componentId];
    final settings = CreateCompensationPlanComponentSettings.forComponentCard(
      planState: planState,
      component: component,
    );

    if (selectedFrequency == null && frequencyItems.isNotEmpty) {
      final initialCode = planState.initialComponentFrequencyCodes[component.componentId];
      if (initialCode != null) {
        final match = frequencyItems.where((v) => v.valueCode == initialCode).firstOrNull;
        if (match != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            planNotifier.setComponentFrequency(component.componentId, match);
          });
        }
      }
    }

    if (selectedPayBasis == null && payBasisItems.isNotEmpty) {
      final initialCode = planState.initialComponentPayBaseCodes[component.componentId];
      if (initialCode != null) {
        final match = payBasisItems.where((v) => v.valueCode == initialCode).firstOrNull;
        if (match != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            planNotifier.setComponentPayBasis(component.componentId, match);
          });
        }
      }
    }

    final hasDefaultValue = component.defaultValue != null;
    final hasMinValue = component.minValue != null;
    final hasMaxValue = component.maxValue != null;
    final hasAnyValue = hasDefaultValue || hasMinValue || hasMaxValue;

    final hasComponentType = component.uiComponentType != '-';
    final hasCategory = component.uiCategory != '-';
    final hasType = component.uiType != '-';
    final hasTags = hasComponentType || hasCategory || hasType;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: code badge + status ─────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
                ),
                child: Text(
                  component.uiCode,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 11.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              if (component.component?.currencyCode?.isNotEmpty == true) ...[
                Gap(8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.3) : AppColors.infoBg,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    component.component!.currencyCode!,
                    style: context.textTheme.labelMedium?.copyWith(
                      fontSize: 11.sp,
                      color: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              DigifyStatusCapsule(status: settings.isActive ? 'Active' : 'Inactive'),
            ],
          ),
          Gap(8.h),
          // ── Component name ──────────────────────────────────
          Text(
            component.uiTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: context.textTheme.titleMedium?.copyWith(
              fontSize: 14.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          // ── Tags ───────────────────────────────────────────
          if (hasTags) ...[
            Gap(10.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                if (hasComponentType)
                  DigifyCapsule(
                    label: component.uiComponentType,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    backgroundColor: isDark ? AppColors.purpleBg.withValues(alpha: 0.12) : AppColors.purpleBg,
                    textColor: isDark ? AppColors.purple.withValues(alpha: 0.85) : AppColors.purpleText,
                  ),
                if (hasCategory)
                  DigifyCapsule(
                    label: component.uiCategory,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    backgroundColor: isDark ? AppColors.greenBg.withValues(alpha: 0.12) : AppColors.greenBg,
                    textColor: isDark ? AppColors.success.withValues(alpha: 0.85) : AppColors.greenText,
                  ),
                if (hasType)
                  DigifyCapsule(
                    label: component.uiType,
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                    textColor: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
                  ),
              ],
            ),
          ],
          // ── Value summary ───────────────────────────────────
          if (hasAnyValue) ...[
            Gap(10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  if (hasDefaultValue) ...[
                    _ValueItem(label: 'Default', value: '${component.defaultValue}', isDark: isDark, context: context),
                  ],
                  if (hasDefaultValue && (hasMinValue || hasMaxValue)) _ValueDivider(isDark: isDark),
                  if (hasMinValue) ...[
                    _ValueItem(label: 'Min', value: '${component.minValue}', isDark: isDark, context: context),
                  ],
                  if (hasMinValue && hasMaxValue) _ValueDivider(isDark: isDark),
                  if (hasMaxValue) ...[
                    _ValueItem(label: 'Max', value: '${component.maxValue}', isDark: isDark, context: context),
                  ],
                ],
              ),
            ),
          ],
          // ── Description ─────────────────────────────────────
          if (component.component?.description?.trim().isNotEmpty == true) ...[
            Gap(8.h),
            Text(
              component.component!.description!,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ComponentFrequencyDropdown(
                  items: frequencyItems,
                  value: selectedFrequency,
                  isLoading: frequencyAsync.isLoading,
                  onChanged: (value) => planNotifier.setComponentFrequency(component.componentId, value),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _ComponentPayBasisDropdown(
                  items: payBasisItems,
                  value: selectedPayBasis,
                  isLoading: payBasisAsync.isLoading,
                  onChanged: (value) => planNotifier.setComponentPayBasis(component.componentId, value),
                ),
              ),
            ],
          ),
          Gap(12.h),
          CreateCompensationPlanComponentFlagsSection(
            settings: settings,
            onChanged:
                ({
                  bool? recurring,
                  bool? optional,
                  bool? isActive,
                  bool? pensionable,
                  bool? statutory,
                  bool? includeInCtc,
                  bool? prorated,
                  bool? taxable,
                  bool? amortizable,
                }) {
                  planNotifier.setComponentSettings(
                    component.componentId,
                    recurring: recurring,
                    optional: optional,
                    isActive: isActive,
                    pensionable: pensionable,
                    statutory: statutory,
                    includeInCtc: includeInCtc,
                    prorated: prorated,
                    taxable: taxable,
                    amortizable: amortizable,
                  );
                },
          ),
        ],
      ),
    );
  }
}

class _ComponentFrequencyDropdown extends StatelessWidget {
  final List<CompLookupValue> items;
  final CompLookupValue? value;
  final ValueChanged<CompLookupValue?> onChanged;
  final bool isLoading;

  const _ComponentFrequencyDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DigifySelectFieldWithLabel<CompLookupValue>(
      label: 'Frequency',
      hint: isLoading ? 'Loading...' : 'Select frequency',
      isRequired: true,
      items: items,
      value: value,
      itemLabelBuilder: (item) => item.valueName,
      onChanged: onChanged,
    );
  }
}

class _ComponentPayBasisDropdown extends StatelessWidget {
  final List<CompLookupValue> items;
  final CompLookupValue? value;
  final ValueChanged<CompLookupValue?> onChanged;
  final bool isLoading;

  const _ComponentPayBasisDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return DigifySelectFieldWithLabel<CompLookupValue>(
      label: 'Pay Basis',
      hint: isLoading ? 'Loading...' : 'Select pay basis',
      items: items,
      value: value,
      itemLabelBuilder: (item) => item.valueName,
      onChanged: onChanged,
    );
  }
}

class _ValueItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final BuildContext context;

  const _ValueItem({required this.label, required this.value, required this.isDark, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: ctx.textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              letterSpacing: 0.4,
            ),
          ),
          Gap(2.h),
          Text(
            value,
            style: ctx.textTheme.labelLarge?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueDivider extends StatelessWidget {
  final bool isDark;

  const _ValueDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
    );
  }
}

class _SalaryStructureComponentCardSkeleton extends StatelessWidget {
  const _SalaryStructureComponentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 14.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                    Gap(8.w),
                    Container(
                      width: 56.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(12.w),
              Container(
                width: 58.w,
                height: 22.h,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(999.r)),
              ),
            ],
          ),
          Gap(8.h),
          Row(
            children: [
              Container(
                width: 70.w,
                height: 12.h,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
              ),
              Gap(12.w),
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
              ),
              Gap(12.w),
              Container(
                width: 60.w,
                height: 12.h,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
              ),
            ],
          ),
          Gap(10.h),
          Container(
            width: double.infinity,
            height: 14.h,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
          ),
          Gap(6.h),
          Container(
            width: 180.w,
            height: 14.h,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
          ),
        ],
      ),
    );
  }
}

class _CreateCompensationPlanComponentsErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _CreateCompensationPlanComponentsErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Failed to load components: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            Gap(12.h),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _CreateCompensationPlanComponentsEmptyState extends StatelessWidget {
  final String message;

  const _CreateCompensationPlanComponentsEmptyState({this.message = 'Select salary structure to view components'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.compensation.layers.path,
            width: 28.w,
            height: 28.w,
            color: AppColors.textSecondary,
          ),
          Gap(12.h),
          Text(
            message,
            style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          Gap(6.h),
          Text(
            'Salary structure details will appear here once a structure is selected.',
            style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
