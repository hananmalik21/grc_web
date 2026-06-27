import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_filter_org_param_provider.dart';
import 'package:grc/features/employee_management/domain/models/assignment_status_enum.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_filters_state.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_org_structure_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/employee_all_positions_selection_dialog.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/job_family_selection_dialog.dart'
    as emp_job_family_dialog;
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/job_level_selection_dialog.dart'
    as emp_job_level_dialog;
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/grade_selection_dialog.dart'
    as emp_grade_dialog;
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeSearchAndActionsMobile extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const EmployeeSearchAndActionsMobile({super.key, required this.localizations, required this.isDark});

  @override
  ConsumerState<EmployeeSearchAndActionsMobile> createState() => _EmployeeSearchAndActionsMobileState();
}

class _EmployeeSearchAndActionsMobileState extends ConsumerState<EmployeeSearchAndActionsMobile> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    final isDark = widget.isDark;
    final showFilters = ref.watch(manageEmployeesShowFiltersProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);

    void onExport() {
      final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
      ref
          .read(spreadsheetExportProvider.notifier)
          .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.employees(localizations));
    }

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
                  hintText: localizations.searchByNameOrEmployeeNumber,
                  onChanged: (value) => ref.read(manageEmployeesListProvider.notifier).setSearchQueryInput(value),
                  onSubmitted: (value) => ref.read(manageEmployeesListProvider.notifier).search(value),
                ),
              ),
              Gap(8.w),
              _FilterToggleButton(
                isDark: isDark,
                isActive: showFilters,
                onTap: () => ref.read(manageEmployeesShowFiltersProvider.notifier).state = !showFilters,
              ),
              Gap(8.w),
              Tooltip(
                message: localizations.export,
                child: AppMobileButton(
                  onPressed: isExporting ? null : onExport,
                  isLoading: isExporting,
                  svgPath: Assets.icons.downloadIcon.path,
                  type: AppButtonType.primary,
                  backgroundColor: AppColors.shiftExportButton,
                  foregroundColor: Colors.white,
                ),
              ),
              Gap(8.w),
              Tooltip(
                message: localizations.import,
                child: AppMobileButton(
                  onPressed: () {},
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
                  type: AppButtonType.primary,
                  backgroundColor: AppColors.shiftUploadButton,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          if (showFilters) ...[Gap(12.h), _MobileFiltersPanel(localizations: localizations, isDark: isDark)],
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

class _MobileFiltersPanel extends ConsumerWidget {
  const _MobileFiltersPanel({required this.localizations, required this.isDark});

  final AppLocalizations localizations;
  final bool isDark;

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
                    localizations.advancedFilters,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  ref.read(manageEmployeesFiltersProvider.notifier).clearAll();
                  final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
                  if (enterpriseId != null) {
                    final param = ref.read(manageEmployeesFilterOrgParamProvider(enterpriseId));
                    if (param != null) {
                      ref
                          .read(
                            employeeEnterpriseSelectionNotifierProvider((
                              levels: param.levels,
                              structureId: param.structureId,
                            )).notifier,
                          )
                          .reset();
                    }
                  }
                  ref.read(manageEmployeesListProvider.notifier).refresh();
                },
                child: Text(
                  localizations.clearAll,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Gap(12.h),
          _MobileFilterDropdownsSection(
            localizations: localizations,
            isDark: isDark,
            onEnsureOrgStructureLoaded: (int enterpriseId) {
              ref
                  .read(manageEmployeesOrgStructureNotifierProvider(enterpriseId).notifier)
                  .fetchLevelsByEnterpriseId(enterpriseId);
            },
          ),
        ],
      ),
    );
  }
}

class _MobileFilterDropdownsSection extends ConsumerStatefulWidget {
  const _MobileFilterDropdownsSection({
    required this.localizations,
    required this.isDark,
    required this.onEnsureOrgStructureLoaded,
  });

  final AppLocalizations localizations;
  final bool isDark;
  final void Function(int enterpriseId) onEnsureOrgStructureLoaded;

  @override
  ConsumerState<_MobileFilterDropdownsSection> createState() => _MobileFilterDropdownsSectionState();
}

class _MobileFilterDropdownsSectionState extends ConsumerState<_MobileFilterDropdownsSection> {
  int? _lastEnterpriseIdForOrgLoad;

  @override
  Widget build(BuildContext context) {
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final param = enterpriseId != null ? ref.watch(manageEmployeesFilterOrgParamProvider(enterpriseId)) : null;
    final filters = ref.watch(manageEmployeesFiltersProvider);

    if (enterpriseId != null && _lastEnterpriseIdForOrgLoad != enterpriseId) {
      _lastEnterpriseIdForOrgLoad = enterpriseId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onEnsureOrgStructureLoaded(enterpriseId);
      });
    }

    final jobFamilyState = ref.watch(employeeJobFamilyNotifierProvider(enterpriseId));
    final jobLevelState = ref.watch(employeeJobLevelNotifierProvider(enterpriseId));
    final gradeState = ref.watch(employeeGradeNotifierProvider(enterpriseId));
    final positionState = ref.watch(employeePositionNotifierProvider(enterpriseId));

    if (jobFamilyState.items.isEmpty && !jobFamilyState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(employeeJobFamilyNotifierProvider(enterpriseId).notifier).loadFirstPage();
      });
    }
    if (jobLevelState.items.isEmpty && !jobLevelState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(employeeJobLevelNotifierProvider(enterpriseId).notifier).loadFirstPage();
      });
    }
    if (gradeState.items.isEmpty && !gradeState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(employeeGradeNotifierProvider(enterpriseId).notifier).loadFirstPage();
      });
    }
    if (positionState.items.isEmpty && !positionState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(employeePositionNotifierProvider(enterpriseId).notifier).loadFirstPage();
      });
    }

    final positionItems = positionState.items;
    final jobFamilyItems = jobFamilyState.items;
    final jobLevelItems = jobLevelState.items;
    final gradeItems = gradeState.items;

    final listNotifier = ref.read(manageEmployeesListProvider.notifier);
    final filtersNotifier = ref.read(manageEmployeesFiltersProvider.notifier);

    void applyFiltersAndRefresh() => listNotifier.refresh();

    return Column(
      children: [
        DigifySelectField<AssignmentStatus?>(
          hint: widget.localizations.allStatuses,
          value: filters.assignmentStatus,
          items: [null, AssignmentStatus.inactive, AssignmentStatus.active, AssignmentStatus.probation],
          itemLabelBuilder: (status) {
            if (status == null) return widget.localizations.allStatuses;
            switch (status) {
              case AssignmentStatus.active:
                return widget.localizations.active;
              case AssignmentStatus.inactive:
                return widget.localizations.inactive;
              case AssignmentStatus.probation:
                return widget.localizations.reviewProbation;
              default:
                return status.raw;
            }
          },
          onChanged: (status) {
            filtersNotifier.setAssignmentStatus(status);
            applyFiltersAndRefresh();
          },
          fillColor: widget.isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        ),
        Gap(8.h),
        if (enterpriseId != null && param == null) ..._buildOrgLoadingPlaceholders(),
        if (param != null) ..._buildOrgCascade(param, filtersNotifier, applyFiltersAndRefresh),
        Gap(8.h),
        _MobileFilterSelectionField(
          label: filters.positionId == null
              ? widget.localizations.allPositions
              : positionItems
                    .firstWhere((p) => p.id == filters.positionId, orElse: () => positionItems.first)
                    .titleEnglish,
          isDark: widget.isDark,
          onTap: () async {
            final selectedInitial = filters.positionId == null
                ? null
                : positionItems.firstWhere((p) => p.id == filters.positionId, orElse: () => positionItems.first);
            final selected = await EmployeeAllPositionsSelectionDialog.show(
              context,
              enterpriseId: enterpriseId ?? 0,
              selectedPosition: selectedInitial,
            );
            final newId = selected?.id;
            if (newId == filters.positionId) return;
            filtersNotifier.setPositionId(newId);
            applyFiltersAndRefresh();
          },
        ),
        Gap(8.h),
        _MobileFilterSelectionField(
          label: filters.jobFamilyId == null
              ? widget.localizations.allJobFamilies
              : jobFamilyItems
                    .firstWhere((j) => j.id == filters.jobFamilyId, orElse: () => jobFamilyItems.first)
                    .nameEnglish,
          isDark: widget.isDark,
          onTap: () async {
            final selectedInitial = filters.jobFamilyId == null
                ? null
                : jobFamilyItems.firstWhere((j) => j.id == filters.jobFamilyId, orElse: () => jobFamilyItems.first);
            final selected = await emp_job_family_dialog.JobFamilySelectionDialog.show(
              context,
              enterpriseId: enterpriseId ?? 0,
              selectedJobFamily: selectedInitial,
            );
            final newId = selected?.id;
            if (newId == filters.jobFamilyId) return;
            filtersNotifier.setJobFamilyId(newId);
            applyFiltersAndRefresh();
          },
        ),
        Gap(8.h),
        _MobileFilterSelectionField(
          label: filters.jobLevelId == null
              ? widget.localizations.allJobLevels
              : jobLevelItems.firstWhere((j) => j.id == filters.jobLevelId, orElse: () => jobLevelItems.first).nameEn,
          isDark: widget.isDark,
          onTap: () async {
            final selectedInitial = filters.jobLevelId == null
                ? null
                : jobLevelItems.firstWhere((j) => j.id == filters.jobLevelId, orElse: () => jobLevelItems.first);
            final selected = await emp_job_level_dialog.JobLevelSelectionDialog.show(
              context,
              enterpriseId: enterpriseId ?? 0,
              selectedJobLevel: selectedInitial,
            );
            final newId = selected?.id;
            if (newId == filters.jobLevelId) return;
            filtersNotifier.setJobLevelId(newId);
            applyFiltersAndRefresh();
          },
        ),
        Gap(8.h),
        _MobileFilterSelectionField(
          label: filters.gradeId == null
              ? widget.localizations.allGrades
              : gradeItems.firstWhere((g) => g.id == filters.gradeId, orElse: () => gradeItems.first).gradeLabel,
          isDark: widget.isDark,
          onTap: () async {
            final selectedInitial = filters.gradeId == null
                ? null
                : gradeItems.firstWhere((g) => g.id == filters.gradeId, orElse: () => gradeItems.first);
            final selected = await emp_grade_dialog.GradeSelectionDialog.show(
              context,
              enterpriseId: enterpriseId ?? 0,
              selectedGrade: selectedInitial,
            );
            final newId = selected?.id;
            if (newId == filters.gradeId) return;
            filtersNotifier.setGradeId(newId);
            applyFiltersAndRefresh();
          },
        ),
      ],
    );
  }

  List<Widget> _buildOrgLoadingPlaceholders() {
    return List.generate(4, (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.w),
        child: SizedBox(
          height: 48.w,
          child: Skeletonizer(
            enabled: true,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.inputBgDark : AppColors.inputBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 14.w,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                  Gap(8.w),
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrgCascade(
    ({List<OrgStructureLevel> levels, String structureId}) param,
    ManageEmployeesFiltersNotifier filtersNotifier,
    VoidCallback applyFiltersAndRefresh,
  ) {
    final selectionProvider = employeeEnterpriseSelectionNotifierProvider(param);
    final selectionState = ref.watch(selectionProvider);
    final levels = param.levels;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;
      return Padding(
        padding: EdgeInsets.only(bottom: 8.w),
        child: DigifyStyleOrgLevelField(
          level: level,
          selectionProvider: selectionProvider,
          isEnabled: isEnabled,
          showLabel: false,
          onSelectionChanged: (levelCode, unit) {
            if (unit != null) {
              filtersNotifier.setOrgFilter(unit.orgUnitId, levelCode);
              applyFiltersAndRefresh();
            }
          },
        ),
      );
    }).toList();
  }
}

class _MobileFilterSelectionField extends StatelessWidget {
  const _MobileFilterSelectionField({required this.label, required this.isDark, required this.onTap});

  final String label;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            DigifyAsset(
              assetPath: Assets.icons.workforce.chevronRight.path,
              color: AppColors.textSecondary,
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
