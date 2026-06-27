class SalaryStructureFullDetails {
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

  /// Maps each company org unit ID to selected business unit IDs under it.
  final Map<String, List<String>> companyToBusinessUnitsMap;
  final Map<String, String> companyNamesById;
  final List<String> employmentTypeCodes;
  final String? costCenterCode;
  final num? annualBudgetAmount;
  final List<int> gradeIds;
  final List<int> jobFamilyIds;
  final List<String> positionIds;
  final List<int> componentIds;

  const SalaryStructureFullDetails({
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
}
