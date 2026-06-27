class SalaryStructureDetailComponentInfo {
  final int componentId;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String calculationMethodCode;
  final String status;
  final String compCategoryCode;
  final String? description;
  final String? currencyCode;

  const SalaryStructureDetailComponentInfo({
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
}

class SalaryStructureDetailComponentAdvancedSettings {
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

  const SalaryStructureDetailComponentAdvancedSettings({
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
}

class SalaryStructureDetailComponent {
  final int structureComponentId;
  final int componentId;
  final String calculationMethodCode;
  final num? defaultValue;
  final num? minValue;
  final num? maxValue;
  final int displaySequence;
  final bool isActive;
  final SalaryStructureDetailComponentInfo? component;
  final SalaryStructureDetailComponentAdvancedSettings? advancedSettings;

  const SalaryStructureDetailComponent({
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

  String get uiTitle =>
      component?.componentName.trim().isNotEmpty == true ? component!.componentName : 'Component #$componentId';

  String get uiCode =>
      component?.componentCode.trim().isNotEmpty == true ? component!.componentCode : 'ID $componentId';

  String get uiType {
    final method = calculationMethodCode.trim();
    return method.isEmpty ? '-' : method;
  }

  String get uiComponentType {
    final type = component?.componentTypeCode.trim() ?? '';
    return type.isEmpty ? '-' : type;
  }

  String get uiCategory {
    final cat = component?.compCategoryCode.trim() ?? '';
    return cat.isEmpty ? '-' : cat;
  }

  String get uiStatus => isActive ? 'Active' : 'Inactive';

  String get uiDescription {
    if (component?.description?.trim().isNotEmpty == true) return component!.description!;
    final parts = <String>[];
    if (defaultValue != null) parts.add('Default: $defaultValue');
    if (minValue != null) parts.add('Min: $minValue');
    if (maxValue != null) parts.add('Max: $maxValue');
    return parts.isEmpty ? '---' : parts.join(' • ');
  }

  String get uiValueSummary {
    final parts = <String>[];
    if (defaultValue != null) parts.add('Default: $defaultValue');
    if (minValue != null) parts.add('Min: $minValue');
    if (maxValue != null) parts.add('Max: $maxValue');
    return parts.isEmpty ? '---' : parts.join(' • ');
  }
}
