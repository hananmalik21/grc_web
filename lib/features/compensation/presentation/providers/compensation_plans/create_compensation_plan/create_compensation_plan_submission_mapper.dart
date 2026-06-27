import 'package:grc/features/compensation/data/dto/compensation_plans/create_compensation_plan_request_dto.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_company_scope_provider.dart';

import 'create_compensation_plan_state.dart';

class CreateCompensationPlanSubmissionMapper {
  static const String _createdBy = 'ADMIN';

  static ({CreateCompensationPlanRequestDto? request, String? error}) buildRequest({
    required CreateCompensationPlanState formState,
    required int enterpriseId,
    required CompensationPlanCompanyScopeSelectionState companyScope,
    required List<CompLookupValue> planAttributeLookupValues,
    required List<CompLookupValue> locationLookupValues,
    Map<int, String> componentFrequencies = const {},
    Map<int, String> componentPayBases = const {},
  }) {
    final planCode = formState.planCode.trim();
    final planName = formState.planName.trim();
    final planTypeCode = formState.planType.trim();
    final statusCode = formState.status.trim().toUpperCase();
    final currencyCode = formState.currency.trim();
    final startDate = formState.effectiveFrom == null ? null : _formatYyyyMmDd(formState.effectiveFrom!);
    final endDate = formState.effectiveTo == null ? null : _formatYyyyMmDd(formState.effectiveTo!);
    final topLevelBudgetAmount = _isBlank(formState.budgetAmount) ? 0 : num.tryParse(formState.budgetAmount.trim());
    final planOwner = formState.planOwnerEmployeeId;
    final countryCode = formState.eligibilityLocations.isNotEmpty ? formState.eligibilityLocations.first : null;

    if (planCode.isEmpty) return (request: null, error: 'Plan code is required.');
    if (planName.isEmpty) return (request: null, error: 'Plan name is required.');
    if (planTypeCode.isEmpty) return (request: null, error: 'Plan type is required.');
    if (statusCode.isEmpty) return (request: null, error: 'Status is required.');
    if (currencyCode.isEmpty) return (request: null, error: 'Currency is required.');
    if (topLevelBudgetAmount == null || topLevelBudgetAmount <= 0) {
      if (!_isBlank(formState.budgetAmount)) {
        return (request: null, error: 'A valid budget amount greater than 0 is required.');
      }
    }
    final resolvedBudgetAmount = topLevelBudgetAmount ?? 0;
    if (formState.selectedSalaryStructureId == null) {
      return (request: null, error: 'Salary structure is required.');
    }

    final countryLookup = countryCode == null || countryCode.trim().isEmpty
        ? null
        : _findLookupByCode(locationLookupValues, countryCode.trim());
    if (countryCode != null && countryCode.trim().isNotEmpty && countryLookup == null) {
      return (request: null, error: 'Selected country is not available in location lookup values.');
    }

    final attributes = formState.eligibilityPlanAttributes
        .map((code) => code.trim())
        .where((code) => code.isNotEmpty)
        .map((code) {
          final lookup = _findLookupByCode(planAttributeLookupValues, code);
          return CreateCompensationPlanAttributeDto(
            enterpriseId: enterpriseId,
            attributeCode: code,
            attributeValue: lookup?.valueName ?? code,
            createdBy: _createdBy,
          );
        })
        .toList();

    final positions = formState.eligibilityPositionIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .map(
          (id) => CreateCompensationPlanPositionDto(positionId: id, enterpriseId: enterpriseId, createdBy: _createdBy),
        )
        .toList();

    final businessUnits = companyScope
        .extractOrgUnitIdsForSubmission()
        .map(
          (orgUnitId) => CreateCompensationPlanBusinessUnitDto(
            enterpriseId: enterpriseId,
            orgUnitId: orgUnitId,
            createdBy: _createdBy,
          ),
        )
        .toList();

    for (final component in formState.selectedComponents) {
      if (componentFrequencies[component.componentId] == null) {
        return (request: null, error: 'Frequency is required for component "${component.componentName}".');
      }
    }

    final components = formState.selectedComponents.asMap().entries.map((entry) {
      final settings =
          formState.componentSettingsById[entry.value.componentId] ?? const CreateCompensationPlanComponentSettings();
      return CreateCompensationPlanComponentDto(
        componentId: entry.value.componentId,
        displaySequence: entry.key + 1,
        mandatoryFlag: settings.optional ? 'N' : 'Y',
        activeFlag: 'Y',
        frequencyCode: componentFrequencies[entry.value.componentId],
        payBasisCode: componentPayBases[entry.value.componentId],
        proratedFlag: settings.prorated ? 'Y' : 'N',
        taxableFlag: settings.taxable ? 'Y' : 'N',
        pensionableFlag: settings.pensionable ? 'Y' : 'N',
        statutoryFlag: settings.statutory ? 'Y' : 'N',
        includeInCtcFlag: settings.includeInCtc ? 'Y' : 'N',
        recurringFlag: settings.recurring ? 'Y' : 'N',
        optionalFlag: settings.optional ? 'Y' : 'N',
        amortizableFlag: settings.amortizable ? 'Y' : 'N',
        createdBy: _createdBy,
      );
    }).toList();

    final employmentTypes = formState.eligibilityContractTypes
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .map(
          (value) => CreateCompensationPlanEmploymentTypeDto(
            enterpriseId: enterpriseId,
            employmentTypeCode: _toCode(value),
            createdBy: _createdBy,
          ),
        )
        .toList();

    final grades = formState.eligibilityGradeIds
        .map((value) => int.tryParse(value.trim()))
        .whereType<int>()
        .map((id) => CreateCompensationPlanGradeDto(gradeId: id, createdBy: _createdBy))
        .toList();

    final jobFamilies = formState.eligibilityJobFamilies
        .map((value) => int.tryParse(value.trim()))
        .whereType<int>()
        .map(
          (id) =>
              CreateCompensationPlanJobFamilyDto(enterpriseId: enterpriseId, jobFamilyId: id, createdBy: _createdBy),
        )
        .toList();

    final locations = countryLookup == null
        ? const <CreateCompensationPlanLocationDto>[]
        : <CreateCompensationPlanLocationDto>[
            CreateCompensationPlanLocationDto(
              enterpriseId: enterpriseId,
              countryId: countryLookup.lookupValueId,
              createdBy: _createdBy,
            ),
          ];

    final salaryStructures = <CreateCompensationPlanSalaryStructureDto>[
      CreateCompensationPlanSalaryStructureDto(
        enterpriseId: enterpriseId,
        structureId: formState.selectedSalaryStructureId!,
        createdBy: _createdBy,
      ),
    ];

    final employeeAssignments = <CreateCompensationPlanEmployeeAssignmentDto>[];

    final request = CreateCompensationPlanRequestDto(
      enterpriseId: enterpriseId,
      countryId: countryLookup?.lookupValueId ?? 0,
      planCode: planCode,
      planName: planName,
      planTypeCode: planTypeCode,
      statusCode: statusCode,
      currencyCode: currencyCode,
      startDate: startDate,
      endDate: endDate,
      budgetAmount: resolvedBudgetAmount,
      description: formState.description.trim().isEmpty ? null : formState.description.trim(),
      planOwner: planOwner,
      createdBy: _createdBy,
      attributes: attributes,
      budget: CreateCompensationPlanBudgetDto(
        budgetAmount: resolvedBudgetAmount,
        currencyCode: currencyCode,
        createdBy: _createdBy,
      ),
      positions: positions,
      businessUnits: businessUnits,
      components: components,
      eligibility: const CreateCompensationPlanEligibilityDto(allEmployeesFlag: 'Y', createdBy: _createdBy),
      employmentTypes: employmentTypes,
      grades: grades,
      jobFamilies: jobFamilies,
      locations: locations,
      salaryStructures: salaryStructures,
      employeeAssignments: employeeAssignments,
    );

    return (request: request, error: null);
  }

  static CompLookupValue? _findLookupByCode(List<CompLookupValue> values, String code) {
    for (final value in values) {
      if (value.valueCode.trim() == code) return value;
    }
    for (final value in values) {
      if (value.lookupValueId.toString() == code) return value;
    }
    return null;
  }

  static String _toCode(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return normalized;
    if (RegExp(r'^[A-Z0-9_]+$').hasMatch(normalized)) {
      return normalized;
    }

    return normalized.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '_');
  }

  static String _formatYyyyMmDd(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}
