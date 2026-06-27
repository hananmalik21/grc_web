import 'package:grc/features/compensation/domain/models/components/comp_component.dart';

class SalaryStructureCreationState {
  final int currentStep;

  // Step 1: Basic Information
  final String name;
  final String code;
  final String description;
  final String? type;

  // Step 2: Scope & Assignment
  final String? country;
  final String? businessUnit;
  final List<String> businessUnits;
  final String? department;
  final String? category;
  final List<String> employeeCategories;
  final List<String> contractTypes;
  final String? grade;
  final List<int> jobFamilyIds;
  final List<String> positionIds;
  final List<int> gradeIds;

  // Step 3: Components
  final Set<String> selectedComponentCodes;
  final List<CompComponent> selectedComponents;

  // Step 4: Financial Details
  final String? currency;
  final String? frequency;
  final String? calcBase;
  final String costCenter;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final String annualBudget;

  // Step 5: Advanced Settings
  final bool payrollIntegrationEnabled;
  final bool autoCalculateComponentsEnabled;
  final bool versionControlEnabled;
  final bool multiStageApprovalEnabled;
  final bool auditLoggingEnabled;
  final bool manualOverridesEnabled;

  const SalaryStructureCreationState({
    this.currentStep = 0,
    this.name = '',
    this.code = '',
    this.description = '',
    this.type,
    this.country,
    this.businessUnit,
    this.businessUnits = const [],
    this.department,
    this.category,
    this.employeeCategories = const [],
    this.contractTypes = const [],
    this.grade,
    this.jobFamilyIds = const [],
    this.positionIds = const [],
    this.gradeIds = const [],
    this.selectedComponentCodes = const {},
    this.selectedComponents = const [],
    this.currency,
    this.frequency = 'Monthly',
    this.calcBase = 'Calendar Days',
    this.costCenter = '',
    this.effectiveFrom,
    this.effectiveTo,
    this.annualBudget = '',
    this.payrollIntegrationEnabled = false,
    this.autoCalculateComponentsEnabled = false,
    this.versionControlEnabled = false,
    this.multiStageApprovalEnabled = false,
    this.auditLoggingEnabled = false,
    this.manualOverridesEnabled = false,
  });

  SalaryStructureCreationState copyWith({
    int? currentStep,
    String? name,
    String? code,
    String? description,
    String? type,
    String? country,
    String? businessUnit,
    List<String>? businessUnits,
    String? department,
    String? category,
    List<String>? employeeCategories,
    List<String>? contractTypes,
    String? grade,
    List<int>? jobFamilyIds,
    List<String>? positionIds,
    List<int>? gradeIds,
    Set<String>? selectedComponentCodes,
    List<CompComponent>? selectedComponents,
    String? currency,
    String? frequency,
    String? calcBase,
    String? costCenter,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
    String? annualBudget,
    bool? payrollIntegrationEnabled,
    bool? autoCalculateComponentsEnabled,
    bool? versionControlEnabled,
    bool? multiStageApprovalEnabled,
    bool? auditLoggingEnabled,
    bool? manualOverridesEnabled,
  }) {
    return SalaryStructureCreationState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      type: type ?? this.type,
      country: country ?? this.country,
      businessUnit: businessUnit ?? this.businessUnit,
      businessUnits: businessUnits ?? this.businessUnits,
      department: department ?? this.department,
      category: category ?? this.category,
      employeeCategories: employeeCategories ?? this.employeeCategories,
      contractTypes: contractTypes ?? this.contractTypes,
      grade: grade ?? this.grade,
      jobFamilyIds: jobFamilyIds ?? this.jobFamilyIds,
      positionIds: positionIds ?? this.positionIds,
      gradeIds: gradeIds ?? this.gradeIds,
      selectedComponentCodes: selectedComponentCodes ?? this.selectedComponentCodes,
      selectedComponents: selectedComponents ?? this.selectedComponents,
      currency: currency ?? this.currency,
      frequency: frequency ?? this.frequency,
      calcBase: calcBase ?? this.calcBase,
      costCenter: costCenter ?? this.costCenter,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      annualBudget: annualBudget ?? this.annualBudget,
      payrollIntegrationEnabled: payrollIntegrationEnabled ?? this.payrollIntegrationEnabled,
      autoCalculateComponentsEnabled: autoCalculateComponentsEnabled ?? this.autoCalculateComponentsEnabled,
      versionControlEnabled: versionControlEnabled ?? this.versionControlEnabled,
      multiStageApprovalEnabled: multiStageApprovalEnabled ?? this.multiStageApprovalEnabled,
      auditLoggingEnabled: auditLoggingEnabled ?? this.auditLoggingEnabled,
      manualOverridesEnabled: manualOverridesEnabled ?? this.manualOverridesEnabled,
    );
  }
}
