mixin TabIndexMixin {
  int? getTimeManagementTabIndex(String itemId) {
    switch (itemId) {
      case 'shifts':
        return 0;
      case 'workPatterns':
        return 1;
      case 'workSchedules':
        return 2;
      case 'scheduleAssignments':
        return 3;
      case 'viewCalendar':
        return 4;
      case 'publicHolidays':
        return 5;
      default:
        return null;
    }
  }

  int? getWorkforceStructureTabIndex(String itemId) {
    switch (itemId) {
      case 'positions':
        return 0;
      case 'jobFamilies':
        return 1;
      case 'jobLevels':
        return 2;
      case 'gradeStructure':
        return 3;
      case 'reportingStructure':
        return 4;
      case 'positionTree':
        return 5;
      default:
        return null;
    }
  }

  int? getLeaveManagementTabIndex(String itemId) {
    switch (itemId) {
      case 'leaveRequests':
        return 0;
      case 'leaveBalance':
        return 1;
      case 'myLeaveBalance':
        return 2;
      case 'teamLeaveRisk':
        return 3;
      case 'leavePolicies':
        return 4;
      case 'policyConfiguration':
        return 5;
      case 'forfeitPolicy':
        return 6;
      case 'forfeitProcessing':
        return 7;
      case 'forfeitReports':
        return 8;
      case 'leaveCalendar':
        return 9;
      default:
        return null;
    }
  }

  int? getEmployeeManagementTabIndex(String itemId) {
    switch (itemId) {
      case 'manageEmployees':
        return 0;
      case 'employeeActions':
        return 1;
      case 'workforcePlanning':
        return 2;
      case 'contracts':
        return 3;
      case 'markAttendance':
        return 4;
      default:
        return null;
    }
  }

  int? getEmployeeSelfServiceTabIndex(String itemId) {
    switch (itemId) {
      case 'essProfileIdentity':
        return 0;
      case 'essEmploymentInfo':
        return 1;
      case 'essPayBenefits':
        return 2;
      case 'essMyPayslips':
        return 3;
      case 'essLeaveAbsence':
        return 4;
      case 'essTimeAttendance':
        return 5;
      case 'essPerformance':
        return 6;
      case 'essLearningDevelopment':
        return 7;
      case 'essDocumentsLetters':
        return 8;
      case 'essRequestsWorkflow':
        return 9;
      case 'essMobileExperience':
        return 10;
      default:
        return null;
    }
  }

  int? getEnterpriseStructureTabIndex(String itemId) {
    switch (itemId) {
      case 'manageEnterpriseStructure':
        return 0;
      case 'manageComponentValues':
        return 1;
      case 'company':
        return 2;
      case 'division':
        return 3;
      case 'businessUnit':
        return 4;
      case 'department':
        return 5;
      case 'section':
        return 6;
      default:
        return null;
    }
  }

  int? getTimeTrackingAndAttendanceTabIndex(String itemId) {
    switch (itemId) {
      case 'attendance':
        return 0;
      case 'timesheet':
        return 1;
      case 'overtime':
        return 2;
      case 'overtimeConfiguration':
        return 3;
      case 'attendanceSummary':
        return 4;
      case 'geoLocations':
        return 5;
      case 'employeeLocations':
        return 6;
      default:
        return null;
    }
  }

  int? getCompensationTabIndex(String itemId) {
    switch (itemId) {
      case 'gradeStructureManagement':
        return 0;
      case 'setupAndConfiguration':
        return 1;
      case 'localization':
        return 2;
      case 'components':
        return 3;
      case 'manageSalaryStructure':
        return 4;
      case 'compensationPlans':
        return 5;
      case 'compensationSimulation':
        return 6;
      case 'employeeCompensation':
        return 7;
      case 'allowancesAndBenefits':
        return 8;
      case 'bonusesAndIncentives':
        return 9;
      case 'adjustments':
        return 10;
      case 'bulkAdjustments':
        return 11;
      case 'salaryChangeHistory':
        return 12;
      case 'meritPlanning':
        return 13;
      case 'revisionHistory':
        return 14;
      default:
        return null;
    }
  }

  int? getSecurityManagerTabIndex(String itemId) {
    switch (itemId) {
      case 'securityOverview':
        return 0;
      case 'userManagement':
        return 1;
      case 'accessManagement':
        return 2;
      case 'rolesManagement':
        return 3;
      case 'securityPolicies':
        return 4;
      case 'activeSessions':
        return 5;
      case 'securityAlerts':
        return 6;
      case 'dataClassification':
        return 7;
      case 'roleDelegation':
        return 8;
      case 'segregationOfDuties':
        return 9;
      default:
        return null;
    }
  }

  int? getHiringTabIndex(String itemId) {
    switch (itemId) {
      case 'hiringRequisitions':
        return 0;
      case 'hiringCandidates':
        return 1;
      case 'hiringApplications':
        return 2;
      case 'hiringInterviews':
        return 3;
      case 'hiringOffers':
        return 4;
      case 'hiringHrInterface':
        return 5;
      case 'hiringCareerSite':
        return 6;
      default:
        return null;
    }
  }

  int? getDeveloperToolsTabIndex(String itemId) {
    switch (itemId) {
      case 'functionManagement':
        return 0;
      case 'desktopManagement':
        return 1;
      default:
        return null;
    }
  }

  int? getPayrollTabIndex(String itemId) {
    switch (itemId) {
      case 'payrollPersonResults':
        return 0;
      case 'payrollManageElementEntries':
        return 1;
      case 'payrollSubmitPayrollFlow':
        return 2;
      case 'payrollFlowMonitor':
        return 3;
      default:
        return null;
    }
  }

  int? getGrcTabIndex(String itemId) {
    switch (itemId) {
      case 'grcDashboard':
        return 0;
      case 'grcLibrary':
        return 1;
      case 'grcAssets':
        return 2;
      case 'grcRisks':
        return 3;
      case 'grcAssessments':
        return 4;
      case 'grcControls':
        return 5;
      case 'grcTprm':
        return 6;
      case 'grcPrograms':
        return 7;
      default:
        return null;
    }
  }
}
