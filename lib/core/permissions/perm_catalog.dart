import 'package:grc/core/router/app_routes.dart';

import 'perm_module.dart';

// ─── Dashboard ───────────────────────────────────────────────────────────────

const kDashboardModule = PermModule(
  label: 'Dashboard',
  baseKey: 'dashboard',
  subModules: [PermSubModule(label: 'Dashboard', baseKey: 'dashboard.overview', route: AppRoutes.dashboard)],
);

// ─── Enterprise Structure ────────────────────────────────────────────────────

const kEnterpriseStructureModule = PermModule(
  label: 'Enterprise Structure',
  baseKey: 'enterprise_structure',
  subModules: [
    PermSubModule(
      label: 'Manage Structure',
      baseKey: 'enterprise_structure.manage_enterprise_structure',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Component Values',
      baseKey: 'enterprise_structure.manage_component_values',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(label: 'Company', baseKey: 'enterprise_structure.company', route: AppRoutes.enterpriseStructure),
    PermSubModule(label: 'Division', baseKey: 'enterprise_structure.division', route: AppRoutes.enterpriseStructure),
    PermSubModule(
      label: 'Business Unit',
      baseKey: 'enterprise_structure.business_unit',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(
      label: 'Department',
      baseKey: 'enterprise_structure.department',
      route: AppRoutes.enterpriseStructure,
    ),
    PermSubModule(label: 'Section', baseKey: 'enterprise_structure.section', route: AppRoutes.enterpriseStructure),
  ],
);

// ─── Workforce Structure ─────────────────────────────────────────────────────

const kWorkforceStructureModule = PermModule(
  label: 'Workforce Structure',
  baseKey: 'workforce_structure',
  subModules: [
    PermSubModule(label: 'Positions', baseKey: 'workforce_structure.positions', route: AppRoutes.workforceStructure),
    PermSubModule(
      label: 'Job Families',
      baseKey: 'workforce_structure.job_family',
      route: AppRoutes.workforceStructure,
    ),
    PermSubModule(label: 'Job Levels', baseKey: 'workforce_structure.job_level', route: AppRoutes.workforceStructure),
    PermSubModule(label: 'Grade Structure', baseKey: 'workforce_structure.grade', route: AppRoutes.workforceStructure),
    PermSubModule(
      label: 'Reporting Structure',
      baseKey: 'workforce_structure.reporting_structure',
      route: AppRoutes.workforceStructure,
    ),
    PermSubModule(
      label: 'Position Tree',
      baseKey: 'workforce_structure.position_tree',
      route: AppRoutes.workforceStructure,
    ),
  ],
);

// ─── Time Management ─────────────────────────────────────────────────────────

const kTimeManagementModule = PermModule(
  label: 'Time Management',
  baseKey: 'time_management',
  subModules: [
    PermSubModule(label: 'Shifts', baseKey: 'time_management.shifts', route: AppRoutes.timeManagement),
    PermSubModule(label: 'Work Patterns', baseKey: 'time_management.work_patterns', route: AppRoutes.timeManagement),
    PermSubModule(label: 'Work Schedules', baseKey: 'time_management.work_schedules', route: AppRoutes.timeManagement),
    PermSubModule(
      label: 'Schedule Assignments',
      baseKey: 'time_management.schedule_assignments',
      route: AppRoutes.timeManagement,
    ),
    PermSubModule(label: 'View Calendar', baseKey: 'time_management.view_calendar', route: AppRoutes.timeManagement),
    PermSubModule(
      label: 'Public Holidays',
      baseKey: 'time_management.public_holidays',
      route: AppRoutes.timeManagement,
    ),
  ],
);

// ─── Employees ───────────────────────────────────────────────────────────────

const kEmployeesModule = PermModule(
  label: 'Employees',
  baseKey: 'employees',
  subModules: [
    PermSubModule(label: 'Manage Employees', baseKey: 'employees.manage_employees', route: AppRoutes.employees),
    PermSubModule(label: 'Employee Actions', baseKey: 'employees.employee_actions', route: AppRoutes.employees),
    PermSubModule(label: 'Workforce Planning', baseKey: 'employees.workforce_planning', route: AppRoutes.employees),
    PermSubModule(label: 'Contracts', baseKey: 'employees.contracts', route: AppRoutes.employees),
    PermSubModule(label: 'Mark Attendance', baseKey: 'employees.mark_attendance', route: AppRoutes.employees),
  ],
);

// ─── Employee Self Service ────────────────────────────────────────────────────

const kEmployeeSelfServiceModule = PermModule(
  label: 'Employee Self Service',
  baseKey: 'employee_self_service',
  subModules: [
    PermSubModule(
      label: 'Profile & Identity',
      baseKey: 'employee_self_service.profile_identity',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Employment Info',
      baseKey: 'employee_self_service.employment_info',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Pay & Benefits',
      baseKey: 'employee_self_service.pay_benefits',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'My Payslips',
      baseKey: 'employee_self_service.payslips',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Leave & Absence',
      baseKey: 'employee_self_service.leave_absence',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Time & Attendance',
      baseKey: 'employee_self_service.time_attendance',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Performance',
      baseKey: 'employee_self_service.performance',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Learning & Development',
      baseKey: 'employee_self_service.learning_development',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Documents & Letters',
      baseKey: 'employee_self_service.documents_letters',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Requests & Workflow',
      baseKey: 'employee_self_service.requests_workflow',
      route: AppRoutes.employeeSelfService,
    ),
    PermSubModule(
      label: 'Mobile Experience',
      baseKey: 'employee_self_service.mobile_experience',
      route: AppRoutes.employeeSelfService,
    ),
  ],
);

// ─── Leave Management ─────────────────────────────────────────────────────────

const kLeaveManagementModule = PermModule(
  label: 'Leave Management',
  baseKey: 'leave_management',
  subModules: [
    PermSubModule(
      label: 'Leave Requests',
      baseKey: 'leave_management.leave_requests',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(label: 'Leave Balance', baseKey: 'leave_management.leave_balances', route: AppRoutes.leaveManagement),
    PermSubModule(
      label: 'My Leave Balance',
      baseKey: 'leave_management.my_leave_balance',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(
      label: 'Team Leave Risk',
      baseKey: 'leave_management.team_leave_risk',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(
      label: 'Leave Policies',
      baseKey: 'leave_management.leave_policies',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(
      label: 'Policy Configuration',
      baseKey: 'leave_management.policy_configurations',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(
      label: 'Forfeit Policy',
      baseKey: 'leave_management.forfeit_policy',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(
      label: 'Forfeit Processing',
      baseKey: 'leave_management.forfeit_processing',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(
      label: 'Forfeit Reports',
      baseKey: 'leave_management.forfeit_reports',
      route: AppRoutes.leaveManagement,
    ),
    PermSubModule(
      label: 'Leave Calendar',
      baseKey: 'leave_management.leave_calendar',
      route: AppRoutes.leaveManagement,
    ),
  ],
);

// ─── Time Tracking & Attendance ───────────────────────────────────────────────

const kTimeTrackingModule = PermModule(
  label: 'Time Tracking & Attendance',
  baseKey: 'time_tracking',
  subModules: [
    PermSubModule(
      label: 'Daily Attendance',
      baseKey: 'time_tracking.daily_attendance',
      route: AppRoutes.timeTrackingAndAttendance,
    ),
    PermSubModule(
      label: 'Timesheets',
      baseKey: 'time_tracking.time_sheets',
      route: AppRoutes.timeTrackingAndAttendance,
    ),
    PermSubModule(label: 'Overtime', baseKey: 'time_tracking.overtime', route: AppRoutes.timeTrackingAndAttendance),
    PermSubModule(
      label: 'Overtime Configuration',
      baseKey: 'time_tracking.overtime_configurations',
      route: AppRoutes.timeTrackingAndAttendance,
    ),
    PermSubModule(
      label: 'Attendance Summary',
      baseKey: 'time_tracking.attendance_summary',
      route: AppRoutes.timeTrackingAndAttendance,
    ),
    PermSubModule(
      label: 'Geo Locations',
      baseKey: 'time_tracking.geo_locations',
      route: AppRoutes.timeTrackingAndAttendance,
    ),
    PermSubModule(
      label: 'Employee Locations',
      baseKey: 'time_tracking.employee_locations',
      route: AppRoutes.timeTrackingAndAttendance,
    ),
  ],
);

// ─── Compensation ─────────────────────────────────────────────────────────────

const kCompensationModule = PermModule(
  label: 'Compensation',
  baseKey: 'compensation',
  subModules: [
    PermSubModule(
      label: 'Grade Structure Management',
      baseKey: 'compensation.grade_structure_management',
      route: AppRoutes.compensation,
    ),
    PermSubModule(
      label: 'Setup & Configuration',
      baseKey: 'compensation.setup_configuration',
      route: AppRoutes.compensation,
    ),
    PermSubModule(
      label: 'Localization',
      baseKey: 'compensation.localization',
      route: AppRoutes.compensationLocalization,
    ),
    PermSubModule(label: 'Components', baseKey: 'compensation.components', route: AppRoutes.compensationComponents),
    PermSubModule(
      label: 'Manage Salary Structure',
      baseKey: 'compensation.manage_salary_structure',
      route: AppRoutes.compensationManageSalaryStructure,
    ),
    PermSubModule(
      label: 'Compensation Plans',
      baseKey: 'compensation.compensation_plans',
      route: AppRoutes.compensationCompensationPlans,
    ),
    PermSubModule(
      label: 'Compensation Simulation',
      baseKey: 'compensation.compensation_simulation',
      route: AppRoutes.compensationCompensationSimulation,
    ),
    PermSubModule(
      label: 'Employee Compensation',
      baseKey: 'compensation.employee_compensation',
      route: AppRoutes.compensationEmployeeCompensation,
    ),
    PermSubModule(
      label: 'Allowances & Benefits',
      baseKey: 'compensation.allowances_benefits',
      route: AppRoutes.compensationAllowancesAndBenefits,
    ),
    PermSubModule(
      label: 'Bonuses & Incentives',
      baseKey: 'compensation.bonuses_incentives',
      route: AppRoutes.compensationBonusesAndIncentives,
    ),
    PermSubModule(label: 'Adjustments', baseKey: 'compensation.adjustments', route: AppRoutes.compensationAdjustments),
    PermSubModule(
      label: 'Bulk Adjustments',
      baseKey: 'compensation.bulk_adjustments',
      route: AppRoutes.compensationBulkAdjustments,
    ),
    PermSubModule(
      label: 'Salary Change History',
      baseKey: 'compensation.salary_change_history',
      route: AppRoutes.compensation,
    ),
    PermSubModule(
      label: 'Merit Planning',
      baseKey: 'compensation.merit_planning',
      route: AppRoutes.compensationMeritPlanning,
    ),
    PermSubModule(
      label: 'Revision History',
      baseKey: 'compensation.revision_history',
      route: AppRoutes.compensationRevisionHistory,
    ),
  ],
);

// ─── Security Manager ─────────────────────────────────────────────────────────

const kSecurityModule = PermModule(
  label: 'Security Manager',
  baseKey: 'security_manager',
  subModules: [
    PermSubModule(label: 'Security Overview', baseKey: 'security_manager.overview', route: AppRoutes.securityManager),
    PermSubModule(
      label: 'User Management',
      baseKey: 'security_manager.user_management',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Access Management',
      baseKey: 'security_manager.access_management',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Roles Management',
      baseKey: 'security_manager.roles_management',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Security Policies',
      baseKey: 'security_manager.security_policies',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Active Sessions',
      baseKey: 'security_manager.active_sessions',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Security Alerts',
      baseKey: 'security_manager.security_alerts',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Data Classification',
      baseKey: 'security_manager.data_classification',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Role Delegation',
      baseKey: 'security_manager.role_delegation',
      route: AppRoutes.securityManager,
    ),
    PermSubModule(
      label: 'Segregation of Duties',
      baseKey: 'security_manager.segregation_of_duties',
      route: AppRoutes.securityManager,
    ),
  ],
);

// ─── Single-screen modules ────────────────────────────────────────────────────

const kPayrollModule = PermModule(
  label: 'Payroll',
  baseKey: 'payroll',
  subModules: [
    PermSubModule(label: 'Person Results', baseKey: 'payroll.person_results', route: AppRoutes.payroll),
    PermSubModule(label: 'Manage Element Entries', baseKey: 'payroll.element_mapping', route: AppRoutes.payroll),
    PermSubModule(label: 'Submit Payroll Flow', baseKey: 'payroll.submit_payroll_flow', route: AppRoutes.payroll),
    PermSubModule(label: 'Flow Monitor', baseKey: 'payroll.flow_monitor', route: AppRoutes.payroll),
  ],
);

const kGrcModule = PermModule(
  label: 'GRC',
  baseKey: 'grc',
  subModules: [
    PermSubModule(label: 'Dashboard', baseKey: 'grc.dashboard', route: AppRoutes.grc),
    PermSubModule(label: 'Library', baseKey: 'grc.library', route: AppRoutes.grc),
    PermSubModule(label: 'Assets', baseKey: 'grc.assets', route: AppRoutes.grc),
    PermSubModule(label: 'Risks', baseKey: 'grc.risks', route: AppRoutes.grc),
    PermSubModule(label: 'Assessments', baseKey: 'grc.assessments', route: AppRoutes.grc),
    PermSubModule(label: 'Controls', baseKey: 'grc.controls', route: AppRoutes.grc),
    PermSubModule(label: 'TPRM', baseKey: 'grc.tprm', route: AppRoutes.grc),
    PermSubModule(label: 'Programs', baseKey: 'grc.programs', route: AppRoutes.grc),
  ],
);

/// Legacy alias — GRC replaces the compliance placeholder.
const kComplianceModule = kGrcModule;

const kEosCalculatorModule = PermModule(
  label: 'EOS Calculator',
  baseKey: 'eos_calculator',
  subModules: [
    PermSubModule(label: 'EOS Calculator', baseKey: 'eos_calculator.manage', route: AppRoutes.eosCalculator),
  ],
);

const kReportsModule = PermModule(
  label: 'Reports',
  baseKey: 'reports',
  subModules: [PermSubModule(label: 'Reports', baseKey: 'reports.manage', route: AppRoutes.reports)],
);

const kGovernmentFormsModule = PermModule(
  label: 'Government Forms',
  baseKey: 'government_forms',
  subModules: [
    PermSubModule(label: 'Government Forms', baseKey: 'government_forms.manage', route: AppRoutes.governmentForms),
  ],
);

const kDeiModule = PermModule(
  label: 'DEI Dashboard',
  baseKey: 'dei',
  subModules: [PermSubModule(label: 'DEI Dashboard', baseKey: 'dei.dashboard', route: AppRoutes.deiDashboard)],
);

const kHrOperationsModule = PermModule(
  label: 'HR Operations',
  baseKey: 'hr_operations',
  subModules: [PermSubModule(label: 'HR Operations', baseKey: 'hr_operations.manage', route: AppRoutes.hrOperations)],
);

const kJobSchedulesModule = PermModule(
  label: 'Job Schedules',
  baseKey: 'job_schedules',
  subModules: [PermSubModule(label: 'Job Schedules', baseKey: 'job_schedules.manage', route: AppRoutes.jobSchedules)],
);

const kSettingsModule = PermModule(
  label: 'Settings',
  baseKey: 'settings',
  subModules: [
    PermSubModule(label: 'Settings & Configurations', baseKey: 'settings.manage', route: AppRoutes.settings),
  ],
);

const kHiringModule = PermModule(
  label: 'Hiring',
  baseKey: 'hiring',
  subModules: [
    PermSubModule(label: 'Requisitions', baseKey: 'hiring.requisitions', route: AppRoutes.hiring),
    PermSubModule(label: 'Candidates', baseKey: 'hiring.candidates', route: AppRoutes.hiring),
    PermSubModule(label: 'Applications', baseKey: 'hiring.applications', route: AppRoutes.hiring),
    PermSubModule(label: 'Interviews', baseKey: 'hiring.interviews', route: AppRoutes.hiring),
    PermSubModule(label: 'Offers', baseKey: 'hiring.offers', route: AppRoutes.hiring),
    PermSubModule(label: 'HR Interface', baseKey: 'hiring.hr_interface', route: AppRoutes.hiring),
    PermSubModule(label: 'Career Site', baseKey: 'hiring.career_site', route: AppRoutes.hiring),
  ],
);

const kDeveloperToolsModule = PermModule(
  label: 'Developer Tools',
  baseKey: 'developer_tools',
  subModules: [
    PermSubModule(
      label: 'Function Management',
      baseKey: 'developer_tools.function_management',
      route: AppRoutes.developerTools,
    ),
    PermSubModule(
      label: 'Desktop Management',
      baseKey: 'developer_tools.desktop_management',
      route: AppRoutes.developerTools,
    ),
  ],
);

// ─── Master list ──────────────────────────────────────────────────────────────

const kAllModules = <PermModule>[
  kDashboardModule,
  kEnterpriseStructureModule,
  kWorkforceStructureModule,
  kTimeManagementModule,
  kEmployeesModule,
  kEmployeeSelfServiceModule,
  kLeaveManagementModule,
  kTimeTrackingModule,
  kCompensationModule,
  kSecurityModule,
  kPayrollModule,
  kComplianceModule,
  kEosCalculatorModule,
  kReportsModule,
  kGovernmentFormsModule,
  kDeiModule,
  kHrOperationsModule,
  kJobSchedulesModule,
  kSettingsModule,
  kHiringModule,
  kDeveloperToolsModule,
];
