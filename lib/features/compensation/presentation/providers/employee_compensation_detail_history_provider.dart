import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grc/features/compensation/domain/models/adjustments/employee_component_history.dart';
import 'package:grc/features/compensation/domain/usecases/adjustments/get_employee_component_history_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/create_employee_compensation/employee_details_provider.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_detail_provider.dart';

final _getEmployeeCompHistoryUseCaseProvider = Provider<GetEmployeeComponentHistoryUseCase>((ref) {
  return GetEmployeeComponentHistoryUseCase(repository: ref.watch(adjustmentsRepositoryProvider));
});

final employeeCompHistoryForDetailPageProvider = FutureProvider.autoDispose<List<EmployeeComponentHistory>>((
  ref,
) async {
  final detail = ref.watch(employeeCompensationDetailProvider).details;
  final useCase = ref.watch(_getEmployeeCompHistoryUseCaseProvider);

  if (detail != null) {
    return useCase(enterpriseId: detail.enterpriseId, employeeId: detail.employeeId);
  }

  final selected = ref.watch(employeeCompensationDetailsProvider).selectedEmployee;
  if (selected == null) return [];

  return useCase(enterpriseId: selected.enterpriseId, employeeId: selected.id);
});
