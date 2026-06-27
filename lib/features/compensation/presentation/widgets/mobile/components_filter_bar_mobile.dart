import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/compensation_enums.dart'; // ComponentStatus
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_filter_provider.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_lookups_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _componentsShowFiltersProvider = StateProvider<bool>((ref) => false);

class ComponentsFilterBarMobile extends ConsumerStatefulWidget {
  const ComponentsFilterBarMobile({this.onExport, this.isExporting = false, super.key});

  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<ComponentsFilterBarMobile> createState() => _ComponentsFilterBarMobileState();
}

class _ComponentsFilterBarMobileState extends ConsumerState<ComponentsFilterBarMobile> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final showFilters = ref.watch(_componentsShowFiltersProvider);
    final filterState = ref.watch(componentsFilterProvider);
    final filterNotifier = ref.read(componentsFilterProvider.notifier);

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
                  hintText: 'Search components...',
                  onChanged: filterNotifier.setSearch,
                ),
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.employeeManagement.filterMain.path,
                type: AppButtonType.outline,
                onPressed: () => ref.read(_componentsShowFiltersProvider.notifier).state = !showFilters,
                backgroundColor: showFilters ? AppColors.primary.withValues(alpha: 0.1) : null,
                borderColor: showFilters ? AppColors.primary : null,
                foregroundColor: showFilters
                    ? AppColors.primary
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
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
          if (showFilters) ...[
            Gap(12.h),
            _FiltersPanel(
              isDark: isDark,
              filterState: filterState,
              filterNotifier: filterNotifier,
              onClearAll: () {
                _searchController.clear();
                filterNotifier.reset();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _FiltersPanel extends ConsumerWidget {
  const _FiltersPanel({
    required this.isDark,
    required this.filterState,
    required this.filterNotifier,
    required this.onClearAll,
  });

  final bool isDark;
  final ComponentsFilterState filterState;
  final ComponentsFilterNotifier filterNotifier;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(componentCategoryLookupProvider);
    final calculationMethodsAsync = ref.watch(componentCalculationMethodLookupProvider);

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
                onTap: onClearAll,
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
          categoriesAsync.when(
            data: (categories) => DigifySelectField<String?>(
              hint: 'Category',
              value: filterState.category,
              items: [null, ...categories.map((e) => e.valueCode)],
              itemLabelBuilder: (code) =>
                  code == null ? 'All Categories' : categories.firstWhere((e) => e.valueCode == code).valueName,
              onChanged: filterNotifier.setCategory,
              fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            ),
            loading: () => DigifySelectField<String>(hint: 'Loading...', items: const [], itemLabelBuilder: (v) => v),
            error: (_, _) => DigifySelectField<String>(hint: 'Error', items: const [], itemLabelBuilder: (v) => v),
          ),
          Gap(8.h),
          DigifySelectField<ComponentStatus?>(
            hint: 'Status',
            value: filterState.status,
            items: [null, ...ComponentStatus.values],
            itemLabelBuilder: (status) => status == null ? 'All Statuses' : status.label,
            onChanged: filterNotifier.setStatus,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          calculationMethodsAsync.when(
            data: (methods) => DigifySelectField<String?>(
              hint: 'Calculation Method',
              value: filterState.calculationMethod,
              items: [null, ...methods.map((e) => e.valueCode)],
              itemLabelBuilder: (code) =>
                  code == null ? 'All Methods' : methods.firstWhere((e) => e.valueCode == code).valueName,
              onChanged: filterNotifier.setCalculationMethod,
              fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            ),
            loading: () => DigifySelectField<String>(hint: 'Loading...', items: const [], itemLabelBuilder: (v) => v),
            error: (_, _) => DigifySelectField<String>(hint: 'Error', items: const [], itemLabelBuilder: (v) => v),
          ),
        ],
      ),
    );
  }
}
