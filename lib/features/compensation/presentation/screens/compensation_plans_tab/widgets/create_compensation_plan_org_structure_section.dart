import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_scope_selection_providers.dart';
import 'package:grc/features/compensation/presentation/widgets/manage_salary_structure/creation/org_structure_multi_selection_field.dart';
import 'package:grc/features/compensation/presentation/widgets/manage_salary_structure/creation/scope_levels_skeleton.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateCompensationPlanOrgStructureSection extends ConsumerWidget {
  const CreateCompensationPlanOrgStructureSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final orgState = ref.watch(compensationPlanOrgStructureNotifierProvider);
    final activeLevels = ref.watch(compensationPlanScopedLevelsProvider);
    final scopeSelection = ref.watch(compensationPlanCompanyScopeSelectionProvider);

    if (!orgState.isLoading && orgState.orgStructure == null) {
      Future.microtask(() {
        ref.read(compensationPlanOrgStructureNotifierProvider.notifier).fetchOrgStructureLevels();
      });
    }

    final rootSelectionProvider = (!orgState.isLoading && orgState.orgStructure != null && activeLevels.isNotEmpty)
        ? compensationPlanEnterpriseSelectionNotifierProvider((
            levels: activeLevels,
            structureId: orgState.orgStructure!.structureId,
            companyId: null,
          ))
        : null;

    if (orgState.isLoading) {
      return _buildSectionContainer(
        context: context,
        title: 'Organizational Information',
        child: Column(children: [ScopeLevelsSkeleton(isDark: isDark)]),
      );
    }

    if (orgState.error != null) {
      return _buildSectionContainer(
        context: context,
        title: 'Organizational Information',
        child: Text(
          'Failed to load structure levels',
          style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
        ),
      );
    }

    if (activeLevels.isEmpty || rootSelectionProvider == null) {
      return _buildSectionContainer(
        context: context,
        title: 'Organizational Information',
        child: Text('No enterprise structure levels found', style: context.textTheme.bodySmall),
      );
    }

    return _buildOrgSelectionUI(
      context: context,
      ref: ref,
      rootSelectionProvider: rootSelectionProvider,
      activeLevels: activeLevels,
      orgState: orgState,
      scopeSelection: scopeSelection,
    );
  }

  Widget _buildSectionContainer({required BuildContext context, required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.ingobgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PositionDialogSection(
            title: title,
            children: [SizedBox(width: double.infinity, child: child)],
          ),
        ],
      ),
    );
  }

  Widget _buildOrgSelectionUI({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic rootSelectionProvider,
    required List<OrgStructureLevel> activeLevels,
    required dynamic orgState,
    required CompensationPlanCompanyScopeSelectionState scopeSelection,
  }) {
    final rootSelectionState = ref.watch(rootSelectionProvider);
    final companyIndex = activeLevels.indexWhere((level) => level.levelCode.toUpperCase() == 'COMPANY');
    final businessUnitIndex = activeLevels.indexWhere((level) => level.levelCode.toUpperCase() == 'BUSINESS_UNIT');
    final companyLevel = companyIndex == -1 ? null : activeLevels[companyIndex];
    final levelsToBusinessUnit = (companyIndex != -1 && businessUnitIndex != -1 && businessUnitIndex > companyIndex)
        ? activeLevels.sublist(companyIndex + 1, businessUnitIndex + 1)
        : <OrgStructureLevel>[];

    final companyOptions = companyLevel == null ? const [] : rootSelectionState.getOptions(companyLevel.levelCode);

    if (companyOptions.isEmpty &&
        !rootSelectionState.isLoading(companyLevel?.levelCode ?? '') &&
        scopeSelection.selectedCompanyIds.isNotEmpty &&
        companyLevel != null) {
      Future.microtask(() {
        ref.read(rootSelectionProvider.notifier).loadOptionsForLevel(companyLevel.levelCode);
      });
    }

    if (companyLevel == null || rootSelectionState == null) {
      return _buildSectionContainer(
        context: context,
        title: 'Organizational Information',
        child: Text('No company level found', style: context.textTheme.bodySmall),
      );
    }

    return Column(
      children: [
        _buildSectionContainer(
          context: context,
          title: 'Organizational Information',
          child: OrgStructureMultiSelectionField(
            level: companyLevel,
            selectionProvider: rootSelectionProvider,
            isEnabled: true,
            isRequired: true,
            selectedUnitIds: scopeSelection.selectedCompanyIds,
            onSelectionChanged: (selectedIds) =>
                _handleCompanySelectionChange(ref, selectedIds, companyLevel.levelCode),
          ),
        ),
        Gap(14.h),
        _buildHierarchyAssignmentSection(
          context: context,
          ref: ref,
          companyIds: scopeSelection.selectedCompanyIds,
          companyOptions: companyOptions,
          companyLevel: companyLevel,
          levelsToBusinessUnit: levelsToBusinessUnit,
          activeLevels: activeLevels,
          orgState: orgState,
          scopeSelection: scopeSelection,
        ),
      ],
    );
  }

  Widget _buildHierarchyAssignmentSection({
    required BuildContext context,
    required WidgetRef ref,
    required List<String> companyIds,
    required List<dynamic> companyOptions,
    required OrgStructureLevel companyLevel,
    required List<OrgStructureLevel> levelsToBusinessUnit,
    required List<OrgStructureLevel> activeLevels,
    required dynamic orgState,
    required CompensationPlanCompanyScopeSelectionState scopeSelection,
  }) {
    if (companyIds.isEmpty) {
      return _buildSectionContainer(
        context: context,
        title: 'Hierarchy Assignment',
        child: Text('Select at least one company to configure hierarchy levels.', style: context.textTheme.bodySmall),
      );
    }

    return _buildSectionContainer(
      context: context,
      title: 'Hierarchy Assignment',
      child: Column(
        children: companyIds.map((companyId) {
          return _buildCompanyHierarchyCard(
            context: context,
            ref: ref,
            companyId: companyId,
            companyLevel: companyLevel,
            companyOptions: companyOptions,
            levelsToBusinessUnit: levelsToBusinessUnit,
            activeLevels: activeLevels,
            orgState: orgState,
            scopeSelection: scopeSelection,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompanyHierarchyCard({
    required BuildContext context,
    required WidgetRef ref,
    required String companyId,
    required OrgStructureLevel companyLevel,
    required List<dynamic> companyOptions,
    required List<OrgStructureLevel> levelsToBusinessUnit,
    required List<OrgStructureLevel> activeLevels,
    required dynamic orgState,
    required CompensationPlanCompanyScopeSelectionState scopeSelection,
  }) {
    final companyUnit = companyOptions.whereType<OrgUnit>().where((e) => e.orgUnitId == companyId).firstOrNull;
    final cachedCompanyName = scopeSelection.selectedCompanyNames[companyId];
    final companyName = companyUnit?.orgUnitNameEn ?? cachedCompanyName ?? companyId;

    final companySelectionProvider = compensationPlanEnterpriseSelectionNotifierProvider((
      levels: activeLevels,
      structureId: orgState.orgStructure!.structureId,
      companyId: companyId,
    ));

    final companySelectionState = ref.watch(companySelectionProvider);

    final selectedCompanyUnit = companySelectionState.getSelection(companyLevel.levelCode);
    if (selectedCompanyUnit?.orgUnitId != companyId && companyUnit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(companySelectionProvider.notifier).selectUnit(companyLevel.levelCode, companyUnit);
      });
    }

    if (companyUnit != null && cachedCompanyName != companyUnit.orgUnitNameEn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(compensationPlanCompanyScopeSelectionProvider.notifier)
            .upsertCompanyName(companyId: companyId, companyName: companyUnit.orgUnitNameEn);
      });
    }

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.background,
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(companyName, style: context.textTheme.titleSmall),
          Gap(14.h),
          ...levelsToBusinessUnit.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;
            final selectedIds = scopeSelection.selectedOrgUnitIdsByCompany[companyId]?[level.levelCode] ?? [];

            final isEnabled = index == 0
                ? true
                : (scopeSelection
                          .selectedOrgUnitIdsByCompany[companyId]?[levelsToBusinessUnit[index - 1].levelCode]
                          ?.isNotEmpty ??
                      false);

            return Padding(
              padding: EdgeInsets.only(bottom: index == levelsToBusinessUnit.length - 1 ? 0 : 14.h),
              child: OrgStructureMultiSelectionField(
                level: level,
                selectionProvider: companySelectionProvider,
                isEnabled: isEnabled,
                isRequired: false,
                selectedUnitIds: selectedIds,
                onSelectionChanged: (newIds) {
                  _handleOrgUnitSelectionChange(
                    ref: ref,
                    companyId: companyId,
                    level: level,
                    selectedIds: newIds,
                    levelsToBusinessUnit: levelsToBusinessUnit,
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  void _handleCompanySelectionChange(WidgetRef ref, List<String> selectedIds, String companyLevelCode) {
    final rootProvider = compensationPlanEnterpriseSelectionNotifierProvider;

    final orgState = ref.read(compensationPlanOrgStructureNotifierProvider);
    final activeLevels = ref.read(compensationPlanScopedLevelsProvider);
    if (orgState.orgStructure == null || activeLevels.isEmpty) return;

    final rootSelectionProvider = rootProvider((
      levels: activeLevels,
      structureId: orgState.orgStructure!.structureId,
      companyId: null,
    ));

    final rootState = ref.read(rootSelectionProvider);
    final options = rootState.getOptions(companyLevelCode);
    final namesById = {
      for (final option in options)
        if (selectedIds.contains(option.orgUnitId)) option.orgUnitId: option.orgUnitNameEn,
    };

    ref
        .read(compensationPlanCompanyScopeSelectionProvider.notifier)
        .updateCompanySelection(
          companyIds: selectedIds,
          companyLevelCode: companyLevelCode,
          companyNamesById: namesById,
        );
  }

  void _handleOrgUnitSelectionChange({
    required WidgetRef ref,
    required String companyId,
    required OrgStructureLevel level,
    required List<String> selectedIds,
    required List<OrgStructureLevel> levelsToBusinessUnit,
  }) {
    ref
        .read(compensationPlanCompanyScopeSelectionProvider.notifier)
        .updateOrgUnitSelection(companyId: companyId, levelCode: level.levelCode, selectedIds: selectedIds);

    final levelIndex = levelsToBusinessUnit.indexWhere((l) => l.levelCode == level.levelCode);
    if (levelIndex == -1) return;

    for (int i = levelIndex + 1; i < levelsToBusinessUnit.length; i++) {
      final nextLevel = levelsToBusinessUnit[i];
      ref
          .read(compensationPlanCompanyScopeSelectionProvider.notifier)
          .updateOrgUnitSelection(companyId: companyId, levelCode: nextLevel.levelCode, selectedIds: const []);
    }
  }
}
