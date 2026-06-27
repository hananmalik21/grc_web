import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/configs/menu_feature_config.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/core/permissions/permission_visibility_mixin.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/gen/assets.gen.dart';

final _sidebarPermissionVisibility = _SidebarPermissionVisibility();

class _SidebarPermissionVisibility with PermissionVisibilityMixin {}

class SidebarConfig {
  static bool _hasPermission(SidebarItem item) {
    return _sidebarPermissionVisibility.canAccessSidebarItemId(item.id);
  }

  static List<SidebarItem> _filterItems(List<SidebarItem> items) {
    final result = <SidebarItem>[];
    for (final item in items) {
      if (!MenuFeatureConfig.isEnabled(item.id)) continue; // Like basic hidden items not shoing in the UI in any case
      if (item.children != null) {
        if (!_hasPermission(item)) continue;
        final filteredChildren = _filterItems(item.children!);
        if (filteredChildren.isEmpty) continue;
        result.add(
          SidebarItem(
            id: item.id,
            icon: item.icon,
            svgPath: item.svgPath,
            labelKey: item.labelKey,
            children: filteredChildren,
            route: item.route,
            subtitle: item.subtitle,
          ),
        );
      } else {
        if (!_hasPermission(item)) continue;
        result.add(item);
      }
    }
    return result;
  }

  static List<SidebarItem> getMenuItems() {
    return _filterItems([
      SidebarItem(
        id: 'dashboard',
        svgPath: Assets.icons.dashboardIcon.path,
        labelKey: 'dashboard',
        route: AppRoutes.dashboard,
      ),
      SidebarItem(
        id: 'enterpriseStructure',
        svgPath: Assets.icons.enterpriseStructureIcon.path,
        labelKey: 'enterpriseStructure',
        subtitle: 'Company, division, department & more',
        children: [
          SidebarItem(
            id: 'manageEnterpriseStructure',
            svgPath: Assets.icons.manageEnterpriseIcon.path,
            labelKey: 'manageEnterpriseStructure',
            route: '/enterprise-structure',
          ),
          SidebarItem(
            id: 'manageComponentValues',
            svgPath: Assets.icons.manageComponentIcon.path,
            labelKey: 'manageComponentValues',
            route: '/enterprise-structure',
          ),
          SidebarItem(
            id: 'company',
            svgPath: Assets.icons.companyIcon.path,
            labelKey: 'company',
            route: '/enterprise-structure',
          ),
          SidebarItem(
            id: 'division',
            svgPath: Assets.icons.divisionIcon.path,
            labelKey: 'division',
            route: '/enterprise-structure',
          ),
          SidebarItem(
            id: 'businessUnit',
            svgPath: Assets.icons.businessUnitIcon.path,
            labelKey: 'businessUnit',
            route: '/enterprise-structure',
          ),
          SidebarItem(
            id: 'department',
            svgPath: Assets.icons.departmentIcon.path,
            labelKey: 'department',
            route: '/enterprise-structure',
          ),
          SidebarItem(
            id: 'section',
            svgPath: Assets.icons.sectionIcon.path,
            labelKey: 'section',
            route: '/enterprise-structure',
          ),
        ],
      ),
      SidebarItem(
        id: 'workforceStructure',
        svgPath: Assets.icons.workforceStructureIcon.path,
        labelKey: 'workforceStructure',
        subtitle: 'Positions, grades & reporting structure',
        children: [
          SidebarItem(
            id: 'positions',
            svgPath: Assets.icons.businessUnitIcon.path,
            labelKey: 'positions',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'jobFamilies',
            svgPath: Assets.icons.workforce.workforceTab.path,
            labelKey: 'jobFamilies',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'jobLevels',
            svgPath: Assets.icons.workforce.fillRate.path,
            labelKey: 'jobLevels',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'gradeStructure',
            svgPath: Assets.icons.sidebar.gradeSidebar.path,
            labelKey: 'gradeStructure',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'reportingStructure',
            svgPath: Assets.icons.companyIcon.path,
            labelKey: 'reportingStructure',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'positionTree',
            svgPath: Assets.icons.positionsIcon.path,
            labelKey: 'positionTree',
            route: '/workforce-structure',
          ),
        ],
      ),
      SidebarItem(
        id: 'timeManagement',
        svgPath: Assets.icons.clockIcon.path,
        labelKey: 'timeManagement',
        subtitle: 'Shifts, schedules & calendar',
        children: [
          SidebarItem(
            id: 'shifts',
            svgPath: Assets.icons.clockIcon.path,
            labelKey: 'shifts',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'workPatterns',
            svgPath: Assets.icons.leaveManagementIcon.path,
            labelKey: 'workPatterns',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'workSchedules',
            svgPath: Assets.icons.sidebar.workSchedules.path,
            labelKey: 'workSchedules',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'scheduleAssignments',
            svgPath: Assets.icons.sidebar.scheduleAssignments.path,
            labelKey: 'scheduleAssignments',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'viewCalendar',
            svgPath: Assets.icons.sidebar.workSchedules.path,
            labelKey: 'viewCalendar',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'publicHolidays',
            svgPath: Assets.icons.sidebar.publicHolidays.path,
            labelKey: 'publicHolidays',
            route: '/time-management',
          ),
        ],
      ),
      SidebarItem(
        id: 'employees',
        svgPath: Assets.icons.employeesIcon.path,
        labelKey: 'employees',
        subtitle: 'Manage employees & lifecycle actions',
        children: [
          SidebarItem(
            id: 'manageEmployees',
            svgPath: Assets.icons.employeeListIcon.path,
            labelKey: 'manageEmployees',
            route: '/employees',
            subtitle: 'View & manage employees',
          ),
          SidebarItem(
            id: 'employeeActions',
            svgPath: Assets.icons.employeeActionsIcon.path,
            labelKey: 'employeeActions',
            route: '/employees',
            subtitle: '60+ lifecycle actions',
          ),
          SidebarItem(
            id: 'workforcePlanning',
            svgPath: Assets.icons.workforcePlanningIcon.path,
            labelKey: 'workforcePlanning',
            route: '/employees',
            subtitle: 'Headcount planning',
          ),
          SidebarItem(
            id: 'contracts',
            svgPath: Assets.icons.contractsIcon.path,
            labelKey: 'contracts',
            route: '/employees',
            subtitle: 'Digital contract management',
          ),
          SidebarItem(
            id: 'markAttendance',
            svgPath: Assets.icons.attendance.halfDay.path,
            labelKey: 'markAttendance',
            route: '/employees',
            subtitle: 'Test camera flow',
          ),
        ],
      ),
      SidebarItem(
        id: 'employeeSs',
        svgPath: Assets.icons.managementIconDepartment.path,
        labelKey: 'employeeSelfService',
        subtitle: 'Profile, payslips, leaves & requests',
        children: [
          SidebarItem(
            id: 'essProfileIdentity',
            svgPath: Assets.icons.auditTrailIcon.path,
            labelKey: 'employeeSelfServiceProfileIdentity',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essEmploymentInfo',
            svgPath: Assets.icons.businessUnitBasicIcon.path,
            labelKey: 'employeeSelfServiceEmploymentInfo',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essPayBenefits',
            svgPath: Assets.icons.budgetGreenIcon.path,
            labelKey: 'employeeSelfServicePayBenefits',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essMyPayslips',
            svgPath: Assets.icons.employeeSelfService.payslips.path,
            labelKey: 'employeeSelfServiceMyPayslips',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essLeaveAbsence',
            svgPath: Assets.icons.auditTrailIconDepartment.path,
            labelKey: 'employeeSelfServiceLeaveAbsence',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essTimeAttendance',
            svgPath: Assets.icons.clockIcon.path,
            labelKey: 'employeeSelfServiceTimeAttendance',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essPerformance',
            svgPath: Assets.icons.descriptionDeptIcon.path,
            labelKey: 'employeeSelfServicePerformance',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essLearningDevelopment',
            svgPath: Assets.icons.employeeSelfService.learning.path,
            labelKey: 'employeeSelfServiceLearningDevelopment',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essDocumentsLetters',
            svgPath: Assets.icons.sectionIconSmall.path,
            labelKey: 'employeeSelfServiceDocumentsLetters',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essRequestsWorkflow',
            svgPath: Assets.icons.sendEmailPurple.path,
            labelKey: 'employeeSelfServiceRequestsWorkflow',
            route: AppRoutes.employeeSelfService,
          ),
          SidebarItem(
            id: 'essMobileExperience',
            svgPath: Assets.icons.employeeSelfService.mobileExperience.path,
            labelKey: 'employeeSelfServiceMobileExperience',
            route: AppRoutes.employeeSelfService,
          ),
        ],
      ),
      SidebarItem(
        id: 'leaveManagement',
        svgPath: Assets.icons.leaveManagementIcon.path,
        labelKey: 'leaveManagement',
        subtitle: 'Leave requests, balance & policies',
        children: [
          SidebarItem(
            id: 'leaveRequests',
            svgPath: Assets.icons.leaveManagement.leaveRequests.path,
            labelKey: 'leaveRequests',
            route: '/leave-management',
            subtitle: 'Submit and approve requests',
          ),
          SidebarItem(
            id: 'leaveBalance',
            svgPath: Assets.icons.leaveManagement.emptyLeave.path,
            labelKey: 'leaveBalance',
            route: '/leave-management',
            subtitle: 'Employee leave balances',
          ),
          SidebarItem(
            id: 'myLeaveBalance',
            svgPath: Assets.icons.leaveManagement.myLeave.path,
            labelKey: 'myLeaveBalance',
            route: '/leave-management',
            subtitle: 'Personal leave overview',
          ),
          SidebarItem(
            id: 'teamLeaveRisk',
            svgPath: Assets.icons.leaveManagement.teamLevel.path,
            labelKey: 'teamLeaveRisk',
            route: '/leave-management',
            subtitle: 'Team absence risk analysis',
          ),
          SidebarItem(
            id: 'leavePolicies',
            svgPath: Assets.icons.leaveManagement.leavePolicy.path,
            labelKey: 'leavePolicies',
            route: '/leave-management',
            subtitle: 'Kuwait Labor Law policies',
          ),
          SidebarItem(
            id: 'policyConfiguration',
            svgPath: Assets.icons.leaveManagement.policyConfiguration.path,
            labelKey: 'policyConfiguration',
            route: '/leave-management',
            subtitle: 'Configure leave eligibility',
          ),
          SidebarItem(
            id: 'forfeitPolicy',
            svgPath: Assets.icons.leaveManagement.forfeitPolicy.path,
            labelKey: 'forfeitPolicy',
            route: '/leave-management',
            subtitle: 'Leave forfeit rules',
          ),
          SidebarItem(
            id: 'forfeitProcessing',
            svgPath: Assets.icons.leaveManagement.forfeitProcessing.path,
            labelKey: 'forfeitProcessing',
            route: '/leave-management',
            subtitle: 'Process leave forfeits',
          ),
          SidebarItem(
            id: 'forfeitReports',
            svgPath: Assets.icons.leaveManagement.forfeitReports.path,
            labelKey: 'forfeitReports',
            route: '/leave-management',
            subtitle: 'Forfeit analytics',
          ),
          SidebarItem(
            id: 'leaveCalendar',
            svgPath: Assets.icons.leaveManagement.leaveCalendar.path,
            labelKey: 'leaveCalendar',
            route: '/leave-management',
            subtitle: 'Team absence calendar',
          ),
        ],
      ),
      SidebarItem(
        id: 'timeTrackingAttendance',
        svgPath: Assets.icons.timeManagementMainIcon.path,
        labelKey: 'timeTrackingAttendance',
        children: [
          SidebarItem(
            id: 'attendance',
            svgPath: Assets.icons.timeManagementMainIcon.path,
            labelKey: 'attendance',
            route: '/time-tracking-and-attendance',
          ),
          SidebarItem(
            id: 'timesheet',
            svgPath: Assets.icons.viewIconBlueFigma.path,
            labelKey: 'timesheet',
            route: '/time-tracking-and-attendance',
          ),
          SidebarItem(
            id: 'overtime',
            svgPath: Assets.icons.attendance.halfDay.path,
            labelKey: 'overtime',
            route: '/time-tracking-and-attendance',
          ),
          SidebarItem(
            id: 'overtimeConfiguration',
            svgPath: Assets.icons.structureConfigurationIcon.path,
            labelKey: 'overtimeConfiguration',
            route: '/time-tracking-and-attendance',
          ),
          SidebarItem(
            id: 'attendanceSummary',
            svgPath: Assets.icons.viewIconBlueFigma.path,
            labelKey: 'attendanceSummary',
            route: '/time-tracking-and-attendance',
          ),
          SidebarItem(
            id: 'geoLocations',
            svgPath: Assets.icons.locationIcon.path,
            labelKey: 'geoLocations',
            route: '/time-tracking-and-attendance',
          ),
          SidebarItem(
            id: 'employeeLocations',
            svgPath: Assets.icons.attendance.mapPin.path,
            labelKey: 'employeeLocations',
            route: '/time-tracking-and-attendance',
          ),
        ],
      ),
      SidebarItem(
        id: 'compensation',
        svgPath: Assets.icons.timeManagementMainIcon.path,
        labelKey: 'compensation',
        children: [
          SidebarItem(
            id: 'gradeStructureManagement',
            svgPath: Assets.icons.structureConfigurationIcon.path,
            labelKey: 'gradeStructureManagement',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'setupAndConfiguration',
            svgPath: Assets.icons.compensation.adjustment.path,
            labelKey: 'setupAndConfiguration',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'localization',
            svgPath: Assets.icons.compensation.localization.path,
            labelKey: 'localization',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'components',
            svgPath: Assets.icons.compensation.components.path,
            labelKey: 'components',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'manageSalaryStructure',
            svgPath: Assets.icons.compensation.layers.path,
            labelKey: 'manageSalaryStructure',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'compensationPlans',
            svgPath: Assets.icons.compensation.fileList.path,
            labelKey: 'compensationPlans',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'compensationSimulation',
            svgPath: Assets.icons.compensation.play.path,
            labelKey: 'compensationSimulation',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'employeeCompensation',
            svgPath: Assets.icons.compensation.users.path,
            labelKey: 'employeeCompensation',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'allowancesAndBenefits',
            svgPath: Assets.icons.compensation.gift.path,
            labelKey: 'allowancesAndBenefits',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'bonusesAndIncentives',
            svgPath: Assets.icons.compensation.stock.path,
            labelKey: 'bonusesAndIncentives',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'adjustments',
            svgPath: Assets.icons.compensation.adjustment.path,
            labelKey: 'adjustments',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'bulkAdjustments',
            svgPath: Assets.icons.compensation.layers.path,
            labelKey: 'bulkAdjustments',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'salaryChangeHistory',
            svgPath: Assets.icons.compensation.history.path,
            labelKey: 'salaryChangeHistory',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'meritPlanning',
            svgPath: Assets.icons.compensation.badge.path,
            labelKey: 'meritPlanning',
            route: '/compensation',
          ),
          SidebarItem(
            id: 'revisionHistory',
            svgPath: Assets.icons.compensation.history.path,
            labelKey: 'revisionHistory',
            route: '/compensation',
          ),
        ],
      ),
      SidebarItem(
        id: 'securityManager',
        svgPath: Assets.icons.securityIcon.path,
        labelKey: 'securityManager',
        subtitle: 'Comprehensive Security and Access Control',
        children: [
          SidebarItem(
            id: 'securityOverview',
            svgPath: Assets.icons.securityIcon.path,
            labelKey: 'securityOverview',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'userManagement',
            svgPath: Assets.icons.usersIcon.path,
            labelKey: 'userManagement',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'accessManagement',
            svgPath: Assets.icons.auth.secureShield.path,
            labelKey: 'accessManagement',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'rolesManagement',
            svgPath: Assets.icons.securityManager.applicationRoles.path,
            labelKey: 'rolesManagement',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'securityPolicies',
            svgPath: Assets.icons.manageEnterpriseIcon.path,
            labelKey: 'securityPolicies',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'activeSessions',
            svgPath: Assets.icons.securityManager.activeSession.path,
            labelKey: 'activeSessions',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'securityAlerts',
            svgPath: Assets.icons.securityManager.securityAlerts.path,
            labelKey: 'securityAlerts',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'dataClassification',
            svgPath: Assets.icons.securityManager.dataClassification.path,
            labelKey: 'dataClassification',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'roleDelegation',
            svgPath: Assets.icons.securityManager.roleDelegation.path,
            labelKey: 'roleDelegation',
            route: '/security-console',
          ),
          SidebarItem(
            id: 'segregationOfDuties',
            svgPath: Assets.icons.securityManager.segregation.path,
            labelKey: 'segregationOfDuties',
            route: '/security-console',
          ),
        ],
      ),

      SidebarItem(
        id: 'payroll',
        svgPath: Assets.icons.payrollIcon.path,
        labelKey: 'payroll',
        subtitle: 'Payroll processing & flows',
        children: [
          SidebarItem(
            id: 'payrollPersonResults',
            svgPath: Assets.icons.headPersonIcon.path,
            labelKey: 'payrollPersonResults',
            route: AppRoutes.payroll,
          ),
          SidebarItem(
            id: 'payrollManageElementEntries',
            svgPath: Assets.icons.compensation.link.path,
            labelKey: 'payrollManageElementEntries',
            route: AppRoutes.payroll,
          ),
          SidebarItem(
            id: 'payrollSubmitPayrollFlow',
            svgPath: Assets.icons.uploadProcessIcon.path,
            labelKey: 'payrollSubmitPayrollFlow',
            route: AppRoutes.payroll,
          ),
          SidebarItem(
            id: 'payrollFlowMonitor',
            svgPath: Assets.icons.reportsIcon.path,
            labelKey: 'payrollFlowMonitor',
            route: AppRoutes.payroll,
          ),
        ],
      ),
      SidebarItem(
        id: 'grc',
        svgPath: Assets.icons.complianceIcon.path,
        labelKey: 'grc',
        subtitle: 'Governance, Risk & Compliance',
        children: [
          SidebarItem(
            id: 'grcDashboard',
            labelKey: 'grcDashboard',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/dashboard_icon.svg',
          ),
          SidebarItem(
            id: 'grcLibrary',
            labelKey: 'grcLibrary',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/library_icon.svg',
          ),
          SidebarItem(
            id: 'grcAssets',
            labelKey: 'grcAssets',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/assets_icon.svg',
          ),
          SidebarItem(
            id: 'grcRisks',
            labelKey: 'grcRisks',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/security_icon.svg',
          ),
          SidebarItem(
            id: 'grcAssessments',
            labelKey: 'grcAssessments',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/assessments_icon.svg',
          ),
          SidebarItem(
            id: 'grcControls',
            labelKey: 'grcControls',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/controls_icon.svg',
          ),
          SidebarItem(
            id: 'grcTprm',
            labelKey: 'grcTprm',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/users_icon.svg',
          ),
          SidebarItem(
            id: 'grcPrograms',
            labelKey: 'grcPrograms',
            route: AppRoutes.grc,
            svgPath: 'assets/grc/figma/dashboard/svg/programs_icon.svg',
          ),
        ],
      ),
      SidebarItem(
        id: 'eosCalculator',
        svgPath: Assets.icons.eosCalculatorIcon.path,
        labelKey: 'eosCalculator',
        route: '/eos-calculator',
      ),
      SidebarItem(id: 'reports', svgPath: Assets.icons.reportsIcon.path, labelKey: 'reports', route: '/reports'),
      SidebarItem(
        id: 'governmentForms',
        svgPath: Assets.icons.governmentFormsIcon.path,
        labelKey: 'governmentForms',
        route: '/government-forms',
      ),
      SidebarItem(
        id: 'deiDashboard',
        svgPath: Assets.icons.deiDashboardIcon.path,
        labelKey: 'deiDashboard',
        route: '/dei-dashboard',
      ),
      SidebarItem(
        id: 'hrOperations',
        svgPath: Assets.icons.hrOperationsIcon.path,
        labelKey: 'hrOperations',
        route: '/hr-operations',
      ),
      SidebarItem(
        id: 'settingsConfig',
        svgPath: Assets.icons.settingsIcon.path,
        labelKey: 'settingsConfig',
        route: '/settings',
      ),
      SidebarItem(
        id: 'hiring',
        svgPath: Assets.icons.hiring.jobSeekerIcon.path,
        labelKey: 'hiring',
        subtitle: 'Requisitions, candidates, interviews & more',
        children: [
          SidebarItem(
            id: 'hiringRequisitions',
            svgPath: Assets.icons.sectionIconSmall.path,
            labelKey: 'hiringRequisitions',
            route: AppRoutes.hiring,
          ),
          SidebarItem(
            id: 'hiringCandidates',
            svgPath: Assets.icons.employeeListIcon.path,
            labelKey: 'hiringCandidates',
            route: AppRoutes.hiring,
          ),
          SidebarItem(
            id: 'hiringApplications',
            svgPath: Assets.icons.hiring.assignments.path,
            labelKey: 'hiringApplications',
            route: AppRoutes.hiring,
          ),
          SidebarItem(
            id: 'hiringInterviews',
            svgPath: Assets.icons.employeesAssignedIcon.path,
            labelKey: 'hiringInterviews',
            route: AppRoutes.hiring,
          ),
          SidebarItem(
            id: 'hiringOffers',
            svgPath: Assets.icons.hiring.offers.path,
            labelKey: 'hiringOffers',
            route: AppRoutes.hiring,
          ),
          SidebarItem(
            id: 'hiringHrInterface',
            svgPath: Assets.icons.hiring.hrInterface.path,
            labelKey: 'hiringHrInterface',
            route: AppRoutes.hiring,
          ),
          SidebarItem(
            id: 'hiringCareerSite',
            svgPath: Assets.icons.hiring.careerSite.path,
            labelKey: 'hiringCareerSite',
            route: AppRoutes.hiring,
          ),
        ],
      ),
      SidebarItem(
        id: 'developerTools',
        svgPath: Assets.icons.developerTools.mainIcon.path,
        labelKey: 'developerTools',
        subtitle: 'Function & desktop configuration tools',
        children: [
          SidebarItem(
            id: 'functionManagement',
            svgPath: Assets.icons.developerTools.moduleManagement.path,
            labelKey: 'functionManagement',
            route: AppRoutes.developerTools,
          ),
          SidebarItem(
            id: 'desktopManagement',
            svgPath: Assets.icons.developerTools.desktopManagement.path,
            labelKey: 'desktopManagement',
            route: AppRoutes.developerTools,
          ),
        ],
      ),
    ]);
  }

  static double getChildItemFontSize(String key) {
    switch (key) {
      case 'overview':
        return 15.1;
      case 'analytics':
      case 'manageComponentValues':
      case 'department':
      case 'manageEmployees':
      case 'employeeList':
      case 'addEmployee':
      case 'employeeActions':
      case 'positions':
      case 'leaveManagement':
      case 'attendance':
      case 'timesheet':
      case 'overtime':
      case 'overtimeConfiguration':
      case 'attendanceSummary':
      case 'markAttendance':
      case 'payroll':
      case 'reports':
      case 'settingsConfig':
        return 15.3;
      case 'quickActions':
      case 'company':
      case 'division':
      case 'section':
      case 'workforcePlanning':
      case 'contracts':
      case 'compliance':
      case 'eosCalculator':
      case 'governmentForms':
      case 'deiDashboard':
      case 'hrOperations':
        return 15.4;
      case 'orgStructure':
        return 15.5;
      case 'manageEnterpriseStructure':
        return 15.3;
      default:
        return 15.4;
    }
  }

  static String getLocalizedLabel(String key, AppLocalizations localizations) {
    switch (key) {
      case 'appTitle':
        return localizations.appTitle;
      case 'hrManagement':
        return 'HR Management';
      case 'dashboard':
        return localizations.dashboard;
      case 'overview':
        return 'Overview';
      case 'analytics':
        return 'Analytics';
      case 'quickActions':
        return localizations.quickActions;
      case 'moduleCatalogue':
        return localizations.moduleCatalogue;
      case 'productIntro':
        return localizations.productIntroduction;
      case 'enterpriseStructure':
        return localizations.enterpriseStructure;
      case 'manageEnterpriseStructure':
        return 'Manage Enterprise\nStructure';
      case 'manageComponentValues':
        return localizations.manageComponentValues;
      case 'company':
        return 'Company';
      case 'division':
        return 'Division';
      case 'businessUnit':
        return 'Business Unit';
      case 'department':
        return 'Department';
      case 'section':
        return 'Section';
      case 'workforceStructure':
        return localizations.workforceStructure;
      case 'timeManagement':
        return localizations.timeManagement;
      case 'shifts':
        return 'Shifts';
      case 'workPatterns':
        return 'Work Patterns';
      case 'workSchedules':
        return 'Work Schedules';
      case 'scheduleAssignments':
        return 'Schedule Assignments';
      case 'viewCalendar':
        return 'View Calendar';
      case 'publicHolidays':
        return 'Public Holidays';
      case 'employees':
        return localizations.employees;
      case 'manageEmployees':
        return 'Manage Employees';
      case 'employeeList':
        return 'Employee List';
      case 'addEmployee':
        return 'Add Employee';
      case 'employeeActions':
        return 'Employee Actions';
      case 'orgStructure':
        return 'Org Structure';
      case 'workforcePlanning':
        return 'Workforce Planning';
      case 'positions':
        return 'Positions';
      case 'contracts':
        return 'Contracts';
      case 'markAttendance':
        return 'Mark Attendance';
      case 'leaveManagement':
        return localizations.leaveManagement;
      case 'employeeSelfService':
        return localizations.employeeSelfService;
      case 'employeeSelfServiceProfileIdentity':
        return localizations.employeeSelfServiceProfileIdentity;
      case 'employeeSelfServiceEmploymentInfo':
        return localizations.employeeSelfServiceEmploymentInfo;
      case 'employeeSelfServicePayBenefits':
        return localizations.employeeSelfServicePayBenefits;
      case 'employeeSelfServiceMyPayslips':
        return localizations.employeeSelfServiceMyPayslips;
      case 'employeeSelfServiceLeaveAbsence':
        return localizations.employeeSelfServiceLeaveAbsence;
      case 'employeeSelfServiceTimeAttendance':
        return localizations.employeeSelfServiceTimeAttendance;
      case 'employeeSelfServicePerformance':
        return localizations.employeeSelfServicePerformance;
      case 'employeeSelfServiceLearningDevelopment':
        return localizations.employeeSelfServiceLearningDevelopment;
      case 'employeeSelfServiceDocumentsLetters':
        return localizations.employeeSelfServiceDocumentsLetters;
      case 'employeeSelfServiceRequestsWorkflow':
        return localizations.employeeSelfServiceRequestsWorkflow;
      case 'employeeSelfServiceMobileExperience':
        return localizations.employeeSelfServiceMobileExperience;
      case 'leaveRequests':
        return localizations.leaveRequests;
      case 'leaveBalance':
        return localizations.leaveBalance;
      case 'myLeaveBalance':
        return localizations.myLeaveBalance;
      case 'teamLeaveRisk':
        return localizations.teamLeaveRisk;
      case 'leavePolicies':
        return localizations.leavePolicies;
      case 'policyConfiguration':
        return localizations.policyConfiguration;
      case 'forfeitPolicy':
        return localizations.forfeitPolicy;
      case 'forfeitProcessing':
        return localizations.forfeitProcessing;
      case 'forfeitReports':
        return localizations.forfeitReports;
      case 'leaveCalendar':
        return localizations.leaveCalendar;
      case 'timeTrackingAttendance':
        return 'Time Tracking & Attendance';
      case 'attendance':
        return 'Daily Attendance';
      case 'timesheet':
        return 'Time Sheets';
      case 'overtime':
        return 'Overtime';
      case 'overtimeConfiguration':
        return 'Overtime Configuration';
      case 'attendanceSummary':
        return 'Attendance Summary';
      case 'geoLocations':
        return 'Geo Locations';
      case 'employeeLocations':
        return 'View Employee Location';
      case 'compensation':
        return 'Compensation';
      case 'gradeStructureManagement':
        return 'Grade Structure Management';
      case 'setupAndConfiguration':
        return 'Setup & Configuration';
      case 'localization':
        return 'Localization';
      case 'components':
        return 'Components';
      case 'manageSalaryStructure':
        return 'Manage Salary Structure';
      case 'compensationPlans':
        return 'Compensation Plans';
      case 'compensationSimulation':
        return 'Compensation Simulation';
      case 'employeeCompensation':
        return 'Employee Compensation';
      case 'allowancesAndBenefits':
        return 'Allowances & Benefits';
      case 'bonusesAndIncentives':
        return 'Bonuses & Incentives';
      case 'adjustments':
        return 'Adjustments';
      case 'bulkAdjustments':
        return 'Bulk Adjustments';
      case 'salaryChangeHistory':
        return 'Salary Change History';
      case 'stockOptions':
        return 'Stock Options';
      case 'meritPlanning':
        return 'Merit Planning';
      case 'revisionHistory':
        return 'Revision History';
      case 'securityManager':
        return 'Security Manager';
      case 'securityOverview':
        return 'Security Overview';
      case 'userManagement':
        return 'User Management';
      case 'accessManagement':
        return 'Access Management';
      case 'rolesManagement':
        return 'Roles Management';
      case 'securityPolicies':
        return localizations.securityPolicies;
      case 'activeSessions':
        return localizations.activeSessions;
      case 'securityAlerts':
        return localizations.securityAlerts;
      case 'dataClassification':
        return 'Data Classification';
      case 'roleDelegation':
        return 'Role Delegation';
      case 'segregationOfDuties':
        return localizations.segregationOfDuties;
      case 'hiring':
        return localizations.hiring;
      case 'hiringRequisitions':
        return localizations.hiringRequisitions;
      case 'hiringCandidates':
        return localizations.hiringCandidates;
      case 'hiringApplications':
        return localizations.hiringApplications;
      case 'hiringInterviews':
        return localizations.hiringInterviews;
      case 'hiringOffers':
        return localizations.hiringOffers;
      case 'hiringHrInterface':
        return localizations.hiringHrInterface;
      case 'hiringCareerSite':
        return localizations.hiringCareerSite;
      case 'developerTools':
        return 'Developer Tools';
      case 'functionManagement':
        return 'Function';
      case 'desktopManagement':
        return 'Desktop Management';
      case 'payroll':
        return localizations.payroll;
      case 'payrollPersonResults':
        return localizations.payrollPersonResults;
      case 'payrollManageElementEntries':
        return localizations.payrollManageElementEntries;
      case 'payrollSubmitPayrollFlow':
        return localizations.payrollSubmitPayrollFlow;
      case 'payrollFlowMonitor':
        return localizations.payrollFlowMonitor;
      case 'grc':
        return localizations.grc;
      case 'grcDashboard':
        return localizations.grcDashboard;
      case 'grcLibrary':
        return localizations.grcLibrary;
      case 'grcAssets':
        return localizations.grcAssets;
      case 'grcRisks':
        return localizations.grcRisks;
      case 'grcAssessments':
        return localizations.grcAssessments;
      case 'grcControls':
        return localizations.grcControls;
      case 'grcTprm':
        return localizations.grcTprm;
      case 'grcPrograms':
        return localizations.grcPrograms;
      case 'compliance':
        return localizations.grc;
      case 'eosCalculator':
        return localizations.eosCalculator;
      case 'reports':
        return localizations.reports;
      case 'governmentForms':
        return localizations.governmentForms;
      case 'deiDashboard':
        return localizations.deiDashboard;
      case 'hrOperations':
        return localizations.hrOperations;
      case 'settingsConfig':
        return '${localizations.settings} &\nConfigurations';
      case 'kuwaitLaborLaw':
        return 'Kuwait Labor Law';
      case 'fullyCompliant':
        return 'Fully Compliant System';
      case 'jobFamilies':
        return localizations.jobFamilies;
      case 'jobLevels':
        return localizations.jobLevels;
      case 'gradeStructure':
        return localizations.gradeStructure;
      case 'reportingStructure':
        return localizations.reportingStructure;
      case 'positionTree':
        return localizations.positionTree;
      case 'payrollFlows':
        return 'Payroll Flows';
      case 'absenceRequests':
        return 'Absence Requests';
      default:
        return key;
    }
  }

  static String? getLocalizedDescription(String key, AppLocalizations localizations) {
    switch (key) {
      case 'grcDashboard':
        return localizations.grcDashboardDescription;
      case 'grcLibrary':
        return localizations.grcLibraryDescription;
      case 'grcAssets':
        return localizations.grcAssetsDescription;
      case 'grcRisks':
        return localizations.grcRisksDescription;
      case 'grcAssessments':
        return localizations.grcAssessmentsDescription;
      case 'grcControls':
        return localizations.grcControlsDescription;
      case 'grcTprm':
        return localizations.grcTprmDescription;
      case 'grcPrograms':
        return localizations.grcProgramsDescription;
      default:
        return null;
    }
  }
}
