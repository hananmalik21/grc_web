import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../features/compensation/domain/models/adjustments/employee_component_history.dart';
import '../../../../../features/compensation/domain/usecases/adjustments/get_employee_component_history_usecase.dart';
import 'adjustments_api_providers.dart';
import 'create_adjustment_form_provider.dart';

final getEmployeeComponentHistoryUseCaseProvider = Provider<GetEmployeeComponentHistoryUseCase>((ref) {
  return GetEmployeeComponentHistoryUseCase(repository: ref.watch(adjustmentsRepositoryProvider));
});

final employeeComponentHistoryProvider = FutureProvider.autoDispose<List<EmployeeComponentHistory>>((ref) async {
  final employee = ref.watch(createAdjustmentFormProvider.select((state) => state.selectedEmployee));

  if (employee == null) return [];

  final useCase = ref.watch(getEmployeeComponentHistoryUseCaseProvider);
  return useCase(enterpriseId: employee.enterpriseId, employeeId: employee.id);
});
