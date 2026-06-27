import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _employeeCompensationShowFiltersProvider = StateProvider<bool>((ref) => false);

class EmployeeCompensationFilterBarMobile extends ConsumerWidget {
  const EmployeeCompensationFilterBarMobile({
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedDepartment,
    required this.selectedRegion,
    required this.departmentOptions,
    required this.regionOptions,
    required this.onDepartmentChanged,
    required this.onRegionChanged,
    required this.onExportPressed,
    this.isExporting = false,
    super.key,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String selectedDepartment;
  final String selectedRegion;
  final List<String> departmentOptions;
  final List<String> regionOptions;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onRegionChanged;
  final VoidCallback onExportPressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final showFilters = ref.watch(_employeeCompensationShowFiltersProvider);

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
                  controller: searchController,
                  hintText: 'Search employees...',
                  onChanged: onSearchChanged,
                ),
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: isDark,
                isActive: showFilters,
                onTap: () => ref.read(_employeeCompensationShowFiltersProvider.notifier).state = !showFilters,
              ),
              Gap(8.w),
              AppMobileButton(
                svgPath: Assets.icons.downloadIcon.path,
                onPressed: isExporting ? null : onExportPressed,
                isLoading: isExporting,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
          if (showFilters) ...[
            Gap(12.h),
            _FiltersPanel(
              isDark: isDark,
              selectedDepartment: selectedDepartment,
              selectedRegion: selectedRegion,
              departmentOptions: departmentOptions,
              regionOptions: regionOptions,
              onDepartmentChanged: onDepartmentChanged,
              onRegionChanged: onRegionChanged,
            ),
          ],
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

class _FiltersPanel extends StatelessWidget {
  const _FiltersPanel({
    required this.isDark,
    required this.selectedDepartment,
    required this.selectedRegion,
    required this.departmentOptions,
    required this.regionOptions,
    required this.onDepartmentChanged,
    required this.onRegionChanged,
  });

  final bool isDark;
  final String selectedDepartment;
  final String selectedRegion;
  final List<String> departmentOptions;
  final List<String> regionOptions;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onRegionChanged;

  @override
  Widget build(BuildContext context) {
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
                  onDepartmentChanged(null);
                  onRegionChanged(null);
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
            hint: 'Department',
            value: selectedDepartment,
            items: departmentOptions,
            itemLabelBuilder: (item) => item,
            onChanged: onDepartmentChanged,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          DigifySelectField<String>(
            hint: 'Region',
            value: selectedRegion,
            items: regionOptions,
            itemLabelBuilder: (item) => item,
            onChanged: onRegionChanged,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ],
      ),
    );
  }
}
