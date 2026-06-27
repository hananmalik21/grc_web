import 'package:grc/features/compensation/data/dto/salary_structure_management/create_salary_structure_request_dto.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';

import 'salary_structure_creation_state.dart';

class SalaryStructureSubmissionMapper {
  static ({CreateSalaryStructureRequestDto? request, String? error}) buildRequest({
    required SalaryStructureCreationState formState,
    required int enterpriseId,
    required List<CompLookupValue> countryLookupValues,
  }) {
    final structureCode = formState.code.trim();
    final structureName = formState.name.trim();
    final structureTypeCode = formState.type?.trim() ?? '';
    final currencyCode = formState.currency?.trim() ?? '';
    final countryCode = formState.country?.trim() ?? '';
    final businessUnits = formState.businessUnits.where((e) => e.trim().isNotEmpty).toList();
    final employeeCategories = formState.contractTypes.where((e) => e.trim().isNotEmpty).toList();
    final description = formState.description.trim();
    final costCenterCode = formState.costCenter.trim();
    final annualBudget = num.tryParse(formState.annualBudget.trim());

    if (structureCode.isEmpty || structureName.isEmpty || structureTypeCode.isEmpty) {
      return (request: null, error: 'Basic information is incomplete.');
    }
    if (countryCode.isEmpty) {
      return (request: null, error: 'Scope and assignment is incomplete.');
    }
    if (currencyCode.isEmpty || costCenterCode.isEmpty || formState.effectiveFrom == null || annualBudget == null) {
      return (request: null, error: 'Financial details are incomplete.');
    }

    final country = _findCountry(countryLookupValues, countryCode);
    if (country == null) {
      return (request: null, error: 'Selected country is not available.');
    }

    // Build components array from selected components
    final components = _buildComponentsArray(formState.selectedComponents);

    final request = CreateSalaryStructureRequestDto(
      structureCode: structureCode,
      structureName: structureName,
      structureTypeCode: structureTypeCode,
      currencyCode: currencyCode,
      countryId: country.lookupValueId,
      enterpriseId: enterpriseId,
      description: description.isEmpty ? null : description,
      status: 'ACTIVE',
      activeFlag: 'Y',
      effectiveFrom: _formatYyyyMmDd(formState.effectiveFrom!),
      effectiveTo: formState.effectiveTo == null ? null : _formatYyyyMmDd(formState.effectiveTo!),
      advancedSettings: CreateSalaryStructureAdvancedSettingsDto(
        enablePayrollIntegration: _boolFlag(formState.payrollIntegrationEnabled),
        autoCalcComponents: _boolFlag(formState.autoCalculateComponentsEnabled),
        enableVersionControl: _boolFlag(formState.versionControlEnabled),
        requireMultiApproval: _boolFlag(formState.multiStageApprovalEnabled),
        enableAuditLogging: _boolFlag(formState.auditLoggingEnabled),
        allowManualOverride: _boolFlag(formState.manualOverridesEnabled),
      ),
      financialDetails: CreateSalaryStructureFinancialDetailsDto(
        costCenterCode: costCenterCode,
        effectiveFrom: _formatYyyyMmDd(formState.effectiveFrom!),
        effectiveTo: formState.effectiveTo == null ? null : _formatYyyyMmDd(formState.effectiveTo!),
        annualBudgetAmount: annualBudget,
      ),
      orgScope: CreateSalaryStructureOrgScopeDto(
        countryCode: country.valueCode,
        businessUnits: businessUnits,
        employeeCategories: employeeCategories,
      ),
      jobFamilyIds: formState.jobFamilyIds,
      positionIds: formState.positionIds,
      gradeRanges: formState.gradeIds.map((id) => <String, dynamic>{'grade_id': id}).toList(),
      components: components,
    );

    return (request: request, error: null);
  }

  static List<Map<String, dynamic>> _buildComponentsArray(List<CompComponent> components) {
    return components
        .asMap()
        .entries
        .map(
          (entry) => <String, dynamic>{
            'component_id': entry.value.componentId,
            'display_sequence': entry.key + 1, // 1-based sequence
            'calculation_method_code': entry.value.calculationMethodCode,
            'default_value': 0,
            'min_value': entry.value.minValue ?? 0,
            'max_value': entry.value.maxValue ?? 0,
            'active_flag': entry.value.componentActiveFlag,
          },
        )
        .toList();
  }

  static CompLookupValue? _findCountry(List<CompLookupValue> values, String countryCode) {
    for (final value in values) {
      if (value.valueCode.trim() == countryCode) {
        return value;
      }
    }
    return null;
  }

  static String _boolFlag(bool value) => value ? 'Y' : 'N';

  static String _formatYyyyMmDd(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
