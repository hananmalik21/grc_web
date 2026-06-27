import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../providers/compensation_plans/compensation_plans_table_rows_provider.dart';

final _compensationPlansShowFiltersProvider = StateProvider<bool>((ref) => false);

class CompensationPlansFilterBarMobile extends ConsumerStatefulWidget {
  const CompensationPlansFilterBarMobile({this.onExport, this.isExporting = false, super.key});

  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<CompensationPlansFilterBarMobile> createState() => _CompensationPlansFilterBarMobileState();
}

class _CompensationPlansFilterBarMobileState extends ConsumerState<CompensationPlansFilterBarMobile> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(compensationPlansSearchFilterProvider));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final showFilters = ref.watch(_compensationPlansShowFiltersProvider);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: _searchController,
                  hintText: 'Search plans...',
                  onChanged: (value) =>
                      ref.read(compensationPlansFiltersControllerProvider.notifier).onSearchChanged(value),
                ),
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: isDark,
                isActive: showFilters,
                onTap: () => ref.read(_compensationPlansShowFiltersProvider.notifier).state = !showFilters,
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.downloadIcon.path,
                type: AppButtonType.primary,
                onPressed: widget.isExporting ? null : widget.onExport,
                isLoading: widget.isExporting,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
          if (showFilters) ...[Gap(12.h), _FiltersPanel(isDark: isDark)],
        ],
      ),
    );
  }
}

class _FilterToggleButton extends StatelessWidget {
  const _FilterToggleButton({required this.isDark, required this.isActive, required this.onTap});

  final bool isDark;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    final bgColor = isActive
        ? AppColors.primary.withValues(alpha: 0.1)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: DigifyAsset(
            assetPath: Assets.icons.employeeManagement.filterMain.path,
            width: 18,
            height: 18,
            color: isActive ? AppColors.primary : null,
          ),
        ),
      ),
    );
  }
}

class _FiltersPanel extends ConsumerWidget {
  const _FiltersPanel({required this.isDark});

  final bool isDark;

  String _labelForCode(List<CompensationPlansFilterOption> options, String code) {
    for (final option in options) {
      if (option.code == code) return option.label;
    }
    return code;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPlanTypeCode =
        ref.watch(compensationPlansPlanTypeCodeFilterProvider) ?? compensationPlansAllPlanTypesCode;
    final selectedCurrencyCode =
        ref.watch(compensationPlansCurrencyCodeFilterProvider) ?? compensationPlansAllCurrencyCode;
    final selectedStatus = ref.watch(compensationPlansStatusFilterProvider);
    final planTypeOptions = ref.watch(compensationPlansPlanTypeFilterOptionsProvider);
    final currencyOptions = ref.watch(compensationPlansCurrencyFilterOptionsProvider);
    final filtersNotifier = ref.read(compensationPlansFiltersControllerProvider.notifier);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(assetPath: Assets.icons.employeeManagement.filterSecondary.path, width: 16, height: 16),
                  Gap(6.w),
                  Text(
                    'Filters',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  filtersNotifier.onPlanTypeCodeChanged(null);
                  filtersNotifier.onCurrencyCodeChanged(null);
                  filtersNotifier.onStatusChanged(null);
                },
                child: Text(
                  'Clear All',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Gap(12.h),
          DigifySelectField<String>(
            hint: 'Type',
            value: selectedPlanTypeCode,
            items: planTypeOptions.map((o) => o.code).toList(),
            itemLabelBuilder: (item) => _labelForCode(planTypeOptions, item),
            onChanged: (value) {
              if (value == null) return;
              filtersNotifier.onPlanTypeCodeChanged(value == compensationPlansAllPlanTypesCode ? null : value);
            },
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          DigifySelectField<String>(
            hint: 'Currency',
            value: selectedCurrencyCode,
            items: currencyOptions.map((o) => o.code).toList(),
            itemLabelBuilder: (item) => _labelForCode(currencyOptions, item),
            onChanged: (value) {
              if (value == null) return;
              filtersNotifier.onCurrencyCodeChanged(value == compensationPlansAllCurrencyCode ? null : value);
            },
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          DigifySelectField<SalaryStructureStatus?>(
            hint: 'Status',
            value: selectedStatus,
            items: [null, ...SalaryStructureStatus.values],
            itemLabelBuilder: (item) => item?.label ?? 'All Status',
            onChanged: (value) => filtersNotifier.onStatusChanged(value),
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ],
      ),
    );
  }
}
