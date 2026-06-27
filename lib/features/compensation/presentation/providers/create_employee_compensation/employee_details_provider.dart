import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeCompensationDetailsState {
  final Employee? selectedEmployee;
  final String employeeName;
  final String department;
  final String position;
  final String grade;
  final String employmentType;
  final bool isLoadingEmployeeDetails;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;
  final DateTime? enterpriseHireDate;

  const EmployeeCompensationDetailsState({
    this.selectedEmployee,
    this.employeeName = '',
    this.department = '',
    this.position = '',
    this.grade = '',
    this.employmentType = '',
    this.isLoadingEmployeeDetails = false,
    this.budgetedMinKd,
    this.budgetedMaxKd,
    this.enterpriseHireDate,
  });

  EmployeeCompensationDetailsState copyWith({
    Employee? selectedEmployee,
    bool clearSelectedEmployee = false,
    String? employeeName,
    String? department,
    String? position,
    String? grade,
    String? employmentType,
    bool? isLoadingEmployeeDetails,
    double? budgetedMinKd,
    double? budgetedMaxKd,
    DateTime? enterpriseHireDate,
    bool clearBudgetRange = false,
  }) {
    return EmployeeCompensationDetailsState(
      selectedEmployee: clearSelectedEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
      employeeName: employeeName ?? this.employeeName,
      department: department ?? this.department,
      position: position ?? this.position,
      grade: grade ?? this.grade,
      employmentType: employmentType ?? this.employmentType,
      isLoadingEmployeeDetails: isLoadingEmployeeDetails ?? this.isLoadingEmployeeDetails,
      budgetedMinKd: clearBudgetRange ? null : (budgetedMinKd ?? this.budgetedMinKd),
      budgetedMaxKd: clearBudgetRange ? null : (budgetedMaxKd ?? this.budgetedMaxKd),
      enterpriseHireDate: selectedEmployee != null || clearSelectedEmployee
          ? enterpriseHireDate
          : (enterpriseHireDate ?? this.enterpriseHireDate),
    );
  }
}

class EmployeeCompensationDetailsNotifier extends AutoDisposeNotifier<EmployeeCompensationDetailsState> {
  int _requestId = 0;

  @override
  EmployeeCompensationDetailsState build() => const EmployeeCompensationDetailsState();

  Future<void> selectEmployee(Employee employee, {required int enterpriseId}) async {
    final requestId = ++_requestId;

    state = state.copyWith(
      selectedEmployee: employee,
      employeeName: employee.fullName.trim(),
      department: (employee.departmentName ?? '').trim(),
      position: (employee.positionTitle ?? '').trim(),
      grade: '',
      employmentType: '',
      isLoadingEmployeeDetails: true,
      clearSelectedEmployee: false,
    );

    final repository = ref.read(manageEmployeesListRepositoryProvider);
    final details = await repository.getEmployeeFullDetails(employee.guid, enterpriseId: enterpriseId);

    if (requestId != _requestId) return;

    final gradeNumber = details?.assignment.grade?.gradeNumber.trim() ?? '';
    final gradeId = details?.employee.gradeId;
    final gradeText = gradeNumber.isNotEmpty ? gradeNumber : (gradeId != null ? 'G$gradeId' : '');
    final contractTypeCode = details?.assignment.contractTypeCode;

    final enterpriseHireDateStr = details?.assignment.enterpriseHireDate?.trim() ?? '';
    DateTime? enterpriseHireDate;
    if (enterpriseHireDateStr.isNotEmpty) {
      try {
        enterpriseHireDate = DateTime.parse(enterpriseHireDateStr);
      } catch (_) {
        // Ignore parsing errors
      }
    }

    state = state.copyWith(
      grade: gradeText,
      employmentType: _formatContractType(contractTypeCode),
      isLoadingEmployeeDetails: false,
      budgetedMinKd: details?.assignment.budgetedMinKd,
      budgetedMaxKd: details?.assignment.budgetedMaxKd,
      enterpriseHireDate: enterpriseHireDate,
    );
  }

  void clearSelection() {
    _requestId++;
    state = const EmployeeCompensationDetailsState();
  }

  String _formatContractType(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) return '';
    return value
        .toLowerCase()
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}

final employeeCompensationDetailsProvider =
    NotifierProvider.autoDispose<EmployeeCompensationDetailsNotifier, EmployeeCompensationDetailsState>(
      EmployeeCompensationDetailsNotifier.new,
    );
