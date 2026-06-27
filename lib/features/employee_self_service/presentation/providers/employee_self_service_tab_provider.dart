import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'employee_self_service_tab_state.dart';

class EmployeeSelfServiceTabNotifier extends StateNotifier<EmployeeSelfServiceTabState> {
  EmployeeSelfServiceTabNotifier() : super(const EmployeeSelfServiceTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final employeeSelfServiceTabStateProvider =
    StateNotifierProvider<EmployeeSelfServiceTabNotifier, EmployeeSelfServiceTabState>((ref) {
      return EmployeeSelfServiceTabNotifier();
    });
