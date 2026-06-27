import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'salary_structure_company_scope_provider.dart';
import 'salary_structure_creation_state.dart';

class SalaryStructureCreationNotifier extends AutoDisposeNotifier<SalaryStructureCreationState> {
  @override
  SalaryStructureCreationState build() {
    return SalaryStructureCreationState();
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  String? tryGoNext() {
    final error = validateStep(state.currentStep);
    if (error != null) return error;

    nextStep();
    return null;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void updateBasicInfo({String? name, String? code, String? description, String? type}) {
    state = state.copyWith(name: name, code: code, description: description, type: type);
  }

  void updateScopeAndAssignment({
    String? country,
    String? businessUnit,
    String? department,
    String? category,
    String? grade,
  }) {
    state = state.copyWith(
      country: country,
      businessUnit: businessUnit,
      department: department,
      category: category,
      grade: grade,
    );
  }

  void addBusinessUnit(String id) {
    if (id.trim().isEmpty || state.businessUnits.contains(id)) return;
    state = state.copyWith(businessUnits: [...state.businessUnits, id]);
  }

  void removeBusinessUnit(String id) {
    state = state.copyWith(businessUnits: state.businessUnits.where((value) => value != id).toList());
  }

  void setBusinessUnits(List<String> ids) {
    final cleaned = ids.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    state = state.copyWith(businessUnits: cleaned);
  }

  void addEmployeeCategory(String category) {
    if (category.trim().isEmpty || state.employeeCategories.contains(category)) return;
    state = state.copyWith(employeeCategories: [...state.employeeCategories, category]);
  }

  void setEmployeeCategories(List<String> categories) {
    final cleaned = categories.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    state = state.copyWith(employeeCategories: cleaned);
  }

  void removeEmployeeCategory(String category) {
    state = state.copyWith(employeeCategories: state.employeeCategories.where((value) => value != category).toList());
  }

  void setContractTypes(List<String> types) {
    final cleaned = types.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    state = state.copyWith(contractTypes: cleaned);
  }

  void addJobFamilyId(int id) {
    if (state.jobFamilyIds.contains(id)) return;
    state = state.copyWith(jobFamilyIds: [...state.jobFamilyIds, id]);
  }

  void setJobFamilyIds(List<int> ids) {
    final cleaned = ids.toSet().toList();
    state = state.copyWith(jobFamilyIds: cleaned);
  }

  void removeJobFamilyId(int id) {
    state = state.copyWith(jobFamilyIds: state.jobFamilyIds.where((value) => value != id).toList());
  }

  void addPositionId(String id) {
    if (state.positionIds.contains(id)) return;
    state = state.copyWith(positionIds: [...state.positionIds, id]);
  }

  void setPositionIds(List<String> ids) {
    final cleaned = ids.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    state = state.copyWith(positionIds: cleaned);
  }

  void removePositionId(String id) {
    state = state.copyWith(positionIds: state.positionIds.where((value) => value != id).toList());
  }

  void addGradeId(int id) {
    if (state.gradeIds.contains(id)) return;
    state = state.copyWith(gradeIds: [...state.gradeIds, id]);
  }

  void setGradeIds(List<int> ids) {
    final cleaned = ids.toSet().toList();
    state = state.copyWith(gradeIds: cleaned);
  }

  void removeGradeId(int id) {
    state = state.copyWith(gradeIds: state.gradeIds.where((value) => value != id).toList());
  }

  void toggleComponent(String code, {CompComponent? component}) {
    final codes = Set<String>.from(state.selectedComponentCodes);
    final components = List<CompComponent>.from(state.selectedComponents);

    if (codes.contains(code)) {
      codes.remove(code);
      components.removeWhere((c) => c.componentCode == code);
    } else {
      codes.add(code);
      if (component != null) {
        components.add(component);
      }
    }
    state = state.copyWith(selectedComponentCodes: codes, selectedComponents: components);
  }

  void updateFinancialDetails({
    String? currency,
    String? frequency,
    String? calcBase,
    String? costCenter,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
    String? annualBudget,
  }) {
    DateTime? nextEffectiveFrom = effectiveFrom ?? state.effectiveFrom;
    DateTime? nextEffectiveTo = effectiveTo ?? state.effectiveTo;

    if (nextEffectiveFrom != null && nextEffectiveTo != null && nextEffectiveTo.isBefore(nextEffectiveFrom)) {
      nextEffectiveTo = nextEffectiveFrom;
    }

    state = state.copyWith(
      currency: currency,
      frequency: frequency,
      calcBase: calcBase,
      costCenter: costCenter,
      effectiveFrom: nextEffectiveFrom,
      effectiveTo: nextEffectiveTo,
      annualBudget: annualBudget,
    );
  }

  void updateAdvancedSettings({
    bool? payrollIntegrationEnabled,
    bool? autoCalculateComponentsEnabled,
    bool? versionControlEnabled,
    bool? multiStageApprovalEnabled,
    bool? auditLoggingEnabled,
    bool? manualOverridesEnabled,
  }) {
    state = state.copyWith(
      payrollIntegrationEnabled: payrollIntegrationEnabled,
      autoCalculateComponentsEnabled: autoCalculateComponentsEnabled,
      versionControlEnabled: versionControlEnabled,
      multiStageApprovalEnabled: multiStageApprovalEnabled,
      auditLoggingEnabled: auditLoggingEnabled,
      manualOverridesEnabled: manualOverridesEnabled,
    );
  }

  void reset() {
    state = SalaryStructureCreationState();
  }

  String? validateStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        if (_isBlank(state.name)) return 'Structure name is required.';
        if (_isBlank(state.code)) return 'Structure code is required.';
        if (_isBlank(state.type)) return 'Structure type is required.';
        return null;
      case 1:
        if (_isBlank(state.country)) return 'Country is required.';
        final companyIds = ref.read(companyScopeSelectionProvider).selectedCompanyIds;
        if (companyIds.isEmpty) return 'At least one company is required.';
        return null;
      case 2:
        if (state.selectedComponentCodes.isEmpty) {
          return 'Select at least one component.';
        }
        return null;
      case 3:
        if (_isBlank(state.currency)) return 'Currency is required.';
        if (_isBlank(state.costCenter)) return 'Cost center is required.';
        if (state.effectiveFrom == null) return 'Effective from date is required.';
        if (state.effectiveTo != null && state.effectiveTo!.isBefore(state.effectiveFrom!)) {
          return 'Effective to date cannot be earlier than effective from date.';
        }
        if (_isBlank(state.annualBudget)) return 'Annual budget allocation is required.';
        return null;
      case 4:
        return null;
      default:
        return null;
    }
  }

  String? validateForSubmit() {
    return validateStep(0) ?? validateStep(1) ?? validateStep(2) ?? validateStep(3);
  }

  bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}

final salaryStructureCreationProvider =
    AutoDisposeNotifierProvider<SalaryStructureCreationNotifier, SalaryStructureCreationState>(
      SalaryStructureCreationNotifier.new,
    );
