import 'package:grc/features/payroll/application/payroll/states/payroll_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PayrollTabController extends StateNotifier<PayrollTabState> {
  PayrollTabController() : super(const PayrollTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}
