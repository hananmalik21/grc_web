import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/states/submit_payroll_flow_state.dart';

class SubmitPayrollFlowConfig {
  const SubmitPayrollFlowConfig._();

  static const payrollFlowOptions = <String>[
    'Digify Simplified Payroll Cycle KW',
    'BGH PAYROLL JUN26',
    'Generate Payslips Feb 2026',
    'Make EFT Payments - DIGIFY FEB2026',
  ];

  static const scheduleOptions = <String>[
    SubmitPayrollFlowDefaults.scheduleAsSoonAsPossible,
    SubmitPayrollFlowDefaults.scheduleOnSpecificDate,
    SubmitPayrollFlowDefaults.scheduleRecurring,
  ];

  static const scopeOptions = <String>['Payroll', 'Assignment', 'Payroll Relationship', 'Organization'];

  static const payrollOptions = <String>['Digify Solutions LLC. Payroll'];

  static const payrollPeriodOptions = <String>['June 2026', 'May 2026', 'February 2026'];

  static const consolidationGroupOptions = <String>['Monthly Payroll', 'Weekly Payroll'];

  static const runTypeOptions = <String>['Regular Normal', 'Regular', 'Supplemental', 'Correction'];

  static const payrollRelationshipGroupOptions = <String>['All Employees', 'Kuwait LDG', 'Digify Solutions LLC'];

  static const elementGroupOptions = <String>[
    'Standard Earnings',
    'Supplemental Earnings',
    'Employee Tax Deductions',
    'Information',
    'Absences',
    'Employer Charges',
  ];

  static const reportCategoryOptions = <String>['Payroll Register', 'Payslip Summary', 'Costing', 'Statutory Reports'];

  static const processConfigurationGroupOptions = <String>['Standard Payroll Config', 'Kuwait Payroll Config'];

  static const runModeOptions = <String>[
    SubmitPayrollFlowDefaults.runModeNormal,
    SubmitPayrollFlowDefaults.runModeTest,
    SubmitPayrollFlowDefaults.runModeRollback,
  ];

  static String scheduleLabel(AppLocalizations loc, String value) {
    return switch (value) {
      SubmitPayrollFlowDefaults.scheduleAsSoonAsPossible => loc.payrollSubmitPayrollFlowScheduleAsSoonAsPossible,
      SubmitPayrollFlowDefaults.scheduleOnSpecificDate => 'On specific date',
      SubmitPayrollFlowDefaults.scheduleRecurring => 'Recurring schedule',
      _ => value,
    };
  }

  static String runModeLabel(AppLocalizations loc, String value) {
    return switch (value) {
      SubmitPayrollFlowDefaults.runModeNormal => loc.payrollSubmitPayrollFlowRunModeNormal,
      SubmitPayrollFlowDefaults.runModeTest => 'Test',
      SubmitPayrollFlowDefaults.runModeRollback => 'Rollback',
      _ => value,
    };
  }
}
