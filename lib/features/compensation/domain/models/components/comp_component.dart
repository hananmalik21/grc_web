class CompComponent {
  final int componentId;
  final String componentGuid;
  final String componentCode;
  final String componentName;
  final String description;
  final int planUsageCount;
  final String componentTypeCode;
  final String calculationMethodCode;
  final String status;
  final String compCategoryCode;
  final String? formulaName;
  final String? payBasis;
  final String? currencyCode;
  final String? baseAmountSource;
  final num? minValue;
  final num? maxValue;
  final List<String> locationCodes;
  final int? tenantId;
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String componentActiveFlag;
  final int? advSettingId;
  final String? advSettingGuid;
  final String recurringFlag;
  final String optionalFlag;
  final String pensionableFlag;
  final String statutoryFlag;
  final String includeInCtcFlag;
  final String proratedFlag;
  final String taxableFlag;
  final String amortizableFlag;
  final String advActiveFlag;
  final String? createdBy;
  final DateTime? creationDate;
  final String? lastUpdatedBy;
  final DateTime? lastUpdateDate;

  const CompComponent({
    required this.componentId,
    required this.componentGuid,
    required this.componentCode,
    required this.componentName,
    this.description = '---',
    this.planUsageCount = 0,
    required this.componentTypeCode,
    required this.calculationMethodCode,
    required this.status,
    required this.compCategoryCode,
    this.formulaName,
    this.payBasis,
    this.currencyCode,
    this.baseAmountSource,
    this.minValue,
    this.maxValue,
    this.locationCodes = const [],
    this.tenantId,
    this.effectiveStartDate,
    this.effectiveEndDate,
    required this.componentActiveFlag,
    this.advSettingId,
    this.advSettingGuid,
    this.recurringFlag = 'N',
    this.optionalFlag = 'N',
    this.pensionableFlag = 'N',
    this.statutoryFlag = 'N',
    this.includeInCtcFlag = 'N',
    this.proratedFlag = 'N',
    this.taxableFlag = 'N',
    this.amortizableFlag = 'N',
    this.advActiveFlag = 'N',
    this.createdBy,
    this.creationDate,
    this.lastUpdatedBy,
    this.lastUpdateDate,
  });
}
