enum SubmitPayrollFlowStep { flowDetails, parameters, review }

class SubmitPayrollFlowState {
  const SubmitPayrollFlowState({
    this.currentStep = SubmitPayrollFlowStep.flowDetails,
    this.payrollFlow,
    this.schedule = SubmitPayrollFlowDefaults.scheduleAsSoonAsPossible,
    this.scope,
    this.payroll,
    this.payrollPeriod,
    this.consolidationGroup,
    this.runType,
    this.payrollRelationshipGroup,
    this.processStartDate,
    this.processEndDate,
    this.dateEarned,
    this.elementGroup,
    this.reportCategory,
    this.processConfigurationGroup,
    this.runMode = SubmitPayrollFlowDefaults.runModeNormal,
  });

  final SubmitPayrollFlowStep currentStep;
  final String? payrollFlow;
  final String schedule;
  final String? scope;
  final String? payroll;
  final String? payrollPeriod;
  final String? consolidationGroup;
  final String? runType;
  final String? payrollRelationshipGroup;
  final DateTime? processStartDate;
  final DateTime? processEndDate;
  final DateTime? dateEarned;
  final String? elementGroup;
  final String? reportCategory;
  final String? processConfigurationGroup;
  final String runMode;

  SubmitPayrollFlowState copyWith({
    SubmitPayrollFlowStep? currentStep,
    String? payrollFlow,
    bool clearPayrollFlow = false,
    String? schedule,
    String? scope,
    bool clearScope = false,
    String? payroll,
    bool clearPayroll = false,
    String? payrollPeriod,
    bool clearPayrollPeriod = false,
    String? consolidationGroup,
    bool clearConsolidationGroup = false,
    String? runType,
    bool clearRunType = false,
    String? payrollRelationshipGroup,
    bool clearPayrollRelationshipGroup = false,
    DateTime? processStartDate,
    bool clearProcessStartDate = false,
    DateTime? processEndDate,
    bool clearProcessEndDate = false,
    DateTime? dateEarned,
    bool clearDateEarned = false,
    String? elementGroup,
    bool clearElementGroup = false,
    String? reportCategory,
    bool clearReportCategory = false,
    String? processConfigurationGroup,
    bool clearProcessConfigurationGroup = false,
    String? runMode,
  }) {
    return SubmitPayrollFlowState(
      currentStep: currentStep ?? this.currentStep,
      payrollFlow: clearPayrollFlow ? null : (payrollFlow ?? this.payrollFlow),
      schedule: schedule ?? this.schedule,
      scope: clearScope ? null : (scope ?? this.scope),
      payroll: clearPayroll ? null : (payroll ?? this.payroll),
      payrollPeriod: clearPayrollPeriod ? null : (payrollPeriod ?? this.payrollPeriod),
      consolidationGroup: clearConsolidationGroup ? null : (consolidationGroup ?? this.consolidationGroup),
      runType: clearRunType ? null : (runType ?? this.runType),
      payrollRelationshipGroup: clearPayrollRelationshipGroup
          ? null
          : (payrollRelationshipGroup ?? this.payrollRelationshipGroup),
      processStartDate: clearProcessStartDate ? null : (processStartDate ?? this.processStartDate),
      processEndDate: clearProcessEndDate ? null : (processEndDate ?? this.processEndDate),
      dateEarned: clearDateEarned ? null : (dateEarned ?? this.dateEarned),
      elementGroup: clearElementGroup ? null : (elementGroup ?? this.elementGroup),
      reportCategory: clearReportCategory ? null : (reportCategory ?? this.reportCategory),
      processConfigurationGroup: clearProcessConfigurationGroup
          ? null
          : (processConfigurationGroup ?? this.processConfigurationGroup),
      runMode: runMode ?? this.runMode,
    );
  }
}

class SubmitPayrollFlowDefaults {
  const SubmitPayrollFlowDefaults._();

  static const scheduleAsSoonAsPossible = 'asap';
  static const scheduleOnSpecificDate = 'on_specific_date';
  static const scheduleRecurring = 'recurring';
  static const runModeNormal = 'normal';
  static const runModeTest = 'test';
  static const runModeRollback = 'rollback';
}
