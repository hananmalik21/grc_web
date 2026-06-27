import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';
import 'package:grc/features/compensation/presentation/utils/bulk_eligible_plans_intersection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulkAdjustmentsFormNotifier extends AutoDisposeNotifier<BulkAdjustmentsFormState> {
  @override
  BulkAdjustmentsFormState build() => const BulkAdjustmentsFormState();

  void reset() => state = const BulkAdjustmentsFormState();

  void syncFromApi({
    required BulkEmployeeComponentsPage page,
    required Map<String, String> employeeLabels,
    required Map<String, int> employeeNumericIds,
    required bool resetExisting,
  }) {
    final incoming = buildBulkComponentAdjustmentGroups(
      page: page,
      employeeLabels: employeeLabels,
      employeeNumericIds: employeeNumericIds,
    );

    final groups = resetExisting
        ? incoming
        : mergeBulkComponentAdjustmentGroups(existing: state.groups, incoming: incoming);
    state = BulkAdjustmentsFormState(groups: BulkComponentAdjustmentGroup.sortedWithEarningFirst(groups));
  }

  void applyToAllEmployees(int componentId, {String? adjustmentType, String? value}) {
    final groups = List<BulkComponentAdjustmentGroup>.from(state.groups);
    final groupIndex = groups.indexWhere((group) => group.componentId == componentId);
    if (groupIndex == -1) return;

    final group = groups[groupIndex];
    final sharedType = adjustmentType ?? group.sharedAdjustmentType;
    final sharedValue = value ?? group.sharedValue;

    final edits = group.employeeEdits.map((edit) {
      final typeToUse = adjustmentType ?? edit.adjustmentType;
      final valueToUse = value ?? edit.value;
      var updated = edit.copyWith(adjustmentType: typeToUse, value: valueToUse);
      updated = updated.copyWith(
        newAmount: calculateBulkNewAmount(
          currentAmount: edit.currentAmount,
          adjustmentType: typeToUse,
          value: valueToUse,
        ),
      );
      return updated;
    }).toList();

    groups[groupIndex] = group.copyWith(
      sharedAdjustmentType: sharedType,
      sharedValue: sharedValue,
      employeeEdits: edits,
    );
    state = state.copyWith(groups: groups);
  }

  void updateEmployeeEdit(int componentId, String employeeGuid, {String? adjustmentType, String? value}) {
    final groups = List<BulkComponentAdjustmentGroup>.from(state.groups);
    final groupIndex = groups.indexWhere((group) => group.componentId == componentId);
    if (groupIndex == -1) return;

    final group = groups[groupIndex];
    final edits = List<BulkEmployeeComponentEdit>.from(group.employeeEdits);
    final editIndex = edits.indexWhere((edit) => edit.employeeGuid == employeeGuid);
    if (editIndex == -1) return;

    var edit = edits[editIndex].copyWith(adjustmentType: adjustmentType, value: value);
    edit = edit.copyWith(
      newAmount: calculateBulkNewAmount(
        currentAmount: edit.currentAmount,
        adjustmentType: edit.adjustmentType,
        value: edit.value,
      ),
    );
    edits[editIndex] = edit;
    groups[groupIndex] = group.copyWith(employeeEdits: edits);
    state = state.copyWith(groups: groups);
  }

  void removeComponentGroup(int componentId) {
    final groups = state.groups.map((group) {
      if (group.componentId != componentId) return group;
      return group.copyWith(deleteFlag: true);
    }).toList();
    state = state.copyWith(groups: groups);
  }

  void addComponentsFromPlan({
    required CompensationPlan plan,
    required List<EmployeeEligiblePlans> eligibleByEmployee,
    required Map<String, String> employeeLabels,
    required Map<String, int> employeeNumericIds,
    required List<PlanComponent> components,
    String defaultCurrencyCode = 'KWD',
  }) {
    if (components.isEmpty || eligibleByEmployee.isEmpty) return;

    final currency = _resolveCurrency(defaultCurrencyCode);
    final incoming = <BulkComponentAdjustmentGroup>[];

    for (final component in components) {
      if (state.groups.any((g) => !g.deleteFlag && g.componentId == component.componentId)) {
        continue;
      }

      final employeeEdits = eligibleByEmployee.map((entry) {
        final employeePlan = findEmployeePlan(entry: entry, planId: plan.planId);
        return BulkEmployeeComponentEdit(
          employeeGuid: entry.employeeGuid,
          employeeId: employeeNumericIds[entry.employeeGuid] ?? entry.employeeId,
          employeeName: employeeLabels[entry.employeeGuid] ?? entry.employeeGuid,
          planId: employeePlan?.planId ?? plan.planId,
          currentAmount: 0,
          currencyCode: currency,
          newAmount: 0,
        );
      }).toList();

      incoming.add(
        BulkComponentAdjustmentGroup(
          componentId: component.componentId,
          componentCode: component.component?.code ?? '',
          componentName: component.component?.name ?? '',
          categoryCode: component.component?.categoryCode ?? '',
          employeeEdits: employeeEdits,
          isNewFromPlan: true,
          hasUniformCurrentAmount: true,
        ),
      );
    }

    if (incoming.isEmpty) return;

    state = state.copyWith(
      groups: BulkComponentAdjustmentGroup.sortedWithEarningFirst(
        mergeBulkComponentAdjustmentGroups(existing: state.groups, incoming: incoming),
      ),
    );
  }

  String _resolveCurrency(String fallback) {
    for (final group in state.groups) {
      if (group.currencyCode.trim().isNotEmpty && group.currencyCode != '---') {
        return group.currencyCode;
      }
    }
    return fallback;
  }
}

final bulkAdjustmentsFormProvider = AutoDisposeNotifierProvider<BulkAdjustmentsFormNotifier, BulkAdjustmentsFormState>(
  BulkAdjustmentsFormNotifier.new,
);
