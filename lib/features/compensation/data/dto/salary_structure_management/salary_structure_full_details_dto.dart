import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_org_scope_parser.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_full_details.dart';

class SalaryStructureFullDetailsDto {
  final int structureId;
  final String structureGuid;
  final int enterpriseId;
  final String structureCode;
  final String structureName;
  final String structureTypeCode;
  final String? description;
  final String currencyCode;
  final bool isActive;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final bool enablePayrollIntegration;
  final bool autoCalcComponents;
  final bool enableVersionControl;
  final bool requireMultiApproval;
  final bool enableAuditLogging;
  final bool allowManualOverride;
  final String? countryCode;
  final List<String> businessUnitIds;
  final Map<String, List<String>> companyToBusinessUnitsMap;
  final Map<String, String> companyNamesById;
  final List<String> employmentTypeCodes;
  final String? costCenterCode;
  final num? annualBudgetAmount;
  final List<int> gradeIds;
  final List<int> jobFamilyIds;
  final List<String> positionIds;
  final List<int> componentIds;

  const SalaryStructureFullDetailsDto({
    required this.structureId,
    required this.structureGuid,
    required this.enterpriseId,
    required this.structureCode,
    required this.structureName,
    required this.structureTypeCode,
    this.description,
    required this.currencyCode,
    required this.isActive,
    this.effectiveFrom,
    this.effectiveTo,
    required this.enablePayrollIntegration,
    required this.autoCalcComponents,
    required this.enableVersionControl,
    required this.requireMultiApproval,
    required this.enableAuditLogging,
    required this.allowManualOverride,
    this.countryCode,
    required this.businessUnitIds,
    required this.companyToBusinessUnitsMap,
    required this.companyNamesById,
    required this.employmentTypeCodes,
    this.costCenterCode,
    this.annualBudgetAmount,
    required this.gradeIds,
    required this.jobFamilyIds,
    required this.positionIds,
    required this.componentIds,
  });

  factory SalaryStructureFullDetailsDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final structure = data['structure'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final advSettings = data['advanced_settings'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final orgScopes = (data['org_scopes'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();
    final employmentTypes = (data['employment_types'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final orgScopeResult = SalaryStructureOrgScopeParser.parse(orgScopes: orgScopes, employmentTypes: employmentTypes);
    final financialDetailsList = (data['financial_details'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final gradeRanges = (data['grade_ranges'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();
    final jobFamiliesList = (data['job_families'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final positionsList = (data['positions'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();
    final componentsList = (data['components'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final fin = financialDetailsList.isNotEmpty ? financialDetailsList.first : const <String, dynamic>{};

    final gradeIds = gradeRanges
        .map((g) => (g['grade_id'] as num?)?.toInt() ?? 0)
        .where((id) => id > 0)
        .toSet()
        .toList();

    final jobFamilyIds = jobFamiliesList
        .map((j) => (j['job_family_id'] as num?)?.toInt() ?? 0)
        .where((id) => id > 0)
        .toList();

    final positionIds = positionsList
        .map((p) => (p['position_id'] as String?) ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    final componentIds = componentsList
        .map((c) => (c['component_id'] as num?)?.toInt() ?? 0)
        .where((id) => id > 0)
        .toList();

    return SalaryStructureFullDetailsDto(
      structureId: (data['structure_id'] as num?)?.toInt() ?? 0,
      structureGuid: (data['structure_guid'] as String?) ?? '',
      enterpriseId: (data['enterprise_id'] as num?)?.toInt() ?? 0,
      structureCode: (data['structure_code'] as String?) ?? '',
      structureName: (data['structure_name'] as String?) ?? '',
      structureTypeCode: (data['structure_type_code'] as String?) ?? '',
      description: structure['description'] as String?,
      currencyCode: (structure['currency_code'] as String?) ?? '',
      isActive: _isYes(data['active_flag']),
      effectiveFrom: _parseDate(structure['effective_from']),
      effectiveTo: _parseDate(structure['effective_to']),
      enablePayrollIntegration: _isYes(advSettings['enable_payroll_integration']),
      autoCalcComponents: _isYes(advSettings['auto_calc_components']),
      enableVersionControl: _isYes(advSettings['enable_version_control']),
      requireMultiApproval: _isYes(advSettings['require_multi_approval']),
      enableAuditLogging: _isYes(advSettings['enable_audit_logging']),
      allowManualOverride: _isYes(advSettings['allow_manual_override']),
      countryCode: orgScopeResult.countryCode,
      businessUnitIds: orgScopeResult.allOrgUnitIds,
      companyToBusinessUnitsMap: orgScopeResult.companyToBusinessUnitIds,
      companyNamesById: orgScopeResult.companyNamesById,
      employmentTypeCodes: orgScopeResult.employmentTypeCodes,
      costCenterCode: fin['cost_center_code'] as String?,
      annualBudgetAmount: fin['annual_budget_amount'] as num?,
      gradeIds: gradeIds,
      jobFamilyIds: jobFamilyIds,
      positionIds: positionIds,
      componentIds: componentIds,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return null;
    }
  }

  SalaryStructureFullDetails toDomain() {
    return SalaryStructureFullDetails(
      structureId: structureId,
      structureGuid: structureGuid,
      enterpriseId: enterpriseId,
      structureCode: structureCode,
      structureName: structureName,
      structureTypeCode: structureTypeCode,
      description: description,
      currencyCode: currencyCode,
      isActive: isActive,
      effectiveFrom: effectiveFrom,
      effectiveTo: effectiveTo,
      enablePayrollIntegration: enablePayrollIntegration,
      autoCalcComponents: autoCalcComponents,
      enableVersionControl: enableVersionControl,
      requireMultiApproval: requireMultiApproval,
      enableAuditLogging: enableAuditLogging,
      allowManualOverride: allowManualOverride,
      countryCode: countryCode,
      businessUnitIds: businessUnitIds,
      companyToBusinessUnitsMap: companyToBusinessUnitsMap,
      companyNamesById: companyNamesById,
      employmentTypeCodes: employmentTypeCodes,
      costCenterCode: costCenterCode,
      annualBudgetAmount: annualBudgetAmount,
      gradeIds: gradeIds,
      jobFamilyIds: jobFamilyIds,
      positionIds: positionIds,
      componentIds: componentIds,
    );
  }

  static bool _isYes(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString().trim().toUpperCase() == 'Y';
  }
}
