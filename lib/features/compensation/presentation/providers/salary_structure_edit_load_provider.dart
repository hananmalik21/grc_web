import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_full_details.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_company_scope_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_creation_provider.dart';
import 'package:grc/features/compensation/presentation/providers/update_salary_structure_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'salary_structure_edit_load_state.dart';

final salaryStructureEditLoadProvider =
    AutoDisposeNotifierProvider.family<SalaryStructureEditLoadNotifier, SalaryStructureEditLoadState, String>(
      SalaryStructureEditLoadNotifier.new,
    );

class SalaryStructureEditLoadNotifier extends AutoDisposeFamilyNotifier<SalaryStructureEditLoadState, String> {
  @override
  SalaryStructureEditLoadState build(String structureGuid) {
    Future.microtask(_load);
    return const SalaryStructureEditLoading();
  }

  Future<void> _load() async {
    ref.read(companyScopeSelectionProvider.notifier).reset();
    ref.read(salaryStructureCreationProvider.notifier).reset();

    final enterpriseId = ref.read(manageSalaryStructureEnterpriseIdProvider);
    if (enterpriseId == null) {
      state = const SalaryStructureEditError('No enterprise selected.');
      return;
    }

    try {
      final results = await Future.wait([
        ref.read(salaryStructureFullDetailsProvider((arg, enterpriseId)).future),
        ref.read(salaryStructureEditComponentsProvider(enterpriseId).future),
      ]);

      _prefill(results[0] as SalaryStructureFullDetails, results[1] as List<CompComponent>);
      state = const SalaryStructureEditLoaded();
    } catch (e) {
      state = SalaryStructureEditError(e.toString());
    }
  }

  void retry() {
    state = const SalaryStructureEditLoading();
    Future.microtask(_load);
  }

  void _prefill(SalaryStructureFullDetails details, List<CompComponent> allComponents) {
    final notifier = ref.read(salaryStructureCreationProvider.notifier);

    notifier.updateBasicInfo(
      name: details.structureName,
      code: details.structureCode,
      description: details.description ?? '',
      type: details.structureTypeCode,
    );

    notifier.updateScopeAndAssignment(country: details.countryCode);

    final companyScopeNotifier = ref.read(companyScopeSelectionProvider.notifier);
    final scopeState = CompanyScopeSelectionState.fromCompanyScopeRestore(
      companyToBusinessUnitIds: details.companyToBusinessUnitsMap,
      companyNamesById: details.companyNamesById,
    );
    companyScopeNotifier.applyState(scopeState);

    notifier.setBusinessUnits(scopeState.extractOrgUnitIdsForSubmission());
    notifier.setContractTypes(details.employmentTypeCodes);
    notifier.setJobFamilyIds(details.jobFamilyIds);
    notifier.setPositionIds(details.positionIds);
    notifier.setGradeIds(details.gradeIds);

    final componentIdSet = details.componentIds.toSet();
    for (final comp in allComponents) {
      if (componentIdSet.contains(comp.componentId)) {
        notifier.toggleComponent(comp.componentCode, component: comp);
      }
    }

    notifier.updateFinancialDetails(
      currency: details.currencyCode,
      costCenter: details.costCenterCode ?? '',
      effectiveFrom: details.effectiveFrom,
      effectiveTo: details.effectiveTo,
      annualBudget: details.annualBudgetAmount?.toString() ?? '',
    );

    notifier.updateAdvancedSettings(
      payrollIntegrationEnabled: details.enablePayrollIntegration,
      autoCalculateComponentsEnabled: details.autoCalcComponents,
      versionControlEnabled: details.enableVersionControl,
      multiStageApprovalEnabled: details.requireMultiApproval,
      auditLoggingEnabled: details.enableAuditLogging,
      manualOverridesEnabled: details.allowManualOverride,
    );
  }
}
