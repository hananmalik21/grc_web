import 'perm_action.dart';
import 'perm_catalog.dart';

class PermKeys {
  PermKeys._();

  // ─── Dashboard ─────────────────────────────────────────────────────────────
  static final dashboardAll = kDashboardModule.subModules[0].wildcard;
  static final dashboardCreate = kDashboardModule.subModules[0].action(PermAction.create);
  static final dashboardView = kDashboardModule.subModules[0].action(PermAction.view);
  static final dashboardUpdate = kDashboardModule.subModules[0].action(PermAction.update);
  static final dashboardDelete = kDashboardModule.subModules[0].action(PermAction.delete);

  // ─── Enterprise Structure ──────────────────────────────────────────────────
  // [0] Manage Structure
  static final enterpriseStructureManageAll = kEnterpriseStructureModule.subModules[0].wildcard;
  static final enterpriseStructureManageCreate = kEnterpriseStructureModule.subModules[0].action(PermAction.create);
  static final enterpriseStructureManageView = kEnterpriseStructureModule.subModules[0].action(PermAction.view);
  static final enterpriseStructureManageUpdate = kEnterpriseStructureModule.subModules[0].action(PermAction.update);
  static final enterpriseStructureManageDelete = kEnterpriseStructureModule.subModules[0].action(PermAction.delete);
  static final enterpriseStructureManageActivate = kEnterpriseStructureModule.subModules[0].action(PermAction.activate);

  // [1] Component Values
  static final enterpriseComponentValuesAll = kEnterpriseStructureModule.subModules[1].wildcard;
  static final enterpriseComponentValuesCreate = kEnterpriseStructureModule.subModules[1].action(PermAction.create);
  static final enterpriseComponentValuesView = kEnterpriseStructureModule.subModules[1].action(PermAction.view);
  static final enterpriseComponentValuesUpdate = kEnterpriseStructureModule.subModules[1].action(PermAction.update);
  static final enterpriseComponentValuesDelete = kEnterpriseStructureModule.subModules[1].action(PermAction.delete);

  // [2] Company
  static final enterpriseCompanyAll = kEnterpriseStructureModule.subModules[2].wildcard;
  static final enterpriseCompanyCreate = kEnterpriseStructureModule.subModules[2].action(PermAction.create);
  static final enterpriseCompanyView = kEnterpriseStructureModule.subModules[2].action(PermAction.view);
  static final enterpriseCompanyUpdate = kEnterpriseStructureModule.subModules[2].action(PermAction.update);
  static final enterpriseCompanyDelete = kEnterpriseStructureModule.subModules[2].action(PermAction.delete);

  // [3] Division
  static final enterpriseDivisionAll = kEnterpriseStructureModule.subModules[3].wildcard;
  static final enterpriseDivisionCreate = kEnterpriseStructureModule.subModules[3].action(PermAction.create);
  static final enterpriseDivisionView = kEnterpriseStructureModule.subModules[3].action(PermAction.view);
  static final enterpriseDivisionUpdate = kEnterpriseStructureModule.subModules[3].action(PermAction.update);
  static final enterpriseDivisionDelete = kEnterpriseStructureModule.subModules[3].action(PermAction.delete);

  // [4] Business Unit
  static final enterpriseBusinessUnitAll = kEnterpriseStructureModule.subModules[4].wildcard;
  static final enterpriseBusinessUnitCreate = kEnterpriseStructureModule.subModules[4].action(PermAction.create);
  static final enterpriseBusinessUnitView = kEnterpriseStructureModule.subModules[4].action(PermAction.view);
  static final enterpriseBusinessUnitUpdate = kEnterpriseStructureModule.subModules[4].action(PermAction.update);
  static final enterpriseBusinessUnitDelete = kEnterpriseStructureModule.subModules[4].action(PermAction.delete);

  // [5] Department
  static final enterpriseDepartmentAll = kEnterpriseStructureModule.subModules[5].wildcard;
  static final enterpriseDepartmentCreate = kEnterpriseStructureModule.subModules[5].action(PermAction.create);
  static final enterpriseDepartmentView = kEnterpriseStructureModule.subModules[5].action(PermAction.view);
  static final enterpriseDepartmentUpdate = kEnterpriseStructureModule.subModules[5].action(PermAction.update);
  static final enterpriseDepartmentDelete = kEnterpriseStructureModule.subModules[5].action(PermAction.delete);

  // [6] Section
  static final enterpriseSectionAll = kEnterpriseStructureModule.subModules[6].wildcard;
  static final enterpriseSectionCreate = kEnterpriseStructureModule.subModules[6].action(PermAction.create);
  static final enterpriseSectionView = kEnterpriseStructureModule.subModules[6].action(PermAction.view);
  static final enterpriseSectionUpdate = kEnterpriseStructureModule.subModules[6].action(PermAction.update);
  static final enterpriseSectionDelete = kEnterpriseStructureModule.subModules[6].action(PermAction.delete);

  // ─── Workforce Structure ───────────────────────────────────────────────────
  // [0] Positions
  static final workforcePositionsAll = kWorkforceStructureModule.subModules[0].wildcard;
  static final workforcePositionsCreate = kWorkforceStructureModule.subModules[0].action(PermAction.create);
  static final workforcePositionsView = kWorkforceStructureModule.subModules[0].action(PermAction.view);
  static final workforcePositionsUpdate = kWorkforceStructureModule.subModules[0].action(PermAction.update);
  static final workforcePositionsDelete = kWorkforceStructureModule.subModules[0].action(PermAction.delete);

  // [1] Job Families
  static final workforceJobFamiliesAll = kWorkforceStructureModule.subModules[1].wildcard;
  static final workforceJobFamiliesCreate = kWorkforceStructureModule.subModules[1].action(PermAction.create);
  static final workforceJobFamiliesView = kWorkforceStructureModule.subModules[1].action(PermAction.view);
  static final workforceJobFamiliesUpdate = kWorkforceStructureModule.subModules[1].action(PermAction.update);
  static final workforceJobFamiliesDelete = kWorkforceStructureModule.subModules[1].action(PermAction.delete);

  // [2] Job Levels
  static final workforceJobLevelsAll = kWorkforceStructureModule.subModules[2].wildcard;
  static final workforceJobLevelsCreate = kWorkforceStructureModule.subModules[2].action(PermAction.create);
  static final workforceJobLevelsView = kWorkforceStructureModule.subModules[2].action(PermAction.view);
  static final workforceJobLevelsUpdate = kWorkforceStructureModule.subModules[2].action(PermAction.update);
  static final workforceJobLevelsDelete = kWorkforceStructureModule.subModules[2].action(PermAction.delete);

  // [3] Grade Structure
  static final workforceGradeStructureAll = kWorkforceStructureModule.subModules[3].wildcard;
  static final workforceGradeStructureCreate = kWorkforceStructureModule.subModules[3].action(PermAction.create);
  static final workforceGradeStructureView = kWorkforceStructureModule.subModules[3].action(PermAction.view);
  static final workforceGradeStructureUpdate = kWorkforceStructureModule.subModules[3].action(PermAction.update);
  static final workforceGradeStructureDelete = kWorkforceStructureModule.subModules[3].action(PermAction.delete);

  // [4] Reporting Structure
  static final workforceReportingStructureAll = kWorkforceStructureModule.subModules[4].wildcard;
  static final workforceReportingStructureCreate = kWorkforceStructureModule.subModules[4].action(PermAction.create);
  static final workforceReportingStructureView = kWorkforceStructureModule.subModules[4].action(PermAction.view);
  static final workforceReportingStructureUpdate = kWorkforceStructureModule.subModules[4].action(PermAction.update);
  static final workforceReportingStructureDelete = kWorkforceStructureModule.subModules[4].action(PermAction.delete);

  // [5] Position Tree
  static final workforcePositionTreeAll = kWorkforceStructureModule.subModules[5].wildcard;
  static final workforcePositionTreeCreate = kWorkforceStructureModule.subModules[5].action(PermAction.create);
  static final workforcePositionTreeView = kWorkforceStructureModule.subModules[5].action(PermAction.view);
  static final workforcePositionTreeUpdate = kWorkforceStructureModule.subModules[5].action(PermAction.update);
  static final workforcePositionTreeDelete = kWorkforceStructureModule.subModules[5].action(PermAction.delete);

  // ─── Time Management ───────────────────────────────────────────────────────
  // [0] Shifts
  static final timeManagementShiftsAll = kTimeManagementModule.subModules[0].wildcard;
  static final timeManagementShiftsCreate = kTimeManagementModule.subModules[0].action(PermAction.create);
  static final timeManagementShiftsView = kTimeManagementModule.subModules[0].action(PermAction.view);
  static final timeManagementShiftsUpdate = kTimeManagementModule.subModules[0].action(PermAction.update);
  static final timeManagementShiftsDelete = kTimeManagementModule.subModules[0].action(PermAction.delete);

  // [1] Work Patterns
  static final timeManagementWorkPatternsAll = kTimeManagementModule.subModules[1].wildcard;
  static final timeManagementWorkPatternsCreate = kTimeManagementModule.subModules[1].action(PermAction.create);
  static final timeManagementWorkPatternsView = kTimeManagementModule.subModules[1].action(PermAction.view);
  static final timeManagementWorkPatternsUpdate = kTimeManagementModule.subModules[1].action(PermAction.update);
  static final timeManagementWorkPatternsDelete = kTimeManagementModule.subModules[1].action(PermAction.delete);

  // [2] Work Schedules
  static final timeManagementWorkSchedulesAll = kTimeManagementModule.subModules[2].wildcard;
  static final timeManagementWorkSchedulesCreate = kTimeManagementModule.subModules[2].action(PermAction.create);
  static final timeManagementWorkSchedulesView = kTimeManagementModule.subModules[2].action(PermAction.view);
  static final timeManagementWorkSchedulesUpdate = kTimeManagementModule.subModules[2].action(PermAction.update);
  static final timeManagementWorkSchedulesDelete = kTimeManagementModule.subModules[2].action(PermAction.delete);

  // [3] Schedule Assignments
  static final timeManagementScheduleAssignmentsAll = kTimeManagementModule.subModules[3].wildcard;
  static final timeManagementScheduleAssignmentsCreate = kTimeManagementModule.subModules[3].action(PermAction.create);
  static final timeManagementScheduleAssignmentsView = kTimeManagementModule.subModules[3].action(PermAction.view);
  static final timeManagementScheduleAssignmentsUpdate = kTimeManagementModule.subModules[3].action(PermAction.update);
  static final timeManagementScheduleAssignmentsDelete = kTimeManagementModule.subModules[3].action(PermAction.delete);

  // [4] View Calendar
  static final timeManagementViewCalendarAll = kTimeManagementModule.subModules[4].wildcard;
  static final timeManagementViewCalendarCreate = kTimeManagementModule.subModules[4].action(PermAction.create);
  static final timeManagementViewCalendarView = kTimeManagementModule.subModules[4].action(PermAction.view);
  static final timeManagementViewCalendarUpdate = kTimeManagementModule.subModules[4].action(PermAction.update);
  static final timeManagementViewCalendarDelete = kTimeManagementModule.subModules[4].action(PermAction.delete);

  // [5] Public Holidays
  static final timeManagementPublicHolidaysAll = kTimeManagementModule.subModules[5].wildcard;
  static final timeManagementPublicHolidaysCreate = kTimeManagementModule.subModules[5].action(PermAction.create);
  static final timeManagementPublicHolidaysView = kTimeManagementModule.subModules[5].action(PermAction.view);
  static final timeManagementPublicHolidaysUpdate = kTimeManagementModule.subModules[5].action(PermAction.update);
  static final timeManagementPublicHolidaysDelete = kTimeManagementModule.subModules[5].action(PermAction.delete);

  // ─── Employees ─────────────────────────────────────────────────────────────
  // [0] Manage Employees — matches existing backend key pattern
  static final manageEmployeesAll = kEmployeesModule.subModules[0].wildcard;
  static final manageEmployeesCreate = kEmployeesModule.subModules[0].action(PermAction.create);
  static final manageEmployeesView = kEmployeesModule.subModules[0].action(PermAction.view);
  static final manageEmployeesUpdate = kEmployeesModule.subModules[0].action(PermAction.update);
  static final manageEmployeesDelete = kEmployeesModule.subModules[0].action(PermAction.delete);

  // [1] Employee Actions
  static final employeeActionsAll = kEmployeesModule.subModules[1].wildcard;
  static final employeeActionsCreate = kEmployeesModule.subModules[1].action(PermAction.create);
  static final employeeActionsView = kEmployeesModule.subModules[1].action(PermAction.view);
  static final employeeActionsUpdate = kEmployeesModule.subModules[1].action(PermAction.update);
  static final employeeActionsDelete = kEmployeesModule.subModules[1].action(PermAction.delete);

  // [2] Workforce Planning
  static final employeesWorkforcePlanningAll = kEmployeesModule.subModules[2].wildcard;
  static final employeesWorkforcePlanningCreate = kEmployeesModule.subModules[2].action(PermAction.create);
  static final employeesWorkforcePlanningView = kEmployeesModule.subModules[2].action(PermAction.view);
  static final employeesWorkforcePlanningUpdate = kEmployeesModule.subModules[2].action(PermAction.update);
  static final employeesWorkforcePlanningDelete = kEmployeesModule.subModules[2].action(PermAction.delete);

  // [3] Contracts
  static final employeesContractsAll = kEmployeesModule.subModules[3].wildcard;
  static final employeesContractsCreate = kEmployeesModule.subModules[3].action(PermAction.create);
  static final employeesContractsView = kEmployeesModule.subModules[3].action(PermAction.view);
  static final employeesContractsUpdate = kEmployeesModule.subModules[3].action(PermAction.update);
  static final employeesContractsDelete = kEmployeesModule.subModules[3].action(PermAction.delete);

  // [4] Mark Attendance
  static final employeesMarkAttendanceAll = kEmployeesModule.subModules[4].wildcard;
  static final employeesMarkAttendanceCreate = kEmployeesModule.subModules[4].action(PermAction.create);
  static final employeesMarkAttendanceView = kEmployeesModule.subModules[4].action(PermAction.view);
  static final employeesMarkAttendanceUpdate = kEmployeesModule.subModules[4].action(PermAction.update);
  static final employeesMarkAttendanceDelete = kEmployeesModule.subModules[4].action(PermAction.delete);

  // ─── Employee Self Service ─────────────────────────────────────────────────
  static final essProfileIdentityAll = kEmployeeSelfServiceModule.subModules[0].wildcard;
  static final essProfileIdentityView = kEmployeeSelfServiceModule.subModules[0].action(PermAction.view);
  static final essProfileIdentityUpdate = kEmployeeSelfServiceModule.subModules[0].action(PermAction.update);

  static final essEmploymentInfoAll = kEmployeeSelfServiceModule.subModules[1].wildcard;
  static final essEmploymentInfoView = kEmployeeSelfServiceModule.subModules[1].action(PermAction.view);

  static final essPayBenefitsAll = kEmployeeSelfServiceModule.subModules[2].wildcard;
  static final essPayBenefitsView = kEmployeeSelfServiceModule.subModules[2].action(PermAction.view);

  static final essPayslipsAll = kEmployeeSelfServiceModule.subModules[3].wildcard;
  static final essPayslipsView = kEmployeeSelfServiceModule.subModules[3].action(PermAction.view);

  static final essLeaveAbsenceAll = kEmployeeSelfServiceModule.subModules[4].wildcard;
  static final essLeaveAbsenceCreate = kEmployeeSelfServiceModule.subModules[4].action(PermAction.create);
  static final essLeaveAbsenceView = kEmployeeSelfServiceModule.subModules[4].action(PermAction.view);

  static final essTimeAttendanceAll = kEmployeeSelfServiceModule.subModules[5].wildcard;
  static final essTimeAttendanceView = kEmployeeSelfServiceModule.subModules[5].action(PermAction.view);

  static final essPerformanceAll = kEmployeeSelfServiceModule.subModules[6].wildcard;
  static final essPerformanceView = kEmployeeSelfServiceModule.subModules[6].action(PermAction.view);

  static final essLearningDevelopmentAll = kEmployeeSelfServiceModule.subModules[7].wildcard;
  static final essLearningDevelopmentView = kEmployeeSelfServiceModule.subModules[7].action(PermAction.view);

  static final essDocumentsLettersAll = kEmployeeSelfServiceModule.subModules[8].wildcard;
  static final essDocumentsLettersView = kEmployeeSelfServiceModule.subModules[8].action(PermAction.view);

  static final essRequestsWorkflowAll = kEmployeeSelfServiceModule.subModules[9].wildcard;
  static final essRequestsWorkflowCreate = kEmployeeSelfServiceModule.subModules[9].action(PermAction.create);
  static final essRequestsWorkflowView = kEmployeeSelfServiceModule.subModules[9].action(PermAction.view);

  static final essMobileExperienceAll = kEmployeeSelfServiceModule.subModules[10].wildcard;
  static final essMobileExperienceView = kEmployeeSelfServiceModule.subModules[10].action(PermAction.view);

  // ─── Leave Management ──────────────────────────────────────────────────────
  static final leaveRequestsAll = kLeaveManagementModule.subModules[0].wildcard;
  static final leaveRequestsCreate = kLeaveManagementModule.subModules[0].action(PermAction.create);
  static final leaveRequestsView = kLeaveManagementModule.subModules[0].action(PermAction.view);
  static final leaveRequestsApproval = kLeaveManagementModule.subModules[0].action(PermAction.approval);
  static final leaveRequestsUpdate = kLeaveManagementModule.subModules[0].action(PermAction.update);
  static final leaveRequestsDelete = kLeaveManagementModule.subModules[0].action(PermAction.delete);

  static final leaveBalanceAll = kLeaveManagementModule.subModules[1].wildcard;
  static final leaveBalanceView = kLeaveManagementModule.subModules[1].action(PermAction.view);
  static final leaveBalanceUpdate = kLeaveManagementModule.subModules[1].action(PermAction.update);

  static final myLeaveBalanceAll = kLeaveManagementModule.subModules[2].wildcard;
  static final myLeaveBalanceView = kLeaveManagementModule.subModules[2].action(PermAction.view);

  static final teamLeaveRiskAll = kLeaveManagementModule.subModules[3].wildcard;
  static final teamLeaveRiskView = kLeaveManagementModule.subModules[3].action(PermAction.view);

  static final leavePoliciesAll = kLeaveManagementModule.subModules[4].wildcard;
  static final leavePoliciesCreate = kLeaveManagementModule.subModules[4].action(PermAction.create);
  static final leavePoliciesView = kLeaveManagementModule.subModules[4].action(PermAction.view);
  static final leavePoliciesUpdate = kLeaveManagementModule.subModules[4].action(PermAction.update);
  static final leavePoliciesDelete = kLeaveManagementModule.subModules[4].action(PermAction.delete);

  static final leavePolicyConfigurationAll = kLeaveManagementModule.subModules[5].wildcard;
  static final leavePolicyConfigurationCreate = kLeaveManagementModule.subModules[5].action(PermAction.create);
  static final leavePolicyConfigurationView = kLeaveManagementModule.subModules[5].action(PermAction.view);
  static final leavePolicyConfigurationUpdate = kLeaveManagementModule.subModules[5].action(PermAction.update);

  static final leaveForfeitPolicyAll = kLeaveManagementModule.subModules[6].wildcard;
  static final leaveForfeitPolicyView = kLeaveManagementModule.subModules[6].action(PermAction.view);
  static final leaveForfeitPolicyUpdate = kLeaveManagementModule.subModules[6].action(PermAction.update);

  static final leaveForfeitProcessingAll = kLeaveManagementModule.subModules[7].wildcard;
  static final leaveForfeitProcessingCreate = kLeaveManagementModule.subModules[7].action(PermAction.create);
  static final leaveForfeitProcessingView = kLeaveManagementModule.subModules[7].action(PermAction.view);

  static final leaveForfeitReportsAll = kLeaveManagementModule.subModules[8].wildcard;
  static final leaveForfeitReportsView = kLeaveManagementModule.subModules[8].action(PermAction.view);

  static final leaveCalendarAll = kLeaveManagementModule.subModules[9].wildcard;
  static final leaveCalendarView = kLeaveManagementModule.subModules[9].action(PermAction.view);

  // ─── Time Tracking & Attendance ────────────────────────────────────────────
  static final timeTrackingAttendanceAll = kTimeTrackingModule.subModules[0].wildcard;
  static final timeTrackingAttendanceCreate = kTimeTrackingModule.subModules[0].action(PermAction.create);
  static final timeTrackingAttendanceView = kTimeTrackingModule.subModules[0].action(PermAction.view);
  static final timeTrackingAttendanceUpdate = kTimeTrackingModule.subModules[0].action(PermAction.update);

  static final timeTrackingTimesheetsAll = kTimeTrackingModule.subModules[1].wildcard;
  static final timeTrackingTimesheetsCreate = kTimeTrackingModule.subModules[1].action(PermAction.create);
  static final timeTrackingTimesheetsView = kTimeTrackingModule.subModules[1].action(PermAction.view);
  static final timeTrackingTimesheetsApproval = kTimeTrackingModule.subModules[1].action(PermAction.approval);
  static final timeTrackingTimesheetsUpdate = kTimeTrackingModule.subModules[1].action(PermAction.update);
  static final timeTrackingTimesheetsDelete = kTimeTrackingModule.subModules[1].action(PermAction.delete);

  static final timeTrackingOvertimeAll = kTimeTrackingModule.subModules[2].wildcard;
  static final timeTrackingOvertimeCreate = kTimeTrackingModule.subModules[2].action(PermAction.create);
  static final timeTrackingOvertimeView = kTimeTrackingModule.subModules[2].action(PermAction.view);
  static final timeTrackingOvertimeApproval = kTimeTrackingModule.subModules[2].action(PermAction.approval);
  static final timeTrackingOvertimeUpdate = kTimeTrackingModule.subModules[2].action(PermAction.update);
  static final timeTrackingOvertimeDelete = kTimeTrackingModule.subModules[2].action(PermAction.delete);

  static final timeTrackingOvertimeConfigurationAll = kTimeTrackingModule.subModules[3].wildcard;
  static final timeTrackingOvertimeConfigurationCreate = kTimeTrackingModule.subModules[3].action(PermAction.create);
  static final timeTrackingOvertimeConfigurationView = kTimeTrackingModule.subModules[3].action(PermAction.view);
  static final timeTrackingOvertimeConfigurationUpdate = kTimeTrackingModule.subModules[3].action(PermAction.update);

  static final timeTrackingAttendanceSummaryAll = kTimeTrackingModule.subModules[4].wildcard;
  static final timeTrackingAttendanceSummaryView = kTimeTrackingModule.subModules[4].action(PermAction.view);

  static final timeTrackingGeoLocationsAll = kTimeTrackingModule.subModules[5].wildcard;
  static final timeTrackingGeoLocationsCreate = kTimeTrackingModule.subModules[5].action(PermAction.create);
  static final timeTrackingGeoLocationsView = kTimeTrackingModule.subModules[5].action(PermAction.view);
  static final timeTrackingGeoLocationsUpdate = kTimeTrackingModule.subModules[5].action(PermAction.update);
  static final timeTrackingGeoLocationsDelete = kTimeTrackingModule.subModules[5].action(PermAction.delete);

  static final timeTrackingEmployeeLocationsAll = kTimeTrackingModule.subModules[6].wildcard;
  static final timeTrackingEmployeeLocationsView = kTimeTrackingModule.subModules[6].action(PermAction.view);

  // ─── Compensation ──────────────────────────────────────────────────────────
  static final compensationGradeStructureAll = kCompensationModule.subModules[0].wildcard;
  static final compensationGradeStructureCreate = kCompensationModule.subModules[0].action(PermAction.create);
  static final compensationGradeStructureView = kCompensationModule.subModules[0].action(PermAction.view);
  static final compensationGradeStructureUpdate = kCompensationModule.subModules[0].action(PermAction.update);
  static final compensationGradeStructureDelete = kCompensationModule.subModules[0].action(PermAction.delete);

  static final compensationSetupConfigAll = kCompensationModule.subModules[1].wildcard;
  static final compensationSetupConfigCreate = kCompensationModule.subModules[1].action(PermAction.create);
  static final compensationSetupConfigView = kCompensationModule.subModules[1].action(PermAction.view);
  static final compensationSetupConfigUpdate = kCompensationModule.subModules[1].action(PermAction.update);

  static final compensationLocalizationAll = kCompensationModule.subModules[2].wildcard;
  static final compensationLocalizationCreate = kCompensationModule.subModules[2].action(PermAction.create);
  static final compensationLocalizationView = kCompensationModule.subModules[2].action(PermAction.view);
  static final compensationLocalizationUpdate = kCompensationModule.subModules[2].action(PermAction.update);

  static final compensationComponentsAll = kCompensationModule.subModules[3].wildcard;
  static final compensationComponentsCreate = kCompensationModule.subModules[3].action(PermAction.create);
  static final compensationComponentsView = kCompensationModule.subModules[3].action(PermAction.view);
  static final compensationComponentsUpdate = kCompensationModule.subModules[3].action(PermAction.update);
  static final compensationComponentsDelete = kCompensationModule.subModules[3].action(PermAction.delete);

  static final compensationSalaryStructuresAll = kCompensationModule.subModules[4].wildcard;
  static final compensationSalaryStructuresCreate = kCompensationModule.subModules[4].action(PermAction.create);
  static final compensationSalaryStructuresView = kCompensationModule.subModules[4].action(PermAction.view);
  static final compensationSalaryStructuresUpdate = kCompensationModule.subModules[4].action(PermAction.update);
  static final compensationSalaryStructuresDelete = kCompensationModule.subModules[4].action(PermAction.delete);

  static final compensationPlansAll = kCompensationModule.subModules[5].wildcard;
  static final compensationPlansCreate = kCompensationModule.subModules[5].action(PermAction.create);
  static final compensationPlansView = kCompensationModule.subModules[5].action(PermAction.view);
  static final compensationPlansUpdate = kCompensationModule.subModules[5].action(PermAction.update);
  static final compensationPlansDelete = kCompensationModule.subModules[5].action(PermAction.delete);

  static final compensationSimulationAll = kCompensationModule.subModules[6].wildcard;
  static final compensationSimulationView = kCompensationModule.subModules[6].action(PermAction.view);

  static final compensationEmployeeCompensationAll = kCompensationModule.subModules[7].wildcard;
  static final compensationEmployeeCompensationCreate = kCompensationModule.subModules[7].action(PermAction.create);
  static final compensationEmployeeCompensationView = kCompensationModule.subModules[7].action(PermAction.view);
  static final compensationEmployeeCompensationUpdate = kCompensationModule.subModules[7].action(PermAction.update);
  static final compensationEmployeeCompensationDelete = kCompensationModule.subModules[7].action(PermAction.delete);

  static final compensationAllowancesBenefitsAll = kCompensationModule.subModules[8].wildcard;
  static final compensationAllowancesBenefitsCreate = kCompensationModule.subModules[8].action(PermAction.create);
  static final compensationAllowancesBenefitsView = kCompensationModule.subModules[8].action(PermAction.view);
  static final compensationAllowancesBenefitsUpdate = kCompensationModule.subModules[8].action(PermAction.update);
  static final compensationAllowancesBenefitsDelete = kCompensationModule.subModules[8].action(PermAction.delete);

  static final compensationBonusesIncentivesAll = kCompensationModule.subModules[9].wildcard;
  static final compensationBonusesIncentivesCreate = kCompensationModule.subModules[9].action(PermAction.create);
  static final compensationBonusesIncentivesView = kCompensationModule.subModules[9].action(PermAction.view);
  static final compensationBonusesIncentivesUpdate = kCompensationModule.subModules[9].action(PermAction.update);
  static final compensationBonusesIncentivesDelete = kCompensationModule.subModules[9].action(PermAction.delete);

  static final compensationAdjustmentsAll = kCompensationModule.subModules[10].wildcard;
  static final compensationAdjustmentsCreate = kCompensationModule.subModules[10].action(PermAction.create);
  static final compensationAdjustmentsView = kCompensationModule.subModules[10].action(PermAction.view);
  static final compensationAdjustmentsUpdate = kCompensationModule.subModules[10].action(PermAction.update);
  static final compensationAdjustmentsDelete = kCompensationModule.subModules[10].action(PermAction.delete);

  static final compensationBulkAdjustmentsAll = kCompensationModule.subModules[11].wildcard;
  static final compensationBulkAdjustmentsCreate = kCompensationModule.subModules[11].action(PermAction.create);
  static final compensationBulkAdjustmentsView = kCompensationModule.subModules[11].action(PermAction.view);
  static final compensationBulkAdjustmentsUpdate = kCompensationModule.subModules[11].action(PermAction.update);

  static final compensationSalaryChangeHistoryAll = kCompensationModule.subModules[12].wildcard;
  static final compensationSalaryChangeHistoryView = kCompensationModule.subModules[12].action(PermAction.view);

  static final compensationMeritPlanningAll = kCompensationModule.subModules[13].wildcard;
  static final compensationMeritPlanningCreate = kCompensationModule.subModules[13].action(PermAction.create);
  static final compensationMeritPlanningView = kCompensationModule.subModules[13].action(PermAction.view);
  static final compensationMeritPlanningUpdate = kCompensationModule.subModules[13].action(PermAction.update);

  static final compensationRevisionHistoryAll = kCompensationModule.subModules[14].wildcard;
  static final compensationRevisionHistoryView = kCompensationModule.subModules[14].action(PermAction.view);

  // ─── Security Manager ──────────────────────────────────────────────────────
  static final securityOverviewAll = kSecurityModule.subModules[0].wildcard;
  static final securityOverviewView = kSecurityModule.subModules[0].action(PermAction.view);

  static final securityUserManagementAll = kSecurityModule.subModules[1].wildcard;
  static final securityUserManagementCreate = kSecurityModule.subModules[1].action(PermAction.create);
  static final securityUserManagementView = kSecurityModule.subModules[1].action(PermAction.view);
  static final securityUserManagementUpdate = kSecurityModule.subModules[1].action(PermAction.update);
  static final securityUserManagementDelete = kSecurityModule.subModules[1].action(PermAction.delete);

  static final securityAccessManagementAll = kSecurityModule.subModules[2].wildcard;
  static final securityAccessManagementCreate = kSecurityModule.subModules[2].action(PermAction.create);
  static final securityAccessManagementView = kSecurityModule.subModules[2].action(PermAction.view);
  static final securityAccessManagementUpdate = kSecurityModule.subModules[2].action(PermAction.update);
  static final securityAccessManagementDelete = kSecurityModule.subModules[2].action(PermAction.delete);

  static final securityRolesManagementAll = kSecurityModule.subModules[3].wildcard;
  static final securityRolesManagementCreate = kSecurityModule.subModules[3].action(PermAction.create);
  static final securityRolesManagementView = kSecurityModule.subModules[3].action(PermAction.view);
  static final securityRolesManagementUpdate = kSecurityModule.subModules[3].action(PermAction.update);
  static final securityRolesManagementDelete = kSecurityModule.subModules[3].action(PermAction.delete);

  static final securityPoliciesAll = kSecurityModule.subModules[4].wildcard;
  static final securityPoliciesCreate = kSecurityModule.subModules[4].action(PermAction.create);
  static final securityPoliciesView = kSecurityModule.subModules[4].action(PermAction.view);
  static final securityPoliciesUpdate = kSecurityModule.subModules[4].action(PermAction.update);

  static final securityActiveSessionsAll = kSecurityModule.subModules[5].wildcard;
  static final securityActiveSessionsView = kSecurityModule.subModules[5].action(PermAction.view);
  static final securityActiveSessionsDelete = kSecurityModule.subModules[5].action(PermAction.delete);

  static final securityAlertsAll = kSecurityModule.subModules[6].wildcard;
  static final securityAlertsView = kSecurityModule.subModules[6].action(PermAction.view);
  static final securityAlertsUpdate = kSecurityModule.subModules[6].action(PermAction.update);

  static final securityDataClassificationAll = kSecurityModule.subModules[7].wildcard;
  static final securityDataClassificationCreate = kSecurityModule.subModules[7].action(PermAction.create);
  static final securityDataClassificationView = kSecurityModule.subModules[7].action(PermAction.view);
  static final securityDataClassificationUpdate = kSecurityModule.subModules[7].action(PermAction.update);
  static final securityDataClassificationDelete = kSecurityModule.subModules[7].action(PermAction.delete);

  static final securityRoleDelegationAll = kSecurityModule.subModules[8].wildcard;
  static final securityRoleDelegationCreate = kSecurityModule.subModules[8].action(PermAction.create);
  static final securityRoleDelegationView = kSecurityModule.subModules[8].action(PermAction.view);
  static final securityRoleDelegationUpdate = kSecurityModule.subModules[8].action(PermAction.update);
  static final securityRoleDelegationDelete = kSecurityModule.subModules[8].action(PermAction.delete);

  static final securitySegregationOfDutiesAll = kSecurityModule.subModules[9].wildcard;
  static final securitySegregationOfDutiesCreate = kSecurityModule.subModules[9].action(PermAction.create);
  static final securitySegregationOfDutiesView = kSecurityModule.subModules[9].action(PermAction.view);
  static final securitySegregationOfDutiesUpdate = kSecurityModule.subModules[9].action(PermAction.update);

  // ─── Single-screen modules ─────────────────────────────────────────────────
  static final payrollPersonResultsAll = kPayrollModule.subModules[0].wildcard;
  static final payrollPersonResultsCreate = kPayrollModule.subModules[0].action(PermAction.create);
  static final payrollPersonResultsView = kPayrollModule.subModules[0].action(PermAction.view);
  static final payrollPersonResultsUpdate = kPayrollModule.subModules[0].action(PermAction.update);

  static final payrollElementMappingAll = kPayrollModule.subModules[1].wildcard;
  static final payrollElementMappingCreate = kPayrollModule.subModules[1].action(PermAction.create);
  static final payrollElementMappingView = kPayrollModule.subModules[1].action(PermAction.view);
  static final payrollElementMappingUpdate = kPayrollModule.subModules[1].action(PermAction.update);

  static final payrollSubmitPayrollFlowAll = kPayrollModule.subModules[2].wildcard;
  static final payrollSubmitPayrollFlowCreate = kPayrollModule.subModules[2].action(PermAction.create);
  static final payrollSubmitPayrollFlowView = kPayrollModule.subModules[2].action(PermAction.view);
  static final payrollSubmitPayrollFlowUpdate = kPayrollModule.subModules[2].action(PermAction.update);

  static final payrollFlowMonitorAll = kPayrollModule.subModules[3].wildcard;
  static final payrollFlowMonitorCreate = kPayrollModule.subModules[3].action(PermAction.create);
  static final payrollFlowMonitorView = kPayrollModule.subModules[3].action(PermAction.view);
  static final payrollFlowMonitorUpdate = kPayrollModule.subModules[3].action(PermAction.update);

  static final complianceAll = kGrcModule.subModules[0].wildcard;
  static final complianceView = kGrcModule.subModules[0].action(PermAction.view);
  static final complianceUpdate = kGrcModule.subModules[0].action(PermAction.update);

  static final grcDashboardView = kGrcModule.subModules[0].action(PermAction.view);
  static final grcLibraryView = kGrcModule.subModules[1].action(PermAction.view);
  static final grcAssetsView = kGrcModule.subModules[2].action(PermAction.view);
  static final grcRisksView = kGrcModule.subModules[3].action(PermAction.view);
  static final grcAssessmentsView = kGrcModule.subModules[4].action(PermAction.view);
  static final grcControlsView = kGrcModule.subModules[5].action(PermAction.view);
  static final grcTprmView = kGrcModule.subModules[6].action(PermAction.view);
  static final grcProgramsView = kGrcModule.subModules[7].action(PermAction.view);

  static final eosCalculatorAll = kEosCalculatorModule.subModules[0].wildcard;
  static final eosCalculatorView = kEosCalculatorModule.subModules[0].action(PermAction.view);

  static final reportsAll = kReportsModule.subModules[0].wildcard;
  static final reportsCreate = kReportsModule.subModules[0].action(PermAction.create);
  static final reportsView = kReportsModule.subModules[0].action(PermAction.view);

  static final governmentFormsAll = kGovernmentFormsModule.subModules[0].wildcard;
  static final governmentFormsCreate = kGovernmentFormsModule.subModules[0].action(PermAction.create);
  static final governmentFormsView = kGovernmentFormsModule.subModules[0].action(PermAction.view);

  static final deiDashboardAll = kDeiModule.subModules[0].wildcard;
  static final deiDashboardView = kDeiModule.subModules[0].action(PermAction.view);

  static final hrOperationsAll = kHrOperationsModule.subModules[0].wildcard;
  static final hrOperationsCreate = kHrOperationsModule.subModules[0].action(PermAction.create);
  static final hrOperationsView = kHrOperationsModule.subModules[0].action(PermAction.view);
  static final hrOperationsUpdate = kHrOperationsModule.subModules[0].action(PermAction.update);

  static final jobSchedulesAll = kJobSchedulesModule.subModules[0].wildcard;
  static final jobSchedulesCreate = kJobSchedulesModule.subModules[0].action(PermAction.create);
  static final jobSchedulesView = kJobSchedulesModule.subModules[0].action(PermAction.view);
  static final jobSchedulesUpdate = kJobSchedulesModule.subModules[0].action(PermAction.update);

  static final settingsAll = kSettingsModule.subModules[0].wildcard;
  static final settingsView = kSettingsModule.subModules[0].action(PermAction.view);
  static final settingsUpdate = kSettingsModule.subModules[0].action(PermAction.update);

  static final hiringRequisitionsAll = kHiringModule.subModules[0].wildcard;
  static final hiringRequisitionsCreate = kHiringModule.subModules[0].action(PermAction.create);
  static final hiringRequisitionsView = kHiringModule.subModules[0].action(PermAction.view);
  static final hiringRequisitionsUpdate = kHiringModule.subModules[0].action(PermAction.update);

  static final hiringCandidatesAll = kHiringModule.subModules[1].wildcard;
  static final hiringCandidatesCreate = kHiringModule.subModules[1].action(PermAction.create);
  static final hiringCandidatesView = kHiringModule.subModules[1].action(PermAction.view);
  static final hiringCandidatesUpdate = kHiringModule.subModules[1].action(PermAction.update);

  static final hiringApplicationsAll = kHiringModule.subModules[2].wildcard;
  static final hiringApplicationsCreate = kHiringModule.subModules[2].action(PermAction.create);
  static final hiringApplicationsView = kHiringModule.subModules[2].action(PermAction.view);
  static final hiringApplicationsUpdate = kHiringModule.subModules[2].action(PermAction.update);

  static final hiringInterviewsAll = kHiringModule.subModules[3].wildcard;
  static final hiringInterviewsCreate = kHiringModule.subModules[3].action(PermAction.create);
  static final hiringInterviewsView = kHiringModule.subModules[3].action(PermAction.view);
  static final hiringInterviewsUpdate = kHiringModule.subModules[3].action(PermAction.update);

  static final hiringOffersAll = kHiringModule.subModules[4].wildcard;
  static final hiringOffersCreate = kHiringModule.subModules[4].action(PermAction.create);
  static final hiringOffersView = kHiringModule.subModules[4].action(PermAction.view);
  static final hiringOffersUpdate = kHiringModule.subModules[4].action(PermAction.update);

  static final hiringHrInterfaceAll = kHiringModule.subModules[5].wildcard;
  static final hiringHrInterfaceView = kHiringModule.subModules[5].action(PermAction.view);
  static final hiringHrInterfaceUpdate = kHiringModule.subModules[5].action(PermAction.update);

  static final hiringCareerSiteAll = kHiringModule.subModules[6].wildcard;
  static final hiringCareerSiteView = kHiringModule.subModules[6].action(PermAction.view);
  static final hiringCareerSiteUpdate = kHiringModule.subModules[6].action(PermAction.update);

  static final developerFunctionManagementAll = kDeveloperToolsModule.subModules[0].wildcard;
  static final developerFunctionManagementCreate = kDeveloperToolsModule.subModules[0].action(PermAction.create);
  static final developerFunctionManagementView = kDeveloperToolsModule.subModules[0].action(PermAction.view);
  static final developerFunctionManagementUpdate = kDeveloperToolsModule.subModules[0].action(PermAction.update);
  static final developerFunctionManagementDelete = kDeveloperToolsModule.subModules[0].action(PermAction.delete);

  static final developerDesktopManagementAll = kDeveloperToolsModule.subModules[1].wildcard;
  static final developerDesktopManagementCreate = kDeveloperToolsModule.subModules[1].action(PermAction.create);
  static final developerDesktopManagementView = kDeveloperToolsModule.subModules[1].action(PermAction.view);
  static final developerDesktopManagementUpdate = kDeveloperToolsModule.subModules[1].action(PermAction.update);
  static final developerDesktopManagementDelete = kDeveloperToolsModule.subModules[1].action(PermAction.delete);
}
