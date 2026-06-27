import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/payroll/application/element_entries/controllers/element_entries_tab_controller.dart';
import 'package:grc/features/payroll/application/element_entries/states/element_entries_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final elementEntriesTabProvider = StateNotifierProvider<ElementEntriesTabController, ElementEntriesTabState>((ref) {
  final controller = ElementEntriesTabController(
    initialEnterpriseId: ref.read(activeEnterpriseIdProvider),
    employeesRepository: ref.read(manageEmployeesListRepositoryProvider),
  );
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next != null && !controller.hasEnterpriseSelection) {
      controller.setEnterpriseId(next);
    }
  });
  return controller;
});

final elementEntriesEnterpriseIdProvider = Provider<int?>((ref) {
  final tabState = ref.watch(elementEntriesTabProvider);
  final active = ref.watch(activeEnterpriseIdProvider);
  return tabState.enterpriseId ?? active;
});
