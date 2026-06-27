import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_creation_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_company_scope_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'org_structure_multi_selection_field.dart';
import 'scope_levels_skeleton.dart';

class ScopeOrgStructureSection extends ConsumerWidget {
  const ScopeOrgStructureSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final orgState = ref.watch(manageSalaryStructureOrgStructureNotifierProvider);
    final activeLevels = ref.watch(manageSalaryStructureScopedLevelsProvider);
    final scopeSelection = ref.watch(companyScopeSelectionProvider);

    if (!orgState.isLoading && orgState.orgStructure == null) {
      Future.microtask(() {
        ref.read(manageSalaryStructureOrgStructureNotifierProvider.notifier).fetchOrgStructureLevels();
      });
    }

    final rootSelectionProvider = (!orgState.isLoading && orgState.orgStructure != null && activeLevels.isNotEmpty)
        ? manageSalaryStructureEnterpriseSelectionNotifierProvider((
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
    required CompanyScopeSelectionState scopeSelection,
  }) {
    final rootSelectionState = ref.watch(rootSelectionProvider);
    final companyIndex = activeLevels.indexWhere((level) => level.levelCode.toUpperCase() == 'COMPANY');
    final businessUnitIndex = activeLevels.indexWhere((level) => level.levelCode.toUpperCase() == 'BUSINESS_UNIT');
    final companyLevel = companyIndex == -1 ? null : activeLevels[companyIndex];
    final levelsToBusinessUnit = (companyIndex != -1 && businessUnitIndex != -1 && businessUnitIndex > companyIndex)
        ? activeLevels.sublist(companyIndex + 1, businessUnitIndex + 1)
        : <OrgStructureLevel>[];

    final companyOptions = companyLevel == null ? const [] : rootSelectionState.getOptions(companyLevel.levelCode);

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
    required CompanyScopeSelectionState scopeSelection,
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
    required CompanyScopeSelectionState scopeSelection,
  }) {
    final companyUnit = companyOptions.whereType<OrgUnit>().where((e) => e.orgUnitId == companyId).firstOrNull;
    final cachedCompanyName = scopeSelection.selectedCompanyNames[companyId];
    final companyName = companyUnit?.orgUnitNameEn ?? cachedCompanyName ?? companyId;

    final companySelectionProvider = manageSalaryStructureEnterpriseSelectionNotifierProvider((
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
            .read(companyScopeSelectionProvider.notifier)
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
            final levelOptions = companySelectionState.getOptions(level.levelCode);
            final levelOptionIds = levelOptions.map((unit) => unit.orgUnitId).toSet();
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
                onSelectionChanged: (changedIds) => _handleOrgUnitSelectionChange(
                  ref,
                  companyId,
                  level.levelCode,
                  levelOptionIds.isEmpty ? changedIds : changedIds.where(levelOptionIds.contains).toList(),
                  companySelectionProvider,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _handleCompanySelectionChange(WidgetRef ref, List<String> selectedIds, String companyLevelCode) {
    final scopeNotifier = ref.read(companyScopeSelectionProvider.notifier);
    final orgState = ref.read(manageSalaryStructureOrgStructureNotifierProvider);
    final activeLevels = ref.read(manageSalaryStructureScopedLevelsProvider);

    Map<String, String> companyNamesById = const {};
    if (orgState.orgStructure != null && activeLevels.isNotEmpty) {
      final provider = manageSalaryStructureEnterpriseSelectionNotifierProvider((
        levels: activeLevels,
        structureId: orgState.orgStructure!.structureId,
        companyId: null,
      ));
      final rootState = ref.read(provider);
      final options = rootState.getOptions(companyLevelCode);
      companyNamesById = {
        for (final unit in options)
          if (unit.orgUnitNameEn.trim().isNotEmpty) unit.orgUnitId: unit.orgUnitNameEn,
      };
    }

    scopeNotifier.updateCompanySelection(
      companyIds: selectedIds,
      companyLevelCode: companyLevelCode,
      companyNamesById: companyNamesById,
    );
    _updateBusinessUnitsInMainProvider(ref);
  }

  void _handleOrgUnitSelectionChange(
    WidgetRef ref,
    String companyId,
    String levelCode,
    List<String> selectedIds,
    dynamic selectionProvider,
  ) {
    final scopeNotifier = ref.read(companyScopeSelectionProvider.notifier);
    scopeNotifier.updateOrgUnitSelection(companyId: companyId, levelCode: levelCode, selectedIds: selectedIds);

    _syncSelectionToProvider(ref, selectionProvider, levelCode, selectedIds);
    _updateBusinessUnitsInMainProvider(ref);
  }

  void _syncSelectionToProvider(WidgetRef ref, dynamic selectionProvider, String levelCode, List<String> selectedIds) {
    final rawOptions = ref.read(selectionProvider).getOptions(levelCode);
    final options = rawOptions is List ? rawOptions.whereType<OrgUnit>().toList() : const <OrgUnit>[];
    final primaryUnitId = selectedIds.isEmpty ? null : selectedIds.first;
    final primaryUnit = primaryUnitId == null
        ? null
        : options.where((unit) => unit.orgUnitId == primaryUnitId).firstOrNull;
    ref.read(selectionProvider.notifier).selectUnit(levelCode, primaryUnit);
  }

  void _updateBusinessUnitsInMainProvider(WidgetRef ref) {
    final scopeSelection = ref.read(companyScopeSelectionProvider);
    ref
        .read(salaryStructureCreationProvider.notifier)
        .setBusinessUnits(scopeSelection.extractOrgUnitIdsForSubmission());
  }
}
