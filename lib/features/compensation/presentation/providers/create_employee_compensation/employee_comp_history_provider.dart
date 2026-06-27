import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/compensation/domain/models/adjustments/employee_component_history.dart';
import 'package:grc/features/compensation/domain/usecases/adjustments/get_employee_component_history_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/employee_details_provider.dart';

final _getEmployeeCompHistoryUseCaseProvider =
    Provider<GetEmployeeComponentHistoryUseCase>((ref) {
  return GetEmployeeComponentHistoryUseCase(
    repository: ref.watch(adjustmentsRepositoryProvider),
  );
});

/// Fetches component history for the employee selected on the
/// create-employee-compensation-plan page.
final employeeCompHistoryProvider =
    FutureProvider.autoDispose<List<EmployeeComponentHistory>>((ref) async {
  final employee =
      ref.watch(employeeCompensationDetailsProvider).selectedEmployee;

  if (employee == null) return [];

  final useCase = ref.watch(_getEmployeeCompHistoryUseCaseProvider);
  return useCase(
    enterpriseId: employee.enterpriseId,
    employeeId: employee.id,
  );
});
