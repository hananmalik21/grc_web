import 'package:grc/features/payroll/application/payroll/controllers/payroll_tab_controller.dart';
import 'package:grc/features/payroll/application/payroll/states/payroll_tab_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final payrollTabStateProvider = StateNotifierProvider<PayrollTabController, PayrollTabState>(
  (ref) => PayrollTabController(),
);
