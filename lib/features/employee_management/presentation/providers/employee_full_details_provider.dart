import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeFullDetailsProvider = FutureProvider.autoDispose.family<EmployeeFullDetails?, String>((
  ref,
  employeeGuid,
) async {
  if (employeeGuid.isEmpty) return null;
  final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider) ?? 0;
  final repository = ref.watch(manageEmployeesListRepositoryProvider);
  return repository.getEmployeeFullDetails(employeeGuid, enterpriseId: enterpriseId);
});
