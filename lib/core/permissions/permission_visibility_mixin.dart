import 'package:flutter/foundation.dart';
import 'package:grc/core/enums/nav_item_ids.dart';

import 'perm_catalog.dart';
import 'perm_keys.dart';
import 'perm_module.dart';
import 'permission_service.dart';

mixin PermissionVisibilityMixin {
  static final Map<String, PermModule> _sidebarModuleByItemId = {
    NavItemIds.dashboard: kDashboardModule,
    NavItemIds.enterpriseStructure: kEnterpriseStructureModule,
    NavItemIds.workforceStructure: kWorkforceStructureModule,
    NavItemIds.timeManagement: kTimeManagementModule,
    NavItemIds.employees: kEmployeesModule,
    NavItemIds.employeeSelfService: kEmployeeSelfServiceModule,
    NavItemIds.leaveManagement: kLeaveManagementModule,
    NavItemIds.timeTrackingAttendance: kTimeTrackingModule,
    NavItemIds.compensation: kCompensationModule,
    NavItemIds.securityManager: kSecurityModule,
    NavItemIds.payroll: kPayrollModule,
    NavItemIds.compliance: kGrcModule,
    NavItemIds.grc: kGrcModule,
    NavItemIds.eosCalculator: kEosCalculatorModule,
    NavItemIds.reports: kReportsModule,
    NavItemIds.governmentForms: kGovernmentFormsModule,
    NavItemIds.deiDashboard: kDeiModule,
    NavItemIds.hrOperations: kHrOperationsModule,
    NavItemIds.settingsConfig: kSettingsModule,
    NavItemIds.hiring: kHiringModule,
    NavItemIds.developerTools: kDeveloperToolsModule,
  };

  static final Map<String, String> _sidebarPermissionKeyByItemId = {
    'manageEnterpriseStructure': PermKeys.enterpriseStructureManageView,
    'manageComponentValues': PermKeys.enterpriseComponentValuesView,
    'company': PermKeys.enterpriseCompanyView,
    'division': PermKeys.enterpriseDivisionView,
    'businessUnit': PermKeys.enterpriseBusinessUnitView,
    'department': PermKeys.enterpriseDepartmentView,
    'section': PermKeys.enterpriseSectionView,
    'positions': PermKeys.workforcePositionsView,
    'jobFamilies': PermKeys.workforceJobFamiliesView,
    'jobLevels': PermKeys.workforceJobLevelsView,
    'gradeStructure': PermKeys.workforceGradeStructureView,
    'reportingStructure': PermKeys.workforceReportingStructureView,
    'positionTree': PermKeys.workforcePositionTreeView,
    'shifts': PermKeys.timeManagementShiftsView,
    'workPatterns': PermKeys.timeManagementWorkPatternsView,
    'workSchedules': PermKeys.timeManagementWorkSchedulesView,
    'scheduleAssignments': PermKeys.timeManagementScheduleAssignmentsView,
    'viewCalendar': PermKeys.timeManagementViewCalendarView,
    'publicHolidays': PermKeys.timeManagementPublicHolidaysView,
    'manageEmployees': PermKeys.manageEmployeesView,
    'employeeActions': PermKeys.employeeActionsView,
    'workforcePlanning': PermKeys.employeesWorkforcePlanningView,
    'contracts': PermKeys.employeesContractsView,
    'markAttendance': PermKeys.employeesMarkAttendanceView,
    'essProfileIdentity': PermKeys.essProfileIdentityView,
    'essEmploymentInfo': PermKeys.essEmploymentInfoView,
    'essPayBenefits': PermKeys.essPayBenefitsView,
    'essMyPayslips': PermKeys.essPayslipsView,
    'essLeaveAbsence': PermKeys.essLeaveAbsenceView,
    'essTimeAttendance': PermKeys.essTimeAttendanceView,
    'essPerformance': PermKeys.essPerformanceView,
    'essLearningDevelopment': PermKeys.essLearningDevelopmentView,
    'essDocumentsLetters': PermKeys.essDocumentsLettersView,
    'essRequestsWorkflow': PermKeys.essRequestsWorkflowView,
    'essMobileExperience': PermKeys.essMobileExperienceView,
    'leaveRequests': PermKeys.leaveRequestsView,
    'leaveBalance': PermKeys.leaveBalanceView,
    'myLeaveBalance': PermKeys.myLeaveBalanceView,
    'teamLeaveRisk': PermKeys.teamLeaveRiskView,
    'leavePolicies': PermKeys.leavePoliciesView,
    'policyConfiguration': PermKeys.leavePolicyConfigurationView,
    'forfeitPolicy': PermKeys.leaveForfeitPolicyView,
    'forfeitProcessing': PermKeys.leaveForfeitProcessingView,
    'forfeitReports': PermKeys.leaveForfeitReportsView,
    'leaveCalendar': PermKeys.leaveCalendarView,
    'attendance': PermKeys.timeTrackingAttendanceView,
    'timesheet': PermKeys.timeTrackingTimesheetsView,
    'overtime': PermKeys.timeTrackingOvertimeView,
    'overtimeConfiguration': PermKeys.timeTrackingOvertimeConfigurationView,
    'attendanceSummary': PermKeys.timeTrackingAttendanceSummaryView,
    'geoLocations': PermKeys.timeTrackingGeoLocationsView,
    'employeeLocations': PermKeys.timeTrackingEmployeeLocationsView,
    'gradeStructureManagement': PermKeys.compensationGradeStructureView,
    'setupAndConfiguration': PermKeys.compensationSetupConfigView,
    'localization': PermKeys.compensationLocalizationView,
    'components': PermKeys.compensationComponentsView,
    'manageSalaryStructure': PermKeys.compensationSalaryStructuresView,
    'compensationPlans': PermKeys.compensationPlansView,
    'compensationSimulation': PermKeys.compensationSimulationView,
    'employeeCompensation': PermKeys.compensationEmployeeCompensationView,
    'allowancesAndBenefits': PermKeys.compensationAllowancesBenefitsView,
    'bonusesAndIncentives': PermKeys.compensationBonusesIncentivesView,
    'adjustments': PermKeys.compensationAdjustmentsView,
    'bulkAdjustments': PermKeys.compensationBulkAdjustmentsView,
    'salaryChangeHistory': PermKeys.compensationSalaryChangeHistoryView,
    'meritPlanning': PermKeys.compensationMeritPlanningView,
    'revisionHistory': PermKeys.compensationRevisionHistoryView,
    'securityOverview': PermKeys.securityOverviewView,
    'userManagement': PermKeys.securityUserManagementView,
    'accessManagement': PermKeys.securityAccessManagementView,
    'rolesManagement': PermKeys.securityRolesManagementView,
    'securityPolicies': PermKeys.securityPoliciesView,
    'activeSessions': PermKeys.securityActiveSessionsView,
    'securityAlerts': PermKeys.securityAlertsView,
    'dataClassification': PermKeys.securityDataClassificationView,
    'roleDelegation': PermKeys.securityRoleDelegationView,
    'segregationOfDuties': PermKeys.securitySegregationOfDutiesView,
    NavItemIds.payrollPersonResults: PermKeys.payrollPersonResultsView,
    NavItemIds.payrollManageElementEntries: PermKeys.payrollElementMappingView,
    NavItemIds.payrollSubmitPayrollFlow: PermKeys.payrollSubmitPayrollFlowView,
    NavItemIds.payrollFlowMonitor: PermKeys.payrollFlowMonitorView,
    NavItemIds.hiringRequisitions: PermKeys.hiringRequisitionsView,
    NavItemIds.hiringCandidates: PermKeys.hiringCandidatesView,
    NavItemIds.hiringApplications: PermKeys.hiringApplicationsView,
    NavItemIds.hiringInterviews: PermKeys.hiringInterviewsView,
    NavItemIds.hiringOffers: PermKeys.hiringOffersView,
    NavItemIds.hiringHrInterface: PermKeys.hiringHrInterfaceView,
    NavItemIds.hiringCareerSite: PermKeys.hiringCareerSiteView,
    NavItemIds.functionManagement: PermKeys.developerFunctionManagementView,
    NavItemIds.desktopManagement: PermKeys.developerDesktopManagementView,
    NavItemIds.grcDashboard: PermKeys.grcDashboardView,
    NavItemIds.grcLibrary: PermKeys.grcLibraryView,
    NavItemIds.grcAssets: PermKeys.grcAssetsView,
    NavItemIds.grcRisks: PermKeys.grcRisksView,
    NavItemIds.grcAssessments: PermKeys.grcAssessmentsView,
    NavItemIds.grcControls: PermKeys.grcControlsView,
    NavItemIds.grcTprm: PermKeys.grcTprmView,
    NavItemIds.grcPrograms: PermKeys.grcProgramsView,
  };

  static final Map<String, PermModule> _dashboardModuleByButtonId = {
    NavItemIds.dashboard: kDashboardModule,
    NavItemIds.enterpriseStructureButton: kEnterpriseStructureModule,
    NavItemIds.workforceStructureButton: kWorkforceStructureModule,
    NavItemIds.timeManagementButton: kTimeManagementModule,
    NavItemIds.employees: kEmployeesModule,
    NavItemIds.employeeSelfServiceButton: kEmployeeSelfServiceModule,
    NavItemIds.leaveManagementButton: kLeaveManagementModule,
    NavItemIds.timeTrackingAttendanceButton: kTimeTrackingModule,
    NavItemIds.compensation: kCompensationModule,
    NavItemIds.jobSchedulesButton: kJobSchedulesModule,
    NavItemIds.securityManager: kSecurityModule,
    NavItemIds.payroll: kPayrollModule,
    NavItemIds.compliance: kGrcModule,
    NavItemIds.grc: kGrcModule,
    NavItemIds.eosCalculatorButton: kEosCalculatorModule,
    NavItemIds.reports: kReportsModule,
    NavItemIds.governmentFormsButton: kGovernmentFormsModule,
    NavItemIds.deiDashboardButton: kDeiModule,
    NavItemIds.hrOperationsButton: kHrOperationsModule,
    NavItemIds.settings: kSettingsModule,
    NavItemIds.hiring: kHiringModule,
  };

  static final Map<String, String> _dashboardPermissionKeyByButtonId = {
    NavItemIds.developerTools: PermKeys.developerFunctionManagementView,
  };

  bool canAccessSidebarItemId(String itemId) {
    if (PermissionService.instance.isBypassAllPermissions) return true;
    if (itemId == NavItemIds.dashboard) {
      return true;
    }
    if (_isDeveloperToolsItem(itemId)) return kDebugMode;
    return _canAccess(id: itemId, moduleMap: _sidebarModuleByItemId, keyMap: _sidebarPermissionKeyByItemId);
  }

  bool canAccessDashboardButtonId(String buttonId) {
    if (PermissionService.instance.isBypassAllPermissions) return true;
    if (_isDeveloperToolsItem(buttonId)) return kDebugMode;
    return _canAccess(id: buttonId, moduleMap: _dashboardModuleByButtonId, keyMap: _dashboardPermissionKeyByButtonId);
  }

  bool _isDeveloperToolsItem(String id) {
    return id == NavItemIds.developerTools || id == NavItemIds.functionManagement || id == NavItemIds.desktopManagement;
  }

  bool _canAccess({
    required String id,
    required Map<String, PermModule> moduleMap, // module
    required Map<String, String> keyMap, // submodule
  }) {
    final module = moduleMap[id];
    if (module != null) {
      return PermissionService.instance.canSeeModule(module);
    }

    final permissionKey = keyMap[id];
    if (permissionKey == null) return false;
    return PermissionService.instance.can(permissionKey);
  }
}
