import 'package:grc/features/payroll/application/submit_payroll_flow/controllers/submit_payroll_flow_controller.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/states/submit_payroll_flow_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final submitPayrollFlowProvider = StateNotifierProvider<SubmitPayrollFlowController, SubmitPayrollFlowState>(
  (ref) => SubmitPayrollFlowController(),
);
