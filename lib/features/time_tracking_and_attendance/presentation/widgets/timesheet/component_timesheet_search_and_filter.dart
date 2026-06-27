import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/timesheet_enums.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_selection_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_org_structure_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimesheetSearchAndFilter extends ConsumerStatefulWidget {
  const TimesheetSearchAndFilter({super.key});

  @override
  ConsumerState<TimesheetSearchAndFilter> createState() => _TimesheetSearchAndFilterState();
}

class _TimesheetSearchAndFilterState extends ConsumerState<TimesheetSearchAndFilter> {
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: DigifyTextField.search(
                  controller: _searchController,
                  hintText: 'Search...',
                  onChanged: notifier.setSearchQuery,
                ),
              ),
              Gap(16.w),
              SizedBox(
                width: 180.w,
                child: DigifySelectField<TimesheetStatus?>(
                  hint: 'All Status',
                  value: state.statusFilter,
                  items: timesheetStatusFilterItems,
                  itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                  onChanged: notifier.setStatusFilter,
                ),
              ),
            ],
          ),
          Gap(16.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.outline(
              label: 'Filters',
              svgPath: Assets.icons.employeeManagement.filterMain.path,
              onPressed: () => setState(() => _showFilters = !_showFilters),
            ),
          ),
          if (_showFilters) ...[Gap(16.h), _AdvancedFiltersPanel(isDark: isDark)],
        ],
      ),
    );
  }
}

class _AdvancedFiltersPanel extends ConsumerWidget {
  const _AdvancedFiltersPanel({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.r),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(assetPath: Assets.icons.employeeManagement.filterSecondary.path, width: 20, height: 20),
                  Gap(8.w),
                  Text(
                    'Advanced Filters',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _resetOrgFilters(ref),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reset filters',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                    ),
                    Gap(6.w),
                    DigifyAsset(
                      assetPath: Assets.icons.refreshGray.path,
                      width: 16.w,
                      height: 16.h,
                      color: AppColors.brandRed,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(16.h),
          Wrap(spacing: 14.w, runSpacing: 14.h, children: _buildOrgFilters(ref)),
        ],
      ),
    );
  }

  List<Widget> _buildOrgFilters(WidgetRef ref) {
    final notifier = ref.read(timesheetNotifierProvider.notifier);
    final orgState = ref.watch(timesheetOrgStructureNotifierProvider);
    final org = orgState.orgStructure;

    if (org == null) return _buildLoadingPlaceholders();

    final selectionProvider = timesheetEnterpriseSelectionNotifierProvider(org.structureId);
    final selectionState = ref.watch(selectionProvider);
    final levels = org.activeLevels;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;

      return SizedBox(
        width: 180.w,
        child: DigifyStyleOrgLevelField(
          level: level,
          selectionProvider: selectionProvider,
          isEnabled: isEnabled,
          showLabel: false,
          onSelectionChanged: (levelCode, unit) {
            final id = unit?.orgUnitId;
            ref.read(selectionProvider.notifier).selectUnit(levelCode, unit);
            if (id == null) return;
            notifier.setOrgFilter(id.toString(), levelCode);
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildLoadingPlaceholders() {
    return List.generate(
      4,
      (_) => SizedBox(
        width: 180.w,
        height: 48.h,
        child: Skeletonizer(
          enabled: true,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
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
