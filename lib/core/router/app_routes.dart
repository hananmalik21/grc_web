/// Centralized route paths for the entire application
/// All route paths should be defined here to maintain consistency
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String login = '/login';
  static const String signup = '/signup';

  // Dashboard routes
  static const String dashboard = '/dashboard';
  static const String dashboardModuleSelection = '$dashboard/module-selection';
  static const String dashboardModuleSelectionParam = 'moduleId';
  static String dashboardModuleSelectionPath(String moduleId) => '$dashboardModuleSelection/$moduleId';
  static const String dashboardOverview = '$dashboard/overview';
  static const String dashboardAnalytics = '$dashboard/analytics';
  static const String dashboardQuickActions = '$dashboard/quick-actions';

  // Module Catalogue
  static const String moduleCatalogue = '/module-catalogue';

  // Product Intro
  static const String productIntro = '/product-intro';

  // Enterprise Structure routes
  static const String enterpriseStructure = '/enterprise-structure';
  static const String enterpriseStructureManage = '$enterpriseStructure/manage';
  static const String enterpriseStructureComponentValues = '$enterpriseStructure/component-values';
  static const String enterpriseStructureCompany = '$enterpriseStructure/company';
  static const String enterpriseStructureDivision = '$enterpriseStructure/division';
  static const String enterpriseStructureBusinessUnit = '$enterpriseStructure/business-unit';
  static const String enterpriseStructureDepartment = '$enterpriseStructure/department';
  static const String enterpriseStructureSection = '$enterpriseStructure/section';

  // Workforce Structure routes
  static const String workforceStructure = '/workforce-structure';

  // Time Management routes
  static const String timeManagement = '/time-management';

  // Employees routes
  static const String employees = '/employees';
  static const String employeesList = '$employees/list';
  static const String employeesAdd = '$employees/add';
  static const String employeesActions = '$employees/actions';
  static const String employeesOrgStructure = '$employees/org-structure';
  static const String employeesWorkforcePlanning = '$employees/workforce-planning';
  static const String employeesPositions = '$employees/positions';
  static const String employeesContracts = '$employees/contracts';
  static const String employeeDetail = '$employees/detail';
  static const String employeeSelfService = '/employee-ss';

  // Time Tracking and Attendance routes
  static const String timeTrackingAndAttendance = '/time-tracking-and-attendance';
  static const String attendance = '$timeTrackingAndAttendance/attendance';
  static const String timesheet = '$timeTrackingAndAttendance/timesheet';
  static const String overtime = '$timeTrackingAndAttendance/overtime';

  static const String timeTrackingTimesheetDetailSegment = 'timesheet-detail';
  static const String timeTrackingTimesheetDetail = '$timeTrackingAndAttendance/$timeTrackingTimesheetDetailSegment';

  // Compensation routes
  static const String compensation = '/compensation';
  static const String compensationGradeStructureManagement = '$compensation/grade-structure-management';
  static const String compensationSetupAndConfiguration = '$compensation/setup-and-configuration';
  static const String compensationLocalization = '$compensation/localization';
  static const String compensationLocalizationCountryRule = '$compensationLocalization/country-rule';
  static const String compensationComponents = '$compensation/components';
  static const String compensationComponentCreation = '$compensationComponents/component-creation';
  static const String compensationManageSalaryStructure = '$compensation/manage-salary-structure';
  static const String compensationManageSalaryStructureCreate = '$compensationManageSalaryStructure/create';
  static const String compensationManageSalaryStructureEditSegment = 'manage-salary-structure/edit/:structureGuid';
  static const String compensationManageSalaryStructureEdit =
      '$compensation/$compensationManageSalaryStructureEditSegment';
  static const String compensationCompensationPlans = '$compensation/compensation-plans';
  static const String compensationCompensationPlansCreate = '$compensationCompensationPlans/create';
  static const String compensationCompensationPlansDetailSegment = 'compensation-plans/detail';
  static const String compensationCompensationPlansDetail = '$compensation/$compensationCompensationPlansDetailSegment';
  static const String compensationCompensationPlansEditSegment = 'compensation-plans/edit/:planGuid';
  static const String compensationCompensationPlansEdit = '$compensation/$compensationCompensationPlansEditSegment';
  static const String compensationCompensationSimulation = '$compensation/compensation-simulation';
  static const String compensationEmployeeCompensation = '$compensation/employee-compensation';
  static const String compensationEmployeeCompensationCreate = '$compensationEmployeeCompensation/create-plan';
  static const String compensationEmployeeCompensationDetailSegment = 'employee-compensation/detail';
  static const String compensationEmployeeCompensationDetail =
      '$compensation/$compensationEmployeeCompensationDetailSegment';
  static const String compensationAllowancesAndBenefits = '$compensation/allowances-and-benefits';
  static const String compensationBonusesAndIncentives = '$compensation/bonuses-and-incentives';
  static const String compensationAdjustments = '$compensation/adjustments';
  static const String compensationAdjustmentsCreateSegment = 'adjustments/create';
  static const String compensationAdjustmentsCreate = '$compensationAdjustments/create';
  static const String compensationBulkAdjustments = '$compensation/bulk-adjustments';
  static const String compensationMeritPlanning = '$compensation/merit-planning';
  static const String compensationRevisionHistory = '$compensation/revision-history';

  // Security routes
  static const String securityManager = '/security-console';
  static const String developerTools = '/developer-tools';

  static const String securityManagerUserShow = '$securityManager/user/show';

  // Other routes
  static const String leaveManagement = '/leave-management';
  static const String leaveManagementLeaveRequests = '$leaveManagement/leave-requests';
  static const String leaveManagementEmployeeLeaveHistorySegment = 'employee-leave-history';
  static const String leaveManagementEmployeeLeaveHistory =
      '$leaveManagement/$leaveManagementEmployeeLeaveHistorySegment';
  static const String leaveManagementLeaveBalance = '$leaveManagement/leave-balance';
  static const String leaveManagementMyLeaveBalance = '$leaveManagement/my-leave-balance';
  static const String payroll = '/payroll';
  static const String payrollAddElement = '$payroll/add-element';
  static const String payrollPersonResultDetailSegment = 'person-result-detail';
  static const String payrollPersonResultDetail = '$payroll/$payrollPersonResultDetailSegment';
  static const String payrollPersonResultTaskDetailSegment = 'task-detail';
  static const String payrollPersonResultTaskDetail =
      '$payroll/$payrollPersonResultDetailSegment/$payrollPersonResultTaskDetailSegment';
  static const String grc = '/grc';
  static const String compliance = grc;
  static const String eosCalculator = '/eos-calculator';
  static const String reports = '/reports';
  static const String governmentForms = '/government-forms';
  static const String deiDashboard = '/dei-dashboard';
  static const String hrOperations = '/hr-operations';
  static const String jobSchedules = '/job-schedules';
  static const String settings = '/settings';
  static const String hiring = '/hiring';
  static const String hiringRequisitionDetailSegment = 'requisition-detail';
  static const String hiringRequisitionDetail = '$hiring/$hiringRequisitionDetailSegment';
  static const String hiringRequisitionCreate = '$hiring/requisition-create';
  static const String hiringRequisitionEdit = '$hiring/requisition-edit';
  static const String hiringRequisitionDuplicate = '$hiring/requisition-duplicate';
  static const String hiringCandidateDetailSegment = 'candidate-detail';
  static const String hiringCandidateDetail = '$hiring/$hiringCandidateDetailSegment';
  static const String hiringApplicationDetailSegment = 'application-detail';
  static const String hiringApplicationDetail = '$hiring/$hiringApplicationDetailSegment';
  static const String hiringOfferCreate = '$hiring/offer-create';
  static const String home = '/home';
}
