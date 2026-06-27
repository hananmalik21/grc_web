import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_detail_component.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';

class CreateCompensationPlanComponentSettings {
  final bool recurring;
  final bool optional;
  final bool isActive;
  final bool pensionable;
  final bool statutory;
  final bool includeInCtc;
  final bool prorated;
  final bool taxable;
  final bool amortizable;

  const CreateCompensationPlanComponentSettings({
    this.recurring = false,
    this.optional = false,
    this.isActive = true,
    this.pensionable = false,
    this.statutory = false,
    this.includeInCtc = false,
    this.prorated = false,
    this.taxable = false,
    this.amortizable = false,
  });

  CreateCompensationPlanComponentSettings copyWith({
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
    return CreateCompensationPlanComponentSettings(
      recurring: recurring ?? this.recurring,
      optional: optional ?? this.optional,
      isActive: isActive ?? this.isActive,
      pensionable: pensionable ?? this.pensionable,
      statutory: statutory ?? this.statutory,
      includeInCtc: includeInCtc ?? this.includeInCtc,
      prorated: prorated ?? this.prorated,
      taxable: taxable ?? this.taxable,
      amortizable: amortizable ?? this.amortizable,
    );
  }

  factory CreateCompensationPlanComponentSettings.fromPlanAdvancedSettings(
    PlanComponentAdvancedSettings? advancedSettings, {
    bool planComponentActive = true,
  }) {
    if (advancedSettings == null) {
      return CreateCompensationPlanComponentSettings(isActive: planComponentActive);
    }

    return CreateCompensationPlanComponentSettings(
      recurring: advancedSettings.recurring,
      optional: advancedSettings.optional,
      pensionable: advancedSettings.pensionable,
      statutory: advancedSettings.statutory,
      includeInCtc: advancedSettings.includeInCtc,
      prorated: advancedSettings.prorated,
      taxable: advancedSettings.taxable,
      amortizable: advancedSettings.amortizable,
      isActive: advancedSettings.isActive && planComponentActive,
    );
  }

  factory CreateCompensationPlanComponentSettings.forComponentCard({
    required CreateCompensationPlanState planState,
    required SalaryStructureDetailComponent component,
  }) {
    final fromPlan = planState.componentSettingsById[component.componentId];
    if (fromPlan != null) return fromPlan;

    if (planState.isEditMode) {
      return const CreateCompensationPlanComponentSettings();
    }

    final advanced = component.advancedSettings;
    return CreateCompensationPlanComponentSettings(
      recurring: advanced?.isRecurring ?? false,
      optional: advanced?.isOptional ?? false,
      isActive: advanced?.isActive ?? component.isActive,
      pensionable: advanced?.isPensionable ?? false,
      statutory: advanced?.isStatutory ?? false,
      includeInCtc: advanced?.isIncludedInCtc ?? false,
      prorated: advanced?.isProrated ?? false,
      taxable: advanced?.isTaxable ?? false,
      amortizable: advanced?.isAmortizable ?? false,
    );
  }
}

class CreateCompensationPlanState {
  static const Object _unset = Object();

  final int currentStep;
  final String planName;
  final String planCode;
  final String description;
  final String planType;
  final String status;
  final String currency;
  final String budgetAmount;
  final String? planOwner;
  final int? planOwnerEmployeeId;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final Map<String, String> fieldErrors;
  final String? selectedSalaryStructure;
  final int? selectedSalaryStructureId;
  final String? selectedSalaryStructureGuid;
  final String? eligibilityPrefilledFromSalaryStructureGuid;
  final String eligibilityStructureType;
  final List<String> eligibilityCompensationCategories;
  final List<String> eligibilityBusinessUnits;
  final List<String> eligibilityContractTypes;
  final List<String> eligibilityGradeIds;
  final List<String> eligibilityPositionIds;
  final String? eligibilityFromGrade;
  final String? eligibilityToGrade;
  final List<String> eligibilityLocations;
  final List<String> eligibilityPlanAttributes;
  final List<String> eligibilityJobFamilies;
  final Set<String> selectedComponentCodes;
  final List<CompComponent> selectedComponents;
  final Map<int, String> initialComponentFrequencyCodes;
  final Map<int, String> initialComponentPayBaseCodes;
  final Map<int, CompLookupValue> componentFrequencies;
  final Map<int, CompLookupValue> componentPayBases;
  final Map<int, CreateCompensationPlanComponentSettings> componentSettingsById;
  final List<Employee> assignedEmployees;
  final bool isEditMode;

  CreateCompensationPlanState({
    this.currentStep = 0,
    this.planName = '',
    this.planCode = '',
    this.description = '',
    this.planType = '',
    this.status = 'ACTIVE',
    this.currency = '',
    this.budgetAmount = '',
    this.planOwner,
    this.planOwnerEmployeeId,
    this.effectiveFrom,
    this.effectiveTo,
    this.fieldErrors = const {},
    this.selectedSalaryStructure,
    this.selectedSalaryStructureId,
    this.selectedSalaryStructureGuid,
    this.eligibilityPrefilledFromSalaryStructureGuid,
    this.eligibilityStructureType = '',
    this.eligibilityCompensationCategories = const [],
    this.eligibilityBusinessUnits = const [],
    this.eligibilityContractTypes = const [],
    this.eligibilityGradeIds = const [],
    this.eligibilityPositionIds = const [],
    this.eligibilityFromGrade,
    this.eligibilityToGrade,
    this.eligibilityLocations = const [],
    this.eligibilityPlanAttributes = const [],
    this.eligibilityJobFamilies = const [],
    this.selectedComponentCodes = const {},
    this.selectedComponents = const [],
    this.initialComponentFrequencyCodes = const {},
    this.initialComponentPayBaseCodes = const {},
    this.componentFrequencies = const {},
    this.componentPayBases = const {},
    this.componentSettingsById = const {},
    this.assignedEmployees = const [],
    this.isEditMode = false,
  });

  CreateCompensationPlanState copyWith({
    int? currentStep,
    String? planName,
    String? planCode,
    String? description,
    String? planType,
    String? status,
    String? currency,
    String? budgetAmount,
    String? planOwner,
    int? planOwnerEmployeeId,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
    Map<String, String>? fieldErrors,
    Object? selectedSalaryStructure = _unset,
    Object? selectedSalaryStructureId = _unset,
    Object? selectedSalaryStructureGuid = _unset,
    Object? eligibilityPrefilledFromSalaryStructureGuid = _unset,
    String? eligibilityStructureType,
    List<String>? eligibilityCompensationCategories,
    List<String>? eligibilityBusinessUnits,
    List<String>? eligibilityContractTypes,
    List<String>? eligibilityGradeIds,
    List<String>? eligibilityPositionIds,
    String? eligibilityFromGrade,
    String? eligibilityToGrade,
    List<String>? eligibilityLocations,
    List<String>? eligibilityPlanAttributes,
    List<String>? eligibilityJobFamilies,
    Set<String>? selectedComponentCodes,
    List<CompComponent>? selectedComponents,
    Map<int, String>? initialComponentFrequencyCodes,
    Map<int, String>? initialComponentPayBaseCodes,
    Map<int, CompLookupValue>? componentFrequencies,
    Map<int, CompLookupValue>? componentPayBases,
    Map<int, CreateCompensationPlanComponentSettings>? componentSettingsById,
    List<Employee>? assignedEmployees,
    bool? isEditMode,
  }) {
    return CreateCompensationPlanState(
      currentStep: currentStep ?? this.currentStep,
      planName: planName ?? this.planName,
      planCode: planCode ?? this.planCode,
      description: description ?? this.description,
      planType: planType ?? this.planType,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      planOwner: planOwner ?? this.planOwner,
      planOwnerEmployeeId: planOwnerEmployeeId ?? this.planOwnerEmployeeId,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      selectedSalaryStructure: identical(selectedSalaryStructure, _unset)
          ? this.selectedSalaryStructure
          : selectedSalaryStructure as String?,
      selectedSalaryStructureId: identical(selectedSalaryStructureId, _unset)
          ? this.selectedSalaryStructureId
          : selectedSalaryStructureId as int?,
      selectedSalaryStructureGuid: identical(selectedSalaryStructureGuid, _unset)
          ? this.selectedSalaryStructureGuid
          : selectedSalaryStructureGuid as String?,
      eligibilityPrefilledFromSalaryStructureGuid: identical(eligibilityPrefilledFromSalaryStructureGuid, _unset)
          ? this.eligibilityPrefilledFromSalaryStructureGuid
          : eligibilityPrefilledFromSalaryStructureGuid as String?,
      eligibilityStructureType: eligibilityStructureType ?? this.eligibilityStructureType,
      eligibilityCompensationCategories: eligibilityCompensationCategories ?? this.eligibilityCompensationCategories,
      eligibilityBusinessUnits: eligibilityBusinessUnits ?? this.eligibilityBusinessUnits,
      eligibilityContractTypes: eligibilityContractTypes ?? this.eligibilityContractTypes,
      eligibilityGradeIds: eligibilityGradeIds ?? this.eligibilityGradeIds,
      eligibilityPositionIds: eligibilityPositionIds ?? this.eligibilityPositionIds,
      eligibilityFromGrade: eligibilityFromGrade ?? this.eligibilityFromGrade,
      eligibilityToGrade: eligibilityToGrade ?? this.eligibilityToGrade,
      eligibilityLocations: eligibilityLocations ?? this.eligibilityLocations,
      eligibilityPlanAttributes: eligibilityPlanAttributes ?? this.eligibilityPlanAttributes,
      eligibilityJobFamilies: eligibilityJobFamilies ?? this.eligibilityJobFamilies,
      selectedComponentCodes: selectedComponentCodes ?? this.selectedComponentCodes,
      selectedComponents: selectedComponents ?? this.selectedComponents,
      initialComponentFrequencyCodes: initialComponentFrequencyCodes ?? this.initialComponentFrequencyCodes,
      initialComponentPayBaseCodes: initialComponentPayBaseCodes ?? this.initialComponentPayBaseCodes,
      componentFrequencies: componentFrequencies ?? this.componentFrequencies,
      componentPayBases: componentPayBases ?? this.componentPayBases,
      componentSettingsById: componentSettingsById ?? this.componentSettingsById,
      assignedEmployees: assignedEmployees ?? this.assignedEmployees,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }
}
