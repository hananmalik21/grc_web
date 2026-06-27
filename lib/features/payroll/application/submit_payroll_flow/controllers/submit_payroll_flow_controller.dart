import 'package:grc/features/payroll/application/submit_payroll_flow/states/submit_payroll_flow_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubmitPayrollFlowController extends StateNotifier<SubmitPayrollFlowState> {
  SubmitPayrollFlowController() : super(const SubmitPayrollFlowState());

  void setPayrollFlow(String? value) => state = state.copyWith(payrollFlow: value, clearPayrollFlow: value == null);

  void setSchedule(String value) => state = state.copyWith(schedule: value);

  void setScope(String? value) => state = state.copyWith(scope: value, clearScope: value == null);

  void setPayroll(String? value) => state = state.copyWith(payroll: value, clearPayroll: value == null);

  void setPayrollPeriod(String? value) =>
      state = state.copyWith(payrollPeriod: value, clearPayrollPeriod: value == null);

  void setConsolidationGroup(String? value) =>
      state = state.copyWith(consolidationGroup: value, clearConsolidationGroup: value == null);

  void setRunType(String? value) => state = state.copyWith(runType: value, clearRunType: value == null);

  void setPayrollRelationshipGroup(String? value) =>
      state = state.copyWith(payrollRelationshipGroup: value, clearPayrollRelationshipGroup: value == null);

  void setProcessStartDate(DateTime? value) =>
      state = state.copyWith(processStartDate: value, clearProcessStartDate: value == null);

  void setProcessEndDate(DateTime? value) =>
      state = state.copyWith(processEndDate: value, clearProcessEndDate: value == null);

  void setDateEarned(DateTime? value) => state = state.copyWith(dateEarned: value, clearDateEarned: value == null);

  void setElementGroup(String? value) => state = state.copyWith(elementGroup: value, clearElementGroup: value == null);

  void setReportCategory(String? value) =>
      state = state.copyWith(reportCategory: value, clearReportCategory: value == null);

  void setProcessConfigurationGroup(String? value) =>
      state = state.copyWith(processConfigurationGroup: value, clearProcessConfigurationGroup: value == null);

  void setRunMode(String value) => state = state.copyWith(runMode: value);

  void setCurrentStep(SubmitPayrollFlowStep step) => state = state.copyWith(currentStep: step);

  void goToFlowDetailsStep() => state = state.copyWith(currentStep: SubmitPayrollFlowStep.flowDetails);

  void goToParametersStep() => state = state.copyWith(currentStep: SubmitPayrollFlowStep.parameters);

  void goToReviewStep() => state = state.copyWith(currentStep: SubmitPayrollFlowStep.review);

  void goBackToEdit() => goToParametersStep();

  void confirmAndSubmit() {}

  void reset() => state = const SubmitPayrollFlowState();
}
