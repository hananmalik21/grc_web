class EmployeeCompensationOrgUnit {
  const EmployeeCompensationOrgUnit({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    required this.levelCode,
    required this.status,
    required this.isActive,
  });

  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String levelCode;
  final String status;
  final String isActive;
}

class EmployeeCompensationComponent {
  const EmployeeCompensationComponent({
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.componentTypeCode,
    required this.compCategoryCode,
    required this.amount,
    required this.currencyCode,
  });

  final int componentId;
  final String componentCode;
  final String componentName;
  final String componentTypeCode;
  final String compCategoryCode;
  final double amount;
  final String currencyCode;

  String get displayLabel => componentName.trim().isNotEmpty ? componentName.trim() : '—';
  String get displayAmountValue => amount.toStringAsFixed(0);

  String get displayCategoryKey {
    final category = compCategoryCode.trim();
    if (category.isNotEmpty) return category.toUpperCase();
    final type = componentTypeCode.trim();
    return type.isNotEmpty ? type.toUpperCase() : '—';
  }
}

class EmployeeCompensationComponentGroup {
  const EmployeeCompensationComponentGroup({required this.componentTypeCode, required this.components});

  final String componentTypeCode;
  final List<EmployeeCompensationComponent> components;

  String get displayTypeLabel => componentTypeCode.trim().isNotEmpty ? componentTypeCode.trim() : '—';

  bool get isEarningGroup => componentTypeCode.trim().toUpperCase() == 'EARNING';

  double get totalAmount => components.fold<double>(0, (sum, c) => sum + c.amount);

  String get displayCurrencyCode {
    final currency = components.isEmpty ? '' : components.first.currencyCode.trim().toUpperCase();
    return currency.isNotEmpty ? currency : '—';
  }

  String get displayTotalAmountWithCurrency {
    final amountText = totalAmount.toStringAsFixed(0);
    final code = displayCurrencyCode;
    if (code.isEmpty || code == '—') return amountText;
    return '$code $amountText';
  }
}

class EmployeeCompensationPlanDetails {
  const EmployeeCompensationPlanDetails({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeName,
    required this.employeeNumber,
    required this.contractTypeCode,
    required this.enterpriseHireDate,
    required this.positionId,
    required this.positionName,
    required this.gradeId,
    required this.gradeNumber,
    required this.gradeCategory,
    required this.planTypeCode,
    required this.planId,
    required this.planGuid,
    required this.planCode,
    required this.planName,
    required this.structureId,
    required this.structureGuid,
    required this.structureCode,
    required this.structureName,
    required this.structureCurrencyCode,
    required this.structureEffectiveFrom,
    required this.structureEffectiveTo,
    required this.orgStructureList,
    required this.components,
  });

  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final String employeeName;
  final String employeeNumber;
  final String contractTypeCode;
  final String enterpriseHireDate;
  final String positionId;
  final String positionName;
  final int gradeId;
  final String gradeNumber;
  final String gradeCategory;
  final String planTypeCode;
  final int planId;
  final String planGuid;
  final String planCode;
  final String planName;
  final int structureId;
  final String structureGuid;
  final String structureCode;
  final String structureName;
  final String structureCurrencyCode;
  final String structureEffectiveFrom;
  final String structureEffectiveTo;
  final List<EmployeeCompensationOrgUnit> orgStructureList;
  final List<EmployeeCompensationComponent> components;

  String get displayEmployeeNumber {
    final id = employeeNumber.trim();
    return id.isNotEmpty ? id : '—';
  }

  String get displayEmployeeName {
    final name = employeeName.trim();
    return name.isNotEmpty ? name : '—';
  }

  String get displayDepartment {
    final department = orgStructureList
        .where((e) => e.levelCode.trim().toUpperCase() == 'DEPARTMENT')
        .cast<EmployeeCompensationOrgUnit>()
        .firstOrNull;
    if (department == null) return '—';
    final name = department.orgUnitNameEn.trim();
    return name.isNotEmpty ? name : '—';
  }

  String get displayPosition => positionName.trim().isNotEmpty ? positionName.trim() : '—';

  String get displayGrade => gradeNumber.trim().isNotEmpty ? gradeNumber.trim() : '—';

  String get displayEmploymentType => contractTypeCode.trim().isNotEmpty ? contractTypeCode.trim() : '—';

  String get displayHireDate {
    final formatted = _formatDateYyyyMmDdToDdMmYyyy(enterpriseHireDate);
    return formatted.isNotEmpty ? formatted : '—';
  }

  String get displayStructureEffectiveFrom {
    final formatted = _formatDateYyyyMmDdToDdMmYyyy(structureEffectiveFrom);
    return formatted.isNotEmpty ? formatted : '—';
  }

  String get displayCurrency {
    final code = structureCurrencyCode.trim().toUpperCase();
    if (code.isEmpty) return '—';
    return code;
  }

  /// UI-ready: either `CODE <amount>` or just `<amount>` when currency is missing.
  String get displayGrossMonthlyCompensationWithCurrency {
    final amountText = totalGrossMonthlyCompensation.toStringAsFixed(0);
    final code = displayCurrency;
    if (code.isEmpty || code == '—') return amountText;
    return '$code $amountText';
  }

  String _formatDateYyyyMmDdToDdMmYyyy(String raw) {
    final s = raw.trim();
    if (s.length < 10) return '';
    if (s[4] == '-' && s[7] == '-') {
      final yyyy = s.substring(0, 4);
      final mm = s.substring(5, 7);
      final dd = s.substring(8, 10);
      return '$dd/$mm/$yyyy';
    }
    return '';
  }

  /// UI-ready grouping of components, separated by category (or type fallback).
  List<EmployeeCompensationComponentGroup> get displayComponentGroups {
    final byType = <String, List<EmployeeCompensationComponent>>{};
    final order = <String>[];

    for (final component in components) {
      final key = component.displayCategoryKey;

      byType.putIfAbsent(key, () => <EmployeeCompensationComponent>[]);
      if (!order.contains(key)) order.add(key);
      byType[key]!.add(component);
    }

    final groups = order
        .map((typeKey) => EmployeeCompensationComponentGroup(componentTypeCode: typeKey, components: byType[typeKey]!))
        .toList();

    final earningGroups = groups.where((g) => g.isEarningGroup).toList();
    final otherGroups = groups.where((g) => !g.isEarningGroup).toList();
    return [...earningGroups, ...otherGroups];
  }

  double get totalGrossMonthlyCompensation => components.fold<double>(0, (sum, c) => sum + c.amount);

  double get totalFixedComponents => components
      .where((c) => c.componentTypeCode.trim().toUpperCase() == 'FIXED')
      .fold<double>(0, (sum, c) => sum + c.amount);
}

extension _FirstOrNullExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
