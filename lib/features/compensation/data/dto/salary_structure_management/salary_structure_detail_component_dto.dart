import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_detail_component.dart';

bool _flagIsYes(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  return value.toString().trim().toUpperCase() == 'Y';
}

class SalaryStructureDetailComponentInfoDto {
  final int componentId;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String calculationMethodCode;
  final String status;
  final String compCategoryCode;
  final String? description;
  final String? currencyCode;

  const SalaryStructureDetailComponentInfoDto({
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.componentTypeCode,
    required this.calculationMethodCode,
    required this.status,
    required this.compCategoryCode,
    this.description,
    this.currencyCode,
  });

  factory SalaryStructureDetailComponentInfoDto.fromJson(Map<String, dynamic> json) {
    return SalaryStructureDetailComponentInfoDto(
      componentId: (json['component_id'] as num?)?.toInt() ?? 0,
      componentCode: (json['component_code'] as String?) ?? '',
      componentName: (json['component_name'] as String?) ?? '',
      componentTypeCode: (json['component_type_code'] as String?) ?? '',
      calculationMethodCode: (json['calculation_method_code'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      compCategoryCode: (json['comp_category_code'] as String?) ?? '',
      description: json['description'] as String?,
      currencyCode: json['currency_code'] as String?,
    );
  }

  SalaryStructureDetailComponentInfo toDomain() {
    return SalaryStructureDetailComponentInfo(
      componentId: componentId,
      componentCode: componentCode,
      componentName: componentName,
      componentTypeCode: componentTypeCode,
      calculationMethodCode: calculationMethodCode,
      status: status,
      compCategoryCode: compCategoryCode,
      description: description,
      currencyCode: currencyCode,
    );
  }
}

class SalaryStructureDetailComponentAdvancedSettingsDto {
  final int advancedSettingId;
  final bool isRecurring;
  final bool isOptional;
  final bool isActive;
  final bool isPensionable;
  final bool isStatutory;
  final bool isIncludedInCtc;
  final bool isProrated;
  final bool isTaxable;
  final bool isAmortizable;
  final String? payBasis;

  const SalaryStructureDetailComponentAdvancedSettingsDto({
    required this.advancedSettingId,
    required this.isRecurring,
    required this.isOptional,
    required this.isActive,
    required this.isPensionable,
    required this.isStatutory,
    required this.isIncludedInCtc,
    required this.isProrated,
    required this.isTaxable,
    this.isAmortizable = false,
    this.payBasis,
  });

  factory SalaryStructureDetailComponentAdvancedSettingsDto.fromJson(Map<String, dynamic> json) {
    return SalaryStructureDetailComponentAdvancedSettingsDto(
      advancedSettingId: (json['adv_setting_id'] as num?)?.toInt() ?? 0,
      isRecurring: _flagIsYes(json['recurring_flag']),
      isOptional: _flagIsYes(json['optional_flag']),
      isActive: _flagIsYes(json['active_flag']),
      isPensionable: _flagIsYes(json['pensionable_flag']),
      isStatutory: _flagIsYes(json['statutory_flag']),
      isIncludedInCtc: _flagIsYes(json['include_in_ctc_flag']),
      isProrated: _flagIsYes(json['prorated_flag']),
      isTaxable: _flagIsYes(json['taxable_flag']),
      isAmortizable: _flagIsYes(json['amortizable_flag']),
      payBasis: json['pay_basis'] as String?,
    );
  }

  SalaryStructureDetailComponentAdvancedSettings toDomain() {
    return SalaryStructureDetailComponentAdvancedSettings(
      advancedSettingId: advancedSettingId,
      isRecurring: isRecurring,
      isOptional: isOptional,
      isActive: isActive,
      isPensionable: isPensionable,
      isStatutory: isStatutory,
      isIncludedInCtc: isIncludedInCtc,
      isProrated: isProrated,
      isTaxable: isTaxable,
      isAmortizable: isAmortizable,
      payBasis: payBasis,
    );
  }
}

class SalaryStructureDetailComponentDto {
  final int structureComponentId;
  final int componentId;
  final String calculationMethodCode;
  final num? defaultValue;
  final num? minValue;
  final num? maxValue;
  final int displaySequence;
  final bool isActive;
  final SalaryStructureDetailComponentInfoDto? component;
  final SalaryStructureDetailComponentAdvancedSettingsDto? advancedSettings;

  const SalaryStructureDetailComponentDto({
    required this.structureComponentId,
    required this.componentId,
    required this.calculationMethodCode,
    required this.defaultValue,
    required this.minValue,
    required this.maxValue,
    required this.displaySequence,
    required this.isActive,
    this.component,
    this.advancedSettings,
  });

  factory SalaryStructureDetailComponentDto.fromJson(Map<String, dynamic> json) {
    final nested = json['component'] as Map<String, dynamic>?;
    final hasFlat = json['component_name'] != null || json['component_code'] != null;
    final advancedSettingsJson = json['advanced_settings'] as Map<String, dynamic>?;
    final SalaryStructureDetailComponentInfoDto? componentInfo;
    if (hasFlat) {
      componentInfo = SalaryStructureDetailComponentInfoDto.fromJson(json);
    } else if (nested != null) {
      componentInfo = SalaryStructureDetailComponentInfoDto.fromJson(nested);
    } else {
      componentInfo = null;
    }

    return SalaryStructureDetailComponentDto(
      structureComponentId: (json['structure_component_id'] as num?)?.toInt() ?? 0,
      componentId: (json['component_id'] as num?)?.toInt() ?? 0,
      calculationMethodCode: (json['calculation_method_code'] as String?) ?? '',
      defaultValue: _tryParseNum(json['default_value']),
      minValue: _tryParseNum(json['min_value']),
      maxValue: _tryParseNum(json['max_value']),
      displaySequence: (json['display_sequence'] as num?)?.toInt() ?? 0,
      isActive: _flagIsYes(json['active_flag']),
      component: componentInfo,
      advancedSettings: advancedSettingsJson == null
          ? null
          : SalaryStructureDetailComponentAdvancedSettingsDto.fromJson(advancedSettingsJson),
    );
  }

  SalaryStructureDetailComponent toDomain() {
    return SalaryStructureDetailComponent(
      structureComponentId: structureComponentId,
      componentId: componentId,
      calculationMethodCode: calculationMethodCode,
      defaultValue: defaultValue,
      minValue: minValue,
      maxValue: maxValue,
      displaySequence: displaySequence,
      isActive: isActive,
      component: component?.toDomain(),
      advancedSettings: advancedSettings?.toDomain(),
    );
  }

  static num? _tryParseNum(dynamic value) {
    if (value is num) return value;
    if (value is String && value.trim().isNotEmpty) return num.tryParse(value);
    return null;
  }
}
