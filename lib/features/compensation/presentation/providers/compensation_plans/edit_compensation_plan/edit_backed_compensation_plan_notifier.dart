import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_state.dart';

class EditBackedCompensationPlanNotifier extends CreateCompensationPlanNotifier {
  final CompensationPlan plan;

  EditBackedCompensationPlanNotifier(this.plan);

  @override
  CreateCompensationPlanState build() => _stateFromPlan(plan);

  static CreateCompensationPlanState _stateFromPlan(CompensationPlan plan) {
    final salaryStructure = plan.salaryStructures?.isNotEmpty == true ? plan.salaryStructures!.first : null;

    final components = (plan.components ?? []).toList()..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));

    final initialFrequencyCodes = <int, String>{
      for (final pc in components)
        if (pc.frequencyCode != null && pc.frequencyCode!.trim().isNotEmpty) pc.componentId: pc.frequencyCode!.trim(),
    };

    final initialPayBaseCodes = <int, String>{
      for (final pc in components)
        if (pc.advancedSettings?.payBasis?.trim().isNotEmpty == true)
          pc.componentId: pc.advancedSettings!.payBasis!.trim(),
    };

    final initialComponentSettings = <int, CreateCompensationPlanComponentSettings>{
      for (final pc in components)
        pc.componentId: CreateCompensationPlanComponentSettings.fromPlanAdvancedSettings(
          pc.advancedSettings,
          planComponentActive: pc.isActive,
        ),
    };

    final mappedComponents = components
        .map(
          (pc) => CompComponent(
            componentId: pc.componentId,
            componentGuid: pc.component?.guid ?? '',
            componentCode: pc.component?.code ?? pc.componentId.toString(),
            componentName: pc.component?.name ?? 'Component #${pc.componentId}',
            description: pc.component?.description ?? '',
            componentTypeCode: pc.component?.typeCode ?? '',
            calculationMethodCode: pc.component?.calculationMethod ?? '',
            status: pc.component?.status ?? '',
            compCategoryCode: pc.component?.categoryCode ?? '-',
            minValue: pc.component?.minValue,
            maxValue: pc.component?.maxValue,
            componentActiveFlag: 'Y',
          ),
        )
        .toList();

    final componentCodes = mappedComponents.map((c) => c.componentCode).toSet();

    final statusDisplay = plan.statusCode.trim().toUpperCase();
    final budgetStr = plan.budgetAmount != null && plan.budgetAmount! > 0 ? plan.budgetAmount!.toStringAsFixed(0) : '';
    final ownerName = plan.owner?.fullNameEn.trim().isNotEmpty == true
        ? plan.owner!.fullNameEn.trim()
        : (plan.ownerEmployeeId != null ? 'Employee #${plan.ownerEmployeeId}' : null);

    final gradeIds = (plan.grades ?? []).map((g) => g.gradeId.toString()).toList();
    final positionIds = (plan.positions ?? []).map((p) => p.positionId).toList();
    final employmentTypes = (plan.employmentTypes ?? []).map((e) => e.typeCode).toList();
    final jobFamilies = (plan.jobFamilies ?? []).map((jf) => jf.jobFamilyId.toString()).toList();
    final attributes = (plan.attributes ?? []).map((a) => a.attributeCode).toList();
    final locations = (plan.locations ?? []).where((l) => l.countryId > 0).map((l) => l.countryId.toString()).toList();

    final structureGuid = salaryStructure?.structure?.guid;

    return CreateCompensationPlanState(
      isEditMode: true,
      currentStep: 0,
      planName: plan.planName,
      planCode: plan.planCode,
      description: plan.description ?? '',
      planType: plan.planTypeCode,
      status: statusDisplay,
      currency: plan.currencyCode,
      budgetAmount: budgetStr,
      planOwner: ownerName,
      planOwnerEmployeeId: plan.ownerEmployeeId,
      effectiveFrom: plan.startDate,
      effectiveTo: plan.endDate,
      fieldErrors: const {},
      selectedSalaryStructure: salaryStructure?.structure?.name,
      selectedSalaryStructureId: salaryStructure?.structureId,
      selectedSalaryStructureGuid: structureGuid,
      eligibilityPrefilledFromSalaryStructureGuid: structureGuid,
      eligibilityStructureType: salaryStructure?.structure?.structureTypeCode ?? '',
      eligibilityGradeIds: gradeIds,
      eligibilityPositionIds: positionIds,
      eligibilityContractTypes: employmentTypes,
      eligibilityJobFamilies: jobFamilies,
      eligibilityPlanAttributes: attributes,
      eligibilityLocations: locations,
      eligibilityFromGrade: null,
      eligibilityToGrade: null,
      selectedComponentCodes: componentCodes,
      selectedComponents: mappedComponents,
      initialComponentFrequencyCodes: initialFrequencyCodes,
      initialComponentPayBaseCodes: initialPayBaseCodes,
      componentSettingsById: initialComponentSettings,
      assignedEmployees: const [],
    );
  }
}
