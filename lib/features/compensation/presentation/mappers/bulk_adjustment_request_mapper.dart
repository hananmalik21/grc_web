import 'package:grc/features/compensation/domain/models/bulk_adjustments/create_bulk_adjustment_request.dart';
import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_component_adjustment.dart';

CreateBulkAdjustmentRequest mapBulkAdjustmentSubmitRequest({
  required int enterpriseId,
  required String adjustmentType,
  required String effectiveDate,
  required String reasonCode,
  required String budgetCode,
  required String justificationText,
  required String updatedBy,
  required BulkAdjustmentsFormState formState,
}) {
  final employeesById = <int, BulkAdjustmentEmployeeRequest>{};

  for (final group in formState.groups) {
    for (final edit in group.employeeEdits) {
      if (!_shouldIncludeComponent(group: group, edit: edit)) continue;

      final isDeleted = group.deleteFlag;
      final isModified = !isDeleted && edit.value.trim().isNotEmpty && edit.newAmount != edit.currentAmount;

      final component = BulkAdjustmentComponentRequest(
        componentId: group.componentId,
        amount: edit.newAmount,
        currencyCode: edit.currencyCode,
        adjustmentMethod: edit.adjustmentType,
        replaceFlag: _toApiFlag(isModified),
        deleteFlag: _toApiFlag(isDeleted),
        activeFlag: _toActiveFlag(edit.activeFlag),
        effectiveEndDate: edit.effectiveEndDate,
      );

      final existing = employeesById[edit.employeeId];
      if (existing == null) {
        employeesById[edit.employeeId] = BulkAdjustmentEmployeeRequest(
          employeeId: edit.employeeId,
          planId: edit.planId,
          components: [component],
        );
        continue;
      }

      employeesById[edit.employeeId] = BulkAdjustmentEmployeeRequest(
        employeeId: existing.employeeId,
        planId: existing.planId,
        components: [...existing.components, component],
      );
    }
  }

  return CreateBulkAdjustmentRequest(
    enterpriseId: enterpriseId,
    adjustmentType: adjustmentType,
    effectiveDate: effectiveDate,
    reasonCode: reasonCode,
    budgetCode: budgetCode,
    justificationText: justificationText,
    updatedBy: updatedBy,
    employees: employeesById.values.toList(),
  );
}

bool _shouldIncludeComponent({required BulkComponentAdjustmentGroup group, required BulkEmployeeComponentEdit edit}) {
  if (group.deleteFlag) return true;
  return edit.value.trim().isNotEmpty && edit.newAmount != edit.currentAmount;
}

bool bulkAdjustmentFormHasSubmittableChanges(BulkAdjustmentsFormState formState) {
  return formState.groups.any((group) {
    if (group.deleteFlag) return true;
    return group.employeeEdits.any((edit) => edit.value.trim().isNotEmpty && edit.newAmount != edit.currentAmount);
  });
}

String _toApiFlag(bool value) => value ? 'Y' : 'N';

String _toActiveFlag(String value) {
  final normalized = value.trim().toUpperCase();
  if (normalized == 'Y' || normalized == 'TRUE') return 'Y';
  return 'N';
}
