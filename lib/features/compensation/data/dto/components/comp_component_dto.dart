import 'package:grc/features/compensation/domain/models/components/comp_component.dart';

class CompComponentDto {
  final int componentId;
  final String componentGuid;
  final String componentCode;
  final String componentName;
  final String? description;
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

  const CompComponentDto({
    required this.componentId,
    required this.componentGuid,
    required this.componentCode,
    required this.componentName,
    required this.description,
    required this.planUsageCount,
    required this.componentTypeCode,
    required this.calculationMethodCode,
    required this.status,
    required this.compCategoryCode,
    required this.formulaName,
    required this.payBasis,
    required this.currencyCode,
    required this.baseAmountSource,
    required this.minValue,
    required this.maxValue,
    this.locationCodes = const [],
    required this.tenantId,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.componentActiveFlag,
    required this.advSettingId,
    required this.advSettingGuid,
    required this.recurringFlag,
    required this.optionalFlag,
    required this.pensionableFlag,
    required this.statutoryFlag,
    required this.includeInCtcFlag,
    required this.proratedFlag,
    required this.taxableFlag,
    required this.amortizableFlag,
    required this.advActiveFlag,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
  });

  factory CompComponentDto.fromJson(Map<String, dynamic> json) {
    return CompComponentDto(
      componentId: (json['component_id'] as num?)?.toInt() ?? 0,
      componentGuid: (json['component_guid'] as String?) ?? '',
      componentCode: (json['component_code'] as String?) ?? '',
      componentName: (json['component_name'] as String?) ?? '',
      description: json['description'] as String?,
      planUsageCount: (json['plan_usage_count'] as num?)?.toInt() ?? 0,
      componentTypeCode: (json['component_type_code'] as String?) ?? '',
      calculationMethodCode: (json['calculation_method_code'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      compCategoryCode: (json['comp_category_code'] as String?) ?? '',
      formulaName: json['formula_name'] as String?,
      payBasis: json['pay_basis'] as String?,
      currencyCode: json['currency_code'] as String?,
      baseAmountSource: json['base_amount_source'] as String?,
      minValue: json['min_value'] as num?,
      maxValue: json['max_value'] as num?,
      locationCodes: (json['location_codes'] as List<dynamic>?)?.whereType<String>().toList() ?? const [],
      tenantId: (json['tenant_id'] as num?)?.toInt(),
      effectiveStartDate: json['effective_start_date'] != null
          ? DateTime.tryParse(json['effective_start_date'] as String)
          : null,
      effectiveEndDate: json['effective_end_date'] != null
          ? DateTime.tryParse(json['effective_end_date'] as String)
          : null,
      componentActiveFlag: (json['component_active_flag'] as String?) ?? 'N',
      advSettingId: (json['adv_setting_id'] as num?)?.toInt(),
      advSettingGuid: json['adv_setting_guid'] as String?,
      recurringFlag: (json['recurring_flag'] as String?) ?? 'N',
      optionalFlag: (json['optional_flag'] as String?) ?? 'N',
      pensionableFlag: (json['pensionable_flag'] as String?) ?? 'N',
      statutoryFlag: (json['statutory_flag'] as String?) ?? 'N',
      includeInCtcFlag: (json['include_in_ctc_flag'] as String?) ?? 'N',
      proratedFlag: (json['prorated_flag'] as String?) ?? 'N',
      taxableFlag: (json['taxable_flag'] as String?) ?? 'N',
      amortizableFlag: (json['amortizable_flag'] as String?) ?? 'N',
      advActiveFlag: (json['adv_active_flag'] as String?) ?? 'N',
      createdBy: json['created_by'] as String?,
      creationDate: json['creation_date'] != null ? DateTime.tryParse(json['creation_date'] as String) : null,
      lastUpdatedBy: json['last_updated_by'] as String?,
      lastUpdateDate: json['last_update_date'] != null ? DateTime.tryParse(json['last_update_date'] as String) : null,
    );
  }

  CompComponent toDomain() {
    return CompComponent(
      componentId: componentId,
      componentGuid: componentGuid,
      componentCode: componentCode,
      componentName: componentName,
      description: _toUiDescription(description),
      planUsageCount: planUsageCount,
      componentTypeCode: componentTypeCode,
      calculationMethodCode: calculationMethodCode,
      status: status,
      compCategoryCode: compCategoryCode,
      formulaName: formulaName,
      payBasis: payBasis,
      currencyCode: currencyCode,
      baseAmountSource: baseAmountSource,
      minValue: minValue,
      maxValue: maxValue,
      locationCodes: locationCodes,
      tenantId: tenantId,
      effectiveStartDate: effectiveStartDate,
      effectiveEndDate: effectiveEndDate,
      componentActiveFlag: componentActiveFlag,
      advSettingId: advSettingId,
      advSettingGuid: advSettingGuid,
      recurringFlag: recurringFlag,
      optionalFlag: optionalFlag,
      pensionableFlag: pensionableFlag,
      statutoryFlag: statutoryFlag,
      includeInCtcFlag: includeInCtcFlag,
      proratedFlag: proratedFlag,
      taxableFlag: taxableFlag,
      amortizableFlag: amortizableFlag,
      advActiveFlag: advActiveFlag,
      createdBy: createdBy,
      creationDate: creationDate,
      lastUpdatedBy: lastUpdatedBy,
      lastUpdateDate: lastUpdateDate,
    );
  }

  static String _toUiDescription(String? description) {
    final text = (description ?? '').trim();
    return text.isEmpty ? '---' : text;
  }
}
