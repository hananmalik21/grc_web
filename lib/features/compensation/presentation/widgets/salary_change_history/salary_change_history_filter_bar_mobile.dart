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

final _salaryChangeHistoryShowFiltersProvider = StateProvider<bool>((ref) => false);

class SalaryChangeHistoryFilterBarMobile extends ConsumerWidget {
  final ValueChanged<String> onSearchChanged;
  final SalaryChangeHistoryStatus selectedStatus;
  final ValueChanged<SalaryChangeHistoryStatus?> onStatusChanged;
  final SalaryChangeHistoryType selectedType;
  final ValueChanged<SalaryChangeHistoryType?> onTypeChanged;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final ValueChanged<DateTime?> onEffectiveFromChanged;
  final ValueChanged<DateTime?> onEffectiveToChanged;
  final VoidCallback onApplyFilter;
  final VoidCallback onRemoveFilter;
  final VoidCallback onExportPressed;
  final bool isExporting;

  const SalaryChangeHistoryFilterBarMobile({
    super.key,
    required this.onSearchChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.selectedType,
    required this.onTypeChanged,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.onEffectiveFromChanged,
    required this.onEffectiveToChanged,
    required this.onApplyFilter,
    required this.onRemoveFilter,
    required this.onExportPressed,
    this.isExporting = false,
  });

  bool get _hasDateFilter => effectiveFrom != null || effectiveTo != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final showFilters = ref.watch(_salaryChangeHistoryShowFiltersProvider);

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
                  hintText: 'Search by employee, department, or reason',
                  onChanged: onSearchChanged,
                ),
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: isDark,
                isActive: showFilters,
                onTap: () => ref.read(_salaryChangeHistoryShowFiltersProvider.notifier).state = !showFilters,
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
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
              selectedType: selectedType,
              onTypeChanged: onTypeChanged,
              effectiveFrom: effectiveFrom,
              effectiveTo: effectiveTo,
              onEffectiveFromChanged: onEffectiveFromChanged,
              onEffectiveToChanged: onEffectiveToChanged,
              onApplyFilter: onApplyFilter,
              onRemoveFilter: onRemoveFilter,
              hasDateFilter: _hasDateFilter,
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
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.selectedType,
    required this.onTypeChanged,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.onEffectiveFromChanged,
    required this.onEffectiveToChanged,
    required this.onApplyFilter,
    required this.onRemoveFilter,
    required this.hasDateFilter,
  });

  final bool isDark;
  final SalaryChangeHistoryStatus selectedStatus;
  final ValueChanged<SalaryChangeHistoryStatus?> onStatusChanged;
  final SalaryChangeHistoryType selectedType;
  final ValueChanged<SalaryChangeHistoryType?> onTypeChanged;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final ValueChanged<DateTime?> onEffectiveFromChanged;
  final ValueChanged<DateTime?> onEffectiveToChanged;
  final VoidCallback onApplyFilter;
  final VoidCallback onRemoveFilter;
  final bool hasDateFilter;

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
                  onStatusChanged(null);
                  onTypeChanged(null);
                  onEffectiveFromChanged(null);
                  onEffectiveToChanged(null);
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
          DigifySelectField<SalaryChangeHistoryStatus>(
            hint: 'Status',
            value: selectedStatus,
            items: SalaryChangeHistoryStatus.values,
            itemLabelBuilder: (item) => item.label,
            onChanged: onStatusChanged,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          DigifySelectField<SalaryChangeHistoryType>(
            hint: 'Type',
            value: selectedType,
            items: SalaryChangeHistoryType.values,
            itemLabelBuilder: (item) => item.label,
            onChanged: onTypeChanged,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          DigifyDateField(
            label: 'Effective From',
            hintText: 'Select start date',
            isRequired: false,
            initialDate: effectiveFrom,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateSelected: (date) => onEffectiveFromChanged(date),
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(8.h),
          DigifyDateField(
            label: 'Effective To',
            hintText: 'Select end date',
            isRequired: false,
            initialDate: effectiveTo,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateSelected: (date) => onEffectiveToChanged(date),
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(12.h),
          Row(
            children: [
              AppButton(label: 'Apply', type: AppButtonType.primary, onPressed: onApplyFilter),
              if (hasDateFilter) ...[Gap(8.w), AppButton.outline(label: 'Remove', onPressed: onRemoveFilter)],
            ],
          ),
        ],
      ),
    );
  }
}
