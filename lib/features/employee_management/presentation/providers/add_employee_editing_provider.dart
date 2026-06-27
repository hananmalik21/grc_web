import 'package:grc/features/employee_management/presentation/providers/add_employee_dialog_flow_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_full_details_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addEmployeeEditingEmployeeIdProvider = StateProvider<String?>((ref) => null);

final addEmployeeEditPreloadProvider = AsyncNotifierProvider.autoDispose<AddEmployeeEditPreloadNotifier, void>(
  AddEmployeeEditPreloadNotifier.new,
);

class AddEmployeeEditPreloadNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    final editingId = ref.watch(addEmployeeEditingEmployeeIdProvider);
    if (editingId == null || editingId.isEmpty) return;
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider) ?? 0;
    final fullDetails = await ref.watch(employeeFullDetailsProvider(editingId).future);
    if (fullDetails != null) {
      ref.read(addEmployeeDialogFlowProvider).prefillFromFullDetails(fullDetails, enterpriseId);
    }
  }
}
