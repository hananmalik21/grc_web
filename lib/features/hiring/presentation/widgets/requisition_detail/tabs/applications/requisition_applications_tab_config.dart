import 'application_data.dart';

class RequisitionApplicationsTabConfig {
  RequisitionApplicationsTabConfig._();

  static List<ApplicationData> get mockApplications => [
    ApplicationData(
      id: 'APP-2026-001',
      name: 'Alex Martinez',
      appliedDate: '2026-04-18',
      source: 'LinkedIn',
      currentStage: 'Interview 1',
      status: 'Interview',
    ),
    ApplicationData(
      id: 'APP-2026-002',
      name: 'Jamie Thompson',
      appliedDate: '2026-04-19',
      source: 'Employee Referral',
      currentStage: 'Shortlisted',
      status: 'Shortlisted',
    ),
    ApplicationData(
      id: 'APP-2026-004',
      name: 'Alex Martinez',
      appliedDate: '2026-04-18',
      source: 'LinkedIn',
      currentStage: 'Selected',
      status: 'Selected',
    ),
  ];

  static const int pageSize = 10;
}
