import 'package:grc/features/payroll/domain/models/element_entry_employee_context.dart';

class ElementEntriesTabState {
  const ElementEntriesTabState({this.selectedEmployee, this.enterpriseId, this.isLoadingEmployeeDetails = false});

  final ElementEntryEmployeeContext? selectedEmployee;
  final int? enterpriseId;
  final bool isLoadingEmployeeDetails;

  ElementEntriesTabState copyWith({
    ElementEntryEmployeeContext? selectedEmployee,
    int? enterpriseId,
    bool? isLoadingEmployeeDetails,
    bool clearSelectedEmployee = false,
  }) {
    return ElementEntriesTabState(
      selectedEmployee: clearSelectedEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
      enterpriseId: enterpriseId ?? this.enterpriseId,
      isLoadingEmployeeDetails: isLoadingEmployeeDetails ?? this.isLoadingEmployeeDetails,
    );
  }
}
