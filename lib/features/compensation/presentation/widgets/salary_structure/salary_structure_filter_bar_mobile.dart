import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_filter_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

final _salaryStructureShowFiltersProvider = StateProvider<bool>((ref) => false);

class SalaryStructureFilterBarMobile extends ConsumerStatefulWidget {
  const SalaryStructureFilterBarMobile({this.onExport, this.isExporting = false, super.key});

  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<SalaryStructureFilterBarMobile> createState() => _SalaryStructureFilterBarMobileState();
}

class _SalaryStructureFilterBarMobileState extends ConsumerState<SalaryStructureFilterBarMobile> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(salaryStructureFilterProvider).searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final filterState = ref.watch(salaryStructureFilterProvider);
    final notifier = ref.read(salaryStructureFilterProvider.notifier);
    final showFilters = ref.watch(_salaryStructureShowFiltersProvider);

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
                  hintText: 'Search by structure name or code...',
                  filled: true,
                  fillColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
                  borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                  onChanged: notifier.setSearch,
                ),
              ),
              Gap(8.w),
              AppMobileButton(
                onPressed: widget.isExporting ? null : widget.onExport,
                isLoading: widget.isExporting,
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: isDark,
                isActive: showFilters,
                onTap: () => ref.read(_salaryStructureShowFiltersProvider.notifier).state = !showFilters,
              ),
            ],
          ),
          if (showFilters) ...[Gap(12.h), _FiltersPanel(isDark: isDark, filterState: filterState, notifier: notifier)],
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
  const _FiltersPanel({required this.isDark, required this.filterState, required this.notifier});

  final bool isDark;
  final SalaryStructureFilterState filterState;
  final SalaryStructureFilterNotifier notifier;

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
                onTap: notifier.reset,
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
          DigifySelectField<SalaryStructureStatus?>(
            hint: 'All Status',
            value: filterState.status,
            items: [null, ...SalaryStructureStatus.values],
            itemLabelBuilder: (item) => item?.label ?? 'All Status',
            onChanged: notifier.setStatus,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
        ],
      ),
    );
  }
}
