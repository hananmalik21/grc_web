import 'approval_step_data.dart';

class RequisitionApprovalWorkflowTabConfig {
  RequisitionApprovalWorkflowTabConfig._();

  static List<ApprovalStepData> get mockApprovalSteps => [
    ApprovalStepData(
      step: 1,
      name: 'Sarah Chen',
      role: 'Hiring Manager',
      status: 'APPROVED',
      date: '2026-04-02',
      comment: 'Approved - urgent need for the platform team',
    ),
    ApprovalStepData(
      step: 2,
      name: 'Tom Wilson',
      role: 'Department Head',
      status: 'APPROVED',
      date: '2026-04-03',
      comment: 'Budget allocated, approved',
    ),
    ApprovalStepData(
      step: 3,
      name: 'Lisa Anderson',
      role: 'HR Manager',
      status: 'APPROVED',
      date: '2026-04-04',
      comment: 'Approved to proceed with posting',
    ),
    ApprovalStepData(
      step: 4,
      name: 'Michael Roberts',
      role: 'Finance Manager',
      status: 'PENDING',
      date: '-',
      comment: '',
    ),
  ];

  static const int pageSize = 10;
}
