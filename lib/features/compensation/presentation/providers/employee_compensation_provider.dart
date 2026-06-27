import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/employee_compensation/employee_compensation_config.dart';
import 'employee_compensation_state.dart';

class EmployeeCompensationNotifier extends Notifier<EmployeeCompensationState> {
  @override
  EmployeeCompensationState build() {
    return EmployeeCompensationState(allRows: EmployeeCompensationConfig.mockRows);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
  }

  void updateDepartment(String department) {
    state = state.copyWith(selectedDepartment: department, currentPage: 1);
  }

  void updateRegion(String region) {
    state = state.copyWith(selectedRegion: region, currentPage: 1);
  }

  void nextPage() {
    if (state.currentPage < state.totalPages) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 1) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void resetFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedDepartment: EmployeeCompensationConfig.allFilter,
      selectedRegion: EmployeeCompensationConfig.allFilter,
      currentPage: 1,
    );
  }
}

final employeeCompensationProvider = NotifierProvider<EmployeeCompensationNotifier, EmployeeCompensationState>(
  EmployeeCompensationNotifier.new,
);
