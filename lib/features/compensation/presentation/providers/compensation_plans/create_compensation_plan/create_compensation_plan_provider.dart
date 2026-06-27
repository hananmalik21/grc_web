import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_detail_component.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../workforce_structure/domain/models/employee.dart';
import 'create_compensation_plan_state.dart';

class CreateCompensationPlanNotifier extends AutoDisposeNotifier<CreateCompensationPlanState> {
  static const _allowedStatuses = <String>{'ACTIVE', 'INACTIVE'};

  static const fieldPlanName = 'planName';
  static const fieldPlanCode = 'planCode';
  static const fieldPlanType = 'planType';
  static const fieldStatus = 'status';
  static const fieldDescription = 'description';
  static const fieldCurrency = 'currency';
  static const fieldBudgetAmount = 'budgetAmount';
  static const fieldPlanOwner = 'planOwner';
  static const fieldEffectiveFrom = 'effectiveFrom';
  static const fieldEffectiveTo = 'effectiveTo';
  static const fieldSalaryStructure = 'salaryStructure';
  static const fieldComponents = 'components';
  static const fieldEligibilityContractTypes = 'eligibilityContractTypes';
  static const fieldEligibilityPlanAttributes = 'eligibilityPlanAttributes';
  static const fieldEligibilityJobFamilies = 'eligibilityJobFamilies';
  static const fieldEligibilityPositions = 'eligibilityPositions';
  static const fieldEligibilityGrades = 'eligibilityGrades';
  static const fieldEligibilityBusinessUnits = 'eligibilityBusinessUnits';
  static const fieldAssignedEmployees = 'assignedEmployees';

  @override
  CreateCompensationPlanState build() => CreateCompensationPlanState();

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 5) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  String? tryGoNext() {
    final error = validateStep(state.currentStep);
    if (error != null) return error;

    nextStep();
    return null;
  }

  void updateBasicInformation({
    String? planName,
    String? planCode,
    String? description,
    String? planType,
    String? status,
  }) {
    final nextErrors = Map<String, String>.from(state.fieldErrors);

    if (planName != null && !_isBlank(planName)) nextErrors.remove(fieldPlanName);
    if (planCode != null && !_isBlank(planCode)) nextErrors.remove(fieldPlanCode);
    if (description != null && !_isBlank(description)) nextErrors.remove(fieldDescription);
    if (planType != null && !_isBlank(planType)) nextErrors.remove(fieldPlanType);
    if (status != null && !_isBlank(status)) nextErrors.remove(fieldStatus);

    state = state.copyWith(
      planName: planName,
      planCode: planCode,
      description: description,
      planType: planType,
      status: status,
      fieldErrors: nextErrors,
    );
  }

  void updateFinancialAndOwnerDetails({
    String? currency,
    String? budgetAmount,
    String? planOwner,
    int? planOwnerEmployeeId,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
  }) {
    final nextEffectiveFrom = effectiveFrom ?? state.effectiveFrom;
    var nextEffectiveTo = effectiveTo ?? state.effectiveTo;

    if (nextEffectiveFrom != null && nextEffectiveTo != null && nextEffectiveTo.isBefore(nextEffectiveFrom)) {
      nextEffectiveTo = nextEffectiveFrom;
    }

    final nextErrors = Map<String, String>.from(state.fieldErrors);

    if (currency != null && !_isBlank(currency)) nextErrors.remove(fieldCurrency);
    if (budgetAmount != null && !_isBlank(budgetAmount)) nextErrors.remove(fieldBudgetAmount);
    if (planOwner != null && !_isBlank(planOwner)) nextErrors.remove(fieldPlanOwner);
    if (planOwnerEmployeeId != null) nextErrors.remove(fieldPlanOwner);
    if (nextEffectiveFrom != null) nextErrors.remove(fieldEffectiveFrom);
    nextErrors.remove(fieldEffectiveTo);
    if (nextEffectiveFrom != null && nextEffectiveTo != null && !nextEffectiveTo.isBefore(nextEffectiveFrom)) {
      nextErrors.remove(fieldEffectiveTo);
    }

    state = state.copyWith(
      currency: currency,
      budgetAmount: budgetAmount,
      planOwner: planOwner,
      planOwnerEmployeeId: planOwnerEmployeeId,
      effectiveFrom: nextEffectiveFrom,
      effectiveTo: nextEffectiveTo,
      fieldErrors: nextErrors,
    );
  }

  void setPlanOwnerFromEmployee(Employee employee) {
    final displayName = employee.fullName.trim().isNotEmpty ? employee.fullName.trim() : employee.email;
    updateFinancialAndOwnerDetails(planOwner: displayName, planOwnerEmployeeId: employee.id);
  }

  void updateSelectedSalaryStructure(String? value, {int? id, String? guid}) {
    final nextErrors = Map<String, String>.from(state.fieldErrors);
    if (value != null && value.trim().isNotEmpty) {
      nextErrors.remove(fieldSalaryStructure);
    }

    state = state.copyWith(
      selectedSalaryStructure: value,
      selectedSalaryStructureId: id,
      selectedSalaryStructureGuid: guid,
      eligibilityPrefilledFromSalaryStructureGuid: null,
      selectedComponentCodes: <String>{},
      selectedComponents: const <CompComponent>[],
      componentSettingsById: const <int, CreateCompensationPlanComponentSettings>{},
      fieldErrors: nextErrors,
    );
  }

  void updateEligibilityStructureType(String? value) {
    if (_isBlank(value)) return;
    state = state.copyWith(eligibilityStructureType: value);
  }

  void updateEligibilityCompensationCategories(List<String> values) {
    state = state.copyWith(eligibilityCompensationCategories: values);
  }

  void toggleEligibilityBusinessUnit(String value) {
    state = state.copyWith(eligibilityBusinessUnits: _toggleListValue(state.eligibilityBusinessUnits, value));
  }

  void toggleEligibilityContractType(String value) {
    state = state.copyWith(eligibilityContractTypes: _toggleListValue(state.eligibilityContractTypes, value));
  }

  void setEligibilityContractTypes(List<String> values) {
    state = state.copyWith(eligibilityContractTypes: _normalizeListValues(values));
  }

  void setEligibilityPositionIds(List<String> values) {
    state = state.copyWith(eligibilityPositionIds: _normalizeListValues(values));
  }

  void setEligibilityGradeIds(List<String> values) {
    final normalized = _normalizeListValues(values);
    state = state.copyWith(
      eligibilityGradeIds: normalized,
      eligibilityFromGrade: normalized.isEmpty ? state.eligibilityFromGrade : normalized.first,
      eligibilityToGrade: normalized.isEmpty ? state.eligibilityToGrade : normalized.last,
    );
  }

  void updateEligibilityFromGrade(String? value) {
    if (_isBlank(value)) return;
    state = state.copyWith(eligibilityFromGrade: value);
  }

  void updateEligibilityToGrade(String? value) {
    if (_isBlank(value)) return;
    state = state.copyWith(eligibilityToGrade: value);
  }

  void toggleEligibilityLocation(String value) {
    state = state.copyWith(eligibilityLocations: _toggleListValue(state.eligibilityLocations, value));
  }

  void setEligibilityLocations(List<String> values) {
    state = state.copyWith(eligibilityLocations: _normalizeListValues(values));
  }

  void setEligibilityPlanAttributes(List<String> values) {
    state = state.copyWith(eligibilityPlanAttributes: _normalizeListValues(values));
  }

  void updateEligibilityPlanAttribute(String? value) {
    if (_isBlank(value)) return;
    state = state.copyWith(eligibilityPlanAttributes: <String>[value!.trim()]);
  }

  void toggleEligibilityJobFamily(String value) {
    state = state.copyWith(eligibilityJobFamilies: _toggleListValue(state.eligibilityJobFamilies, value));
  }

  void setEligibilityJobFamilies(List<String> values) {
    state = state.copyWith(eligibilityJobFamilies: _normalizeListValues(values));
  }

  void toggleComponent(String code, {CompComponent? component}) {
    final codes = Set<String>.from(state.selectedComponentCodes);
    final components = List<CompComponent>.from(state.selectedComponents);
    final nextErrors = Map<String, String>.from(state.fieldErrors);

    if (codes.contains(code)) {
      codes.remove(code);
      components.removeWhere((item) => item.componentCode == code);
    } else {
      codes.add(code);
      if (component != null) {
        components.add(component);
      }
    }

    if (codes.isNotEmpty) {
      nextErrors.remove(fieldComponents);
    }

    state = state.copyWith(selectedComponentCodes: codes, selectedComponents: components, fieldErrors: nextErrors);
  }

  void syncComponentsFromSalaryStructureDetails(List<SalaryStructureDetailComponent> details) {
    final sortedDetails = [...details]..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));

    final mappedComponents = sortedDetails
        .map(
          (item) => CompComponent(
            componentId: item.componentId,
            componentGuid: '',
            componentCode: item.componentId.toString(),
            componentName: 'Component #${item.componentId}',
            description: item.uiDescription,
            componentTypeCode: item.calculationMethodCode,
            calculationMethodCode: item.calculationMethodCode,
            status: item.uiStatus,
            compCategoryCode: '-',
            minValue: item.minValue,
            maxValue: item.maxValue,
            componentActiveFlag: item.isActive ? 'Y' : 'N',
          ),
        )
        .toList();

    final nextSettings = <int, CreateCompensationPlanComponentSettings>{};
    final nextPayBaseCodes = <int, String>{};
    for (final item in sortedDetails) {
      final existing = state.componentSettingsById[item.componentId];
      final advanced = item.advancedSettings;
      nextSettings[item.componentId] =
          existing ??
          CreateCompensationPlanComponentSettings(
            recurring: advanced?.isRecurring ?? false,
            optional: advanced?.isOptional ?? false,
            isActive: advanced?.isActive ?? item.isActive,
            pensionable: advanced?.isPensionable ?? false,
            statutory: advanced?.isStatutory ?? false,
            includeInCtc: advanced?.isIncludedInCtc ?? false,
            prorated: advanced?.isProrated ?? false,
            taxable: advanced?.isTaxable ?? false,
            amortizable: advanced?.isAmortizable ?? false,
          );
      final payBasis = advanced?.payBasis?.trim();
      if (payBasis != null && payBasis.isNotEmpty) {
        nextPayBaseCodes[item.componentId] = payBasis;
      }
    }

    final hasChanged =
        mappedComponents.length != state.selectedComponents.length ||
        mappedComponents.any(
          (item) => !state.selectedComponents.any(
            (existing) =>
                existing.componentId == item.componentId &&
                existing.calculationMethodCode == item.calculationMethodCode &&
                existing.minValue == item.minValue &&
                existing.maxValue == item.maxValue &&
                existing.componentActiveFlag == item.componentActiveFlag,
          ),
        );
    final settingsChanged =
        nextSettings.length != state.componentSettingsById.length ||
        nextSettings.entries.any((entry) => state.componentSettingsById[entry.key] != entry.value);

    if (!hasChanged && !settingsChanged) {
      return;
    }

    final nextErrors = Map<String, String>.from(state.fieldErrors)..remove(fieldComponents);
    state = state.copyWith(
      selectedComponentCodes: mappedComponents.map((item) => item.componentCode).toSet(),
      selectedComponents: mappedComponents,
      componentSettingsById: nextSettings,
      initialComponentPayBaseCodes: nextPayBaseCodes,
      fieldErrors: nextErrors,
    );
  }

  void setComponentFrequency(int componentId, CompLookupValue? value) {
    final updated = Map<int, CompLookupValue>.from(state.componentFrequencies);
    if (value == null) {
      updated.remove(componentId);
    } else {
      updated[componentId] = value;
    }
    state = state.copyWith(componentFrequencies: updated);
  }

  void setComponentPayBasis(int componentId, CompLookupValue? value) {
    final updated = Map<int, CompLookupValue>.from(state.componentPayBases);
    if (value == null) {
      updated.remove(componentId);
    } else {
      updated[componentId] = value;
    }
    state = state.copyWith(componentPayBases: updated);
  }

  void setComponentSettings(
    int componentId, {
    bool? recurring,
    bool? optional,
    bool? isActive,
    bool? pensionable,
    bool? statutory,
    bool? includeInCtc,
    bool? prorated,
    bool? taxable,
    bool? amortizable,
  }) {
    final updated = Map<int, CreateCompensationPlanComponentSettings>.from(state.componentSettingsById);
    final current = updated[componentId] ?? const CreateCompensationPlanComponentSettings();
    updated[componentId] = current.copyWith(
      recurring: recurring,
      optional: optional,
      isActive: isActive,
      pensionable: pensionable,
      statutory: statutory,
      includeInCtc: includeInCtc,
      prorated: prorated,
      taxable: taxable,
      amortizable: amortizable,
    );
    state = state.copyWith(componentSettingsById: updated);
  }

  void prefillEligibilityFromSalaryStructureDetails(SalaryStructureDetails details) {
    final selectedGuid = state.selectedSalaryStructureGuid;
    if (selectedGuid == null || selectedGuid.trim().isEmpty) return;
    if (state.eligibilityPrefilledFromSalaryStructureGuid == selectedGuid) return;

    state = state.copyWith(
      eligibilityContractTypes: details.employmentTypeCodes,
      eligibilityJobFamilies: details.jobFamilyIds.map((id) => id.toString()).toList(),
      eligibilityPositionIds: details.positionIds,
      eligibilityGradeIds: details.gradeIds.map((id) => id.toString()).toList(),
      eligibilityPrefilledFromSalaryStructureGuid: selectedGuid,
    );
  }

  void addAssignedEmployee(Employee employee) {
    if (state.assignedEmployees.any((e) => e.id == employee.id)) return;
    state = state.copyWith(assignedEmployees: [...state.assignedEmployees, employee]);
  }

  void removeAssignedEmployee(int employeeId) {
    state = state.copyWith(assignedEmployees: state.assignedEmployees.where((e) => e.id != employeeId).toList());
  }

  void setAssignedEmployees(List<Employee> employees) {
    state = state.copyWith(assignedEmployees: employees);
  }

  void reset() {
    state = CreateCompensationPlanState();
  }

  String? validateStep(int stepIndex) {
    final errors = Map<String, String>.from(state.fieldErrors);
    errors.remove(fieldComponents);

    switch (stepIndex) {
      case 0:
        errors
          ..remove(fieldPlanName)
          ..remove(fieldPlanCode)
          ..remove(fieldPlanType)
          ..remove(fieldStatus)
          ..remove(fieldDescription)
          ..remove(fieldCurrency)
          ..remove(fieldBudgetAmount)
          ..remove(fieldPlanOwner)
          ..remove(fieldEffectiveFrom)
          ..remove(fieldEffectiveTo)
          ..addAll(_validateDetailsStep());
        break;
      case 1:
        errors.remove(fieldSalaryStructure);
        if (_isBlank(state.selectedSalaryStructure) || state.selectedSalaryStructureGuid == null) {
          errors[fieldSalaryStructure] = 'Select a salary structure to load components.';
        }
        break;
      case 2:
        errors
          ..remove(fieldEligibilityContractTypes)
          ..remove(fieldEligibilityPlanAttributes)
          ..remove(fieldEligibilityJobFamilies)
          ..remove(fieldEligibilityPositions)
          ..remove(fieldEligibilityGrades)
          ..remove(fieldEligibilityBusinessUnits);
        break;
      case 4:
        errors.remove(fieldAssignedEmployees);
        break;
      default:
        break;
    }

    state = state.copyWith(fieldErrors: errors);

    if (errors.isEmpty) {
      return null;
    }

    return errors.values.first;
  }

  bool _isBlank(String? value) => value == null || value.trim().isEmpty;

  List<String> _toggleListValue(List<String> values, String value) {
    final next = List<String>.from(values);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    return next;
  }

  List<String> _normalizeListValues(List<String> values) {
    return values.map((value) => value.trim()).where((value) => value.isNotEmpty).toSet().toList();
  }

  Map<String, String> _validateDetailsStep() {
    final errors = <String, String>{};

    if (_isBlank(state.planName)) {
      errors[fieldPlanName] = 'Plan name is required.';
    }
    if (_isBlank(state.planCode)) {
      errors[fieldPlanCode] = 'Plan code is required.';
    }
    if (_isBlank(state.planType)) {
      errors[fieldPlanType] = 'Plan type is required.';
    }
    if (_isBlank(state.status)) {
      errors[fieldStatus] = 'Status is required.';
    } else if (!_allowedStatuses.contains(state.status.trim())) {
      errors[fieldStatus] = 'Status must be ACTIVE or INACTIVE.';
    }
    if (_isBlank(state.currency)) {
      errors[fieldCurrency] = 'Currency is required.';
    }
    if (!_isBlank(state.budgetAmount)) {
      final parsedBudget = double.tryParse(state.budgetAmount.trim());
      if (parsedBudget == null || parsedBudget <= 0) {
        errors[fieldBudgetAmount] = 'Enter a valid budget amount greater than 0.';
      }
    }
    if (state.effectiveFrom == null) {
      errors[fieldEffectiveFrom] = 'Effective from date is required.';
    }
    if (state.effectiveTo != null && state.effectiveFrom != null && state.effectiveTo!.isBefore(state.effectiveFrom!)) {
      errors[fieldEffectiveTo] = 'Effective to date cannot be earlier than effective from date.';
    }

    return errors;
  }
}

final createCompensationPlanProvider =
    AutoDisposeNotifierProvider<CreateCompensationPlanNotifier, CreateCompensationPlanState>(
      CreateCompensationPlanNotifier.new,
    );
