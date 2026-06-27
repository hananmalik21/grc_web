import 'package:grc/features/employee_management/domain/repositories/manage_employees_list_repository.dart';
import 'package:grc/features/payroll/application/element_entries/states/element_entries_tab_state.dart';
import 'package:grc/features/payroll/domain/models/element_entry_employee_context.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElementEntriesTabController extends StateNotifier<ElementEntriesTabState> {
  ElementEntriesTabController({
    required int? initialEnterpriseId,
    required ManageEmployeesListRepository employeesRepository,
  }) : _employeesRepository = employeesRepository,
       super(ElementEntriesTabState(enterpriseId: initialEnterpriseId));

  final ManageEmployeesListRepository _employeesRepository;

  bool get hasEnterpriseSelection => state.enterpriseId != null;

  void setEnterpriseId(int? enterpriseId) {
    state = state.copyWith(enterpriseId: enterpriseId);
  }

  void selectEmployee(ElementEntryEmployeeContext context) {
    state = state.copyWith(selectedEmployee: context);
  }

  Future<void> selectFromWorkforceEmployee(Employee employee) async {
    state = state.copyWith(isLoadingEmployeeDetails: true);

    try {
      final fullDetails = await _employeesRepository.getEmployeeFullDetails(
        employee.guid,
        enterpriseId: employee.enterpriseId,
      );

      final context = fullDetails != null
          ? ElementEntryEmployeeContext.fromFullDetails(fullDetails, employee: employee)
          : ElementEntryEmployeeContext.fromEmployee(employee);

      state = state.copyWith(
        selectedEmployee: context,
        enterpriseId: employee.enterpriseId,
        isLoadingEmployeeDetails: false,
      );
    } catch (_) {
      state = state.copyWith(
        selectedEmployee: ElementEntryEmployeeContext.fromEmployee(employee),
        enterpriseId: employee.enterpriseId,
        isLoadingEmployeeDetails: false,
      );
    }
  }

  void clearSelectedEmployee() {
    state = state.copyWith(clearSelectedEmployee: true, isLoadingEmployeeDetails: false);
  }
}
