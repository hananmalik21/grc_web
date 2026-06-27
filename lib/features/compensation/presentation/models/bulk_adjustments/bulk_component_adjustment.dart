import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_component.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_common_component.dart';

class BulkEmployeeComponentEdit {
  const BulkEmployeeComponentEdit({
    required this.employeeGuid,
    required this.employeeId,
    required this.employeeName,
    required this.planId,
    required this.currentAmount,
    required this.currencyCode,
    this.activeFlag = 'Y',
    this.effectiveEndDate,
    this.adjustmentType = 'PERCENTAGE',
    this.value = '',
    this.newAmount = 0,
  });

  final String employeeGuid;
  final int employeeId;
  final String employeeName;
  final int planId;
  final double currentAmount;
  final String currencyCode;
  final String activeFlag;
  final String? effectiveEndDate;
  final String adjustmentType;
  final String value;
  final double newAmount;

  String get formattedCurrentAmount => '$currencyCode ${currentAmount.toStringAsFixed(0)}';

  String get formattedNewAmount => '$currencyCode ${newAmount.toStringAsFixed(0)}';

  String get newAmountDisplayKey => newAmount.toStringAsFixed(0);

  bool get hasEdit => value.trim().isNotEmpty;

  BulkEmployeeComponentEdit copyWith({String? adjustmentType, String? value, double? newAmount}) {
    return BulkEmployeeComponentEdit(
      employeeGuid: employeeGuid,
      employeeId: employeeId,
      employeeName: employeeName,
      planId: planId,
      currentAmount: currentAmount,
      currencyCode: currencyCode,
      activeFlag: activeFlag,
      effectiveEndDate: effectiveEndDate,
      adjustmentType: adjustmentType ?? this.adjustmentType,
      value: value ?? this.value,
      newAmount: newAmount ?? this.newAmount,
    );
  }
}

class BulkComponentAdjustmentGroup {
  const BulkComponentAdjustmentGroup({
    required this.componentId,
    required this.componentCode,
    required this.componentName,
    required this.employeeEdits,
    this.categoryCode = '',
    this.deleteFlag = false,
    this.sharedAdjustmentType = 'PERCENTAGE',
    this.sharedValue = '',
    this.hasUniformCurrentAmount = true,
    this.isNewFromPlan = false,
  });

  final int componentId;
  final String componentCode;
  final String componentName;
  final List<BulkEmployeeComponentEdit> employeeEdits;
  final String categoryCode;
  final bool deleteFlag;
  final String sharedAdjustmentType;
  final String sharedValue;
  final bool hasUniformCurrentAmount;
  final bool isNewFromPlan;

  String get currencyCode => employeeEdits.isNotEmpty ? employeeEdits.first.currencyCode : '';

  bool get hasChanges =>
      deleteFlag || sharedValue.trim().isNotEmpty || employeeEdits.any((edit) => edit.value.trim().isNotEmpty);

  bool get showManualUniformAmountHint =>
      !hasUniformCurrentAmount && AdjustmentMethod.fromCode(sharedAdjustmentType) == AdjustmentMethod.manual;

  bool get isEarning => categoryCode.trim().toUpperCase() == 'EARNING';

  static List<BulkComponentAdjustmentGroup> sortedWithEarningFirst(List<BulkComponentAdjustmentGroup> groups) {
    final earning = groups.where((group) => group.isEarning).toList();
    final other = groups.where((group) => !group.isEarning).toList();
    return [...earning, ...other];
  }

  BulkComponentAdjustmentGroup copyWith({
    List<BulkEmployeeComponentEdit>? employeeEdits,
    String? categoryCode,
    bool? deleteFlag,
    String? sharedAdjustmentType,
    String? sharedValue,
    bool? hasUniformCurrentAmount,
    bool? isNewFromPlan,
  }) {
    return BulkComponentAdjustmentGroup(
      componentId: componentId,
      componentCode: componentCode,
      componentName: componentName,
      employeeEdits: employeeEdits ?? this.employeeEdits,
      categoryCode: categoryCode ?? this.categoryCode,
      deleteFlag: deleteFlag ?? this.deleteFlag,
      sharedAdjustmentType: sharedAdjustmentType ?? this.sharedAdjustmentType,
      sharedValue: sharedValue ?? this.sharedValue,
      hasUniformCurrentAmount: hasUniformCurrentAmount ?? this.hasUniformCurrentAmount,
      isNewFromPlan: isNewFromPlan ?? this.isNewFromPlan,
    );
  }
}

extension BulkAdjustmentsFormStateX on BulkAdjustmentsFormState {
  List<BulkComponentAdjustmentGroup> get existingActiveGroups =>
      BulkComponentAdjustmentGroup.sortedWithEarningFirst(activeGroups.where((group) => !group.isNewFromPlan).toList());

  List<BulkComponentAdjustmentGroup> get newFromPlanActiveGroups =>
      BulkComponentAdjustmentGroup.sortedWithEarningFirst(activeGroups.where((group) => group.isNewFromPlan).toList());
}

class BulkAdjustmentCardConfig {
  BulkAdjustmentCardConfig._();

  static const int collapseBreakdownThreshold = 5;
}

class BulkAdjustmentsFormState {
  const BulkAdjustmentsFormState({this.groups = const []});

  final List<BulkComponentAdjustmentGroup> groups;

  List<BulkComponentAdjustmentGroup> get activeGroups => groups.where((group) => !group.deleteFlag).toList();

  bool get hasChanges => groups.any((group) => group.hasChanges);

  BulkAdjustmentsFormState copyWith({List<BulkComponentAdjustmentGroup>? groups}) {
    return BulkAdjustmentsFormState(groups: groups ?? this.groups);
  }
}

double calculateBulkNewAmount({required double currentAmount, required String adjustmentType, required String value}) {
  final parsedValue = double.tryParse(value) ?? 0;
  return switch (AdjustmentMethod.fromCode(adjustmentType)) {
    AdjustmentMethod.percentage => currentAmount * (1 + parsedValue / 100),
    AdjustmentMethod.amount => currentAmount + parsedValue,
    AdjustmentMethod.manual => parsedValue,
    null => currentAmount,
  };
}

BulkEmployeeComponent? findBulkEmployeeComponent({
  required BulkEmployeeComponentsPage page,
  required String employeeGuid,
  required int componentId,
}) {
  for (final entry in page.employees) {
    if (entry.employeeGuid != employeeGuid) continue;
    for (final component in entry.components) {
      if (component.componentId == componentId) return component;
    }
  }
  return null;
}

List<BulkComponentAdjustmentGroup> mergeBulkComponentAdjustmentGroups({
  required List<BulkComponentAdjustmentGroup> existing,
  required List<BulkComponentAdjustmentGroup> incoming,
}) {
  final byComponentId = {for (final group in existing) group.componentId: group};

  for (final incomingGroup in incoming) {
    final current = byComponentId[incomingGroup.componentId];
    if (current == null) {
      byComponentId[incomingGroup.componentId] = incomingGroup;
      continue;
    }

    final editsByGuid = {for (final edit in current.employeeEdits) edit.employeeGuid: edit};
    for (final edit in incomingGroup.employeeEdits) {
      editsByGuid.putIfAbsent(edit.employeeGuid, () => edit);
    }

    byComponentId[incomingGroup.componentId] = current.copyWith(employeeEdits: editsByGuid.values.toList());
  }

  return BulkComponentAdjustmentGroup.sortedWithEarningFirst(byComponentId.values.toList());
}

List<BulkComponentAdjustmentGroup> buildBulkComponentAdjustmentGroups({
  required BulkEmployeeComponentsPage page,
  required Map<String, String> employeeLabels,
  required Map<String, int> employeeNumericIds,
}) {
  final commonComponents = findCommonBulkComponents(page.employees);

  final groups = commonComponents.map((component) {
    final employeeEdits = component.amountsByEmployeeGuid.entries.map((entry) {
      final employeeGuid = entry.key;
      final currentAmount = entry.value;
      final source = findBulkEmployeeComponent(
        page: page,
        employeeGuid: employeeGuid,
        componentId: component.componentId,
      );
      return BulkEmployeeComponentEdit(
        employeeGuid: employeeGuid,
        employeeId: employeeNumericIds[employeeGuid] ?? 0,
        employeeName: employeeLabels[employeeGuid] ?? employeeGuid,
        planId: source?.planId ?? 0,
        currentAmount: currentAmount,
        currencyCode: component.currencyCode,
        activeFlag: 'Y',
        newAmount: currentAmount,
      );
    }).toList();

    return BulkComponentAdjustmentGroup(
      componentId: component.componentId,
      componentCode: component.componentCode,
      componentName: component.componentName,
      categoryCode: component.categoryCode,
      employeeEdits: employeeEdits,
      hasUniformCurrentAmount: component.hasUniformAmount,
    );
  }).toList();

  return BulkComponentAdjustmentGroup.sortedWithEarningFirst(groups);
}
