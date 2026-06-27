enum PayrollProcessTaskStatus { complete, inProgress }

class PayrollProcessResultTask {
  const PayrollProcessResultTask({
    required this.taskName,
    required this.status,
    required this.flowName,
    required this.processDate,
    required this.payroll,
    required this.payrollPeriod,
    required this.amount,
  });

  final String taskName;
  final PayrollProcessTaskStatus status;
  final String flowName;
  final String processDate;
  final String payroll;
  final String payrollPeriod;
  final String amount;

  String statusLabel({required String completeLabel, required String inProgressLabel}) {
    return switch (status) {
      PayrollProcessTaskStatus.complete => completeLabel,
      PayrollProcessTaskStatus.inProgress => inProgressLabel,
    };
  }
}

const kMockPayrollProcessResultTasks = <PayrollProcessResultTask>[
  PayrollProcessResultTask(
    taskName: 'Archive Periodic Payroll Results',
    status: PayrollProcessTaskStatus.complete,
    flowName: 'BGH PAYROLL JUN26',
    processDate: '30 Jun 2026',
    payroll: 'Digify Solutions LLC. Payroll',
    payrollPeriod: 'June 2026',
    amount: 'KWD 1,948.915',
  ),
  PayrollProcessResultTask(
    taskName: 'Calculate Prepayments',
    status: PayrollProcessTaskStatus.complete,
    flowName: 'BGH PAYROLL JUN26',
    processDate: '29 Jun 2026',
    payroll: 'Digify Solutions LLC. Payroll',
    payrollPeriod: 'June 2026',
    amount: 'KWD 2,000.000',
  ),
  PayrollProcessResultTask(
    taskName: 'Calculate Payroll',
    status: PayrollProcessTaskStatus.complete,
    flowName: 'BGH PAYROLL JUN26',
    processDate: '28 Jun 2026',
    payroll: 'Digify Solutions LLC. Payroll',
    payrollPeriod: 'June 2026',
    amount: 'KWD 2,000.000',
  ),
  PayrollProcessResultTask(
    taskName: 'Generate Payslips',
    status: PayrollProcessTaskStatus.complete,
    flowName: 'Generate Payslips Feb 2026',
    processDate: '28 Feb 2026',
    payroll: 'Digify Solutions LLC. Payroll',
    payrollPeriod: 'February 2026',
    amount: 'KWD 3,056.965',
  ),
  PayrollProcessResultTask(
    taskName: 'Make EFT Payments',
    status: PayrollProcessTaskStatus.complete,
    flowName: 'Make EFT Payments - DIGIFY FEB2026',
    processDate: '28 Feb 2026',
    payroll: 'Digify Solutions LLC. Payroll',
    payrollPeriod: 'February 2026',
    amount: 'KWD 3,056.965',
  ),
  PayrollProcessResultTask(
    taskName: 'Transfer to General Ledger',
    status: PayrollProcessTaskStatus.inProgress,
    flowName: 'BGH PAYROLL JUN26',
    processDate: '30 Jun 2026',
    payroll: 'Digify Solutions LLC. Payroll',
    payrollPeriod: 'June 2026',
    amount: 'KWD 0.000',
  ),
];
