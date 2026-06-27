class CreateSalaryStructureAdvancedSettingsDto {
  final String enablePayrollIntegration;
  final String autoCalcComponents;
  final String enableVersionControl;
  final String requireMultiApproval;
  final String enableAuditLogging;
  final String allowManualOverride;

  const CreateSalaryStructureAdvancedSettingsDto({
    required this.enablePayrollIntegration,
    required this.autoCalcComponents,
    required this.enableVersionControl,
    required this.requireMultiApproval,
    required this.enableAuditLogging,
    required this.allowManualOverride,
  });

  Map<String, dynamic> toJson() {
    return {
      'enable_payroll_integration': enablePayrollIntegration,
      'auto_calc_components': autoCalcComponents,
      'enable_version_control': enableVersionControl,
      'require_multi_approval': requireMultiApproval,
      'enable_audit_logging': enableAuditLogging,
      'allow_manual_override': allowManualOverride,
    };
  }
}

class CreateSalaryStructureFinancialDetailsDto {
  final String costCenterCode;
  final String? effectiveFrom;
  final String? effectiveTo;
  final num annualBudgetAmount;

  const CreateSalaryStructureFinancialDetailsDto({
    required this.costCenterCode,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.annualBudgetAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'cost_center_code': costCenterCode,
      'effective_from': effectiveFrom,
      'effective_to': effectiveTo,
      'annual_budget_amount': annualBudgetAmount,
    };
  }
}

class CreateSalaryStructureOrgScopeDto {
  final String countryCode;
  final List<String> businessUnits;
  final List<String> employeeCategories;

  const CreateSalaryStructureOrgScopeDto({
    required this.countryCode,
    required this.businessUnits,
    required this.employeeCategories,
  });

  Map<String, dynamic> toJson() {
    return {'country_code': countryCode, 'business_units': businessUnits, 'employment_types': employeeCategories};
  }
}

class CreateSalaryStructureRequestDto {
  final String structureCode;
  final String structureName;
  final String structureTypeCode;
  final String currencyCode;
  final int countryId;
  final int enterpriseId;
  final String? description;
  final String status;
  final String activeFlag;
  final String? effectiveFrom;
  final String? effectiveTo;
  final CreateSalaryStructureAdvancedSettingsDto advancedSettings;
  final CreateSalaryStructureFinancialDetailsDto financialDetails;
  final CreateSalaryStructureOrgScopeDto orgScope;
  final List<int> jobFamilyIds;
  final List<String> positionIds;
  final List<Map<String, dynamic>> gradeRanges;
  final List<Map<String, dynamic>> components;

  const CreateSalaryStructureRequestDto({
    required this.structureCode,
    required this.structureName,
    required this.structureTypeCode,
    required this.currencyCode,
    required this.countryId,
    required this.enterpriseId,
    required this.description,
    required this.status,
    required this.activeFlag,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.advancedSettings,
    required this.financialDetails,
    required this.orgScope,
    required this.jobFamilyIds,
    required this.positionIds,
    required this.gradeRanges,
    required this.components,
  });

  Map<String, dynamic> toJson() {
    return {
      'structure_code': structureCode,
      'structure_name': structureName,
      'structure_type_code': structureTypeCode,
      'currency_code': currencyCode,
      'country_id': countryId,
      'enterprise_id': enterpriseId,
      'description': description,
      'status': status,
      'active_flag': activeFlag,
      'effective_from': effectiveFrom,
      'effective_to': effectiveTo,
      'advanced_settings': advancedSettings.toJson(),
      'financial_details': financialDetails.toJson(),
      'org_scope': orgScope.toJson(),
      'job_family_ids': jobFamilyIds,
      'position_ids': positionIds,
      'grade_ranges': gradeRanges,
      'components': components,
    };
  }
}
