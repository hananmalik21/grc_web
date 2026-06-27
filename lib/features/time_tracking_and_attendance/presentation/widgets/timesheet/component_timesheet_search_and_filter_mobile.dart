import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/timesheet_enums.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_selection_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_org_structure_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimesheetSearchAndFilterMobile extends ConsumerStatefulWidget {
  const TimesheetSearchAndFilterMobile({super.key});

  @override
  ConsumerState<TimesheetSearchAndFilterMobile> createState() => _TimesheetSearchAndFilterMobileState();
}

class _TimesheetSearchAndFilterMobileState extends ConsumerState<TimesheetSearchAndFilterMobile> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(timesheetNotifierProvider).searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(timesheetNotifierProvider);
    final notifier = ref.read(timesheetNotifierProvider.notifier);

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
                  hintText: 'Search...',
                  filled: true,
                  fillColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
                  borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                  onChanged: notifier.setSearchQuery,
                ),
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: isDark,
                isActive: _showFilters,
                onTap: () => setState(() => _showFilters = !_showFilters),
              ),
            ],
          ),
          if (_showFilters) ...[
            Gap(12.h),
            _FiltersPanel(isDark: isDark, statusFilter: state.statusFilter, notifier: notifier),
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

class _FiltersPanel extends ConsumerWidget {
  const _FiltersPanel({required this.isDark, required this.statusFilter, required this.notifier});

  final bool isDark;
  final TimesheetStatus? statusFilter;
  final TimesheetNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onTap: () => _resetAll(ref),
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
          DigifySelectField<TimesheetStatus?>(
            hint: 'All Status',
            value: statusFilter,
            items: timesheetStatusFilterItems,
            itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
            onChanged: notifier.setStatusFilter,
            fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          ),
          Gap(12.h),
          const _OrgFiltersSection(),
        ],
      ),
    );
  }

  void _resetAll(WidgetRef ref) {
    notifier.setStatusFilter(null);
    _resetOrgFilters(ref);
  }

  void _resetOrgFilters(WidgetRef ref) {
    final org = ref.read(timesheetOrgStructureNotifierProvider).orgStructure;
    if (org != null) {
      ref.read(timesheetEnterpriseSelectionNotifierProvider(org.structureId).notifier).reset();
    }
    notifier.setOrgFilter(null, null);
  }
}

class _OrgFiltersSection extends ConsumerWidget {
  const _OrgFiltersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final orgState = ref.watch(timesheetOrgStructureNotifierProvider);
    final org = orgState.orgStructure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Organization',
              style: context.textTheme.headlineMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                fontSize: 12.sp,
              ),
            ),
            if (org != null)
              GestureDetector(
                onTap: () => _resetOrgFilters(ref),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reset',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                    ),
                    Gap(4.w),
                    DigifyAsset(
                      assetPath: Assets.icons.refreshGray.path,
                      width: 14.w,
                      height: 14.h,
                      color: AppColors.brandRed,
                    ),
                  ],
                ),
              ),
          ],
        ),
        Gap(8.h),
        if (org == null)
          _buildOrgLoadingPlaceholders(isDark)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8.h,
            children: _buildOrgCascade(ref, org.activeLevels, org.structureId),
          ),
      ],
    );
  }

  List<Widget> _buildOrgCascade(WidgetRef ref, List<OrgStructureLevel> levels, String structureId) {
    final notifier = ref.read(timesheetNotifierProvider.notifier);
    final selectionProvider = timesheetEnterpriseSelectionNotifierProvider(structureId);
    final selectionState = ref.watch(selectionProvider);

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;

      return DigifyStyleOrgLevelField(
        level: level,
        selectionProvider: selectionProvider,
        isEnabled: isEnabled,
        showLabel: false,
        onSelectionChanged: (levelCode, unit) {
          final id = unit?.orgUnitId;
          ref.read(selectionProvider.notifier).selectUnit(levelCode, unit);
          notifier.setOrgFilter(id?.toString(), levelCode);
        },
      );
    }).toList();
  }

  Widget _buildOrgLoadingPlaceholders(bool isDark) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(
        4,
        (_) => Skeletonizer(
          enabled: true,
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.inputBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
            ),
          ),
        ),
      ),
    );
  }

  void _resetOrgFilters(WidgetRef ref) {
    final org = ref.read(timesheetOrgStructureNotifierProvider).orgStructure;
    if (org != null) {
      ref.read(timesheetEnterpriseSelectionNotifierProvider(org.structureId).notifier).reset();
    }
    ref.read(timesheetNotifierProvider.notifier).setOrgFilter(null, null);
  }
}
