/// Centralized API endpoints for the entire application
/// All endpoints should be defined here to maintain consistency
class ApiEndpoints {
  ApiEndpoints._();

  // Base API path
  static const String api = '/api';

  static String resolveApiPath(String pathOrUrl) {
    final link = pathOrUrl.trim();
    if (link.isEmpty) return link;
    if (link.startsWith('http://') || link.startsWith('https://')) return link;

    final path = link.startsWith('/') ? link : '/$link';
    if (path.startsWith('$api/')) return path;
    return '$api$path';
  }

  // Enterprise Structure endpoints
  static const String structureLevels = '$api/structure-levels';
  static const String hrOrgStructures = '$api/hr-org-structures';
  static const String hrOrgStructuresActiveLevels =
      '$hrOrgStructures/active/levels';
  static String hrOrgStructuresUnitsByLevel(String levelCode) =>
      '$hrOrgStructuresActiveLevels/$levelCode/units';
  static String hrOrgStructuresUnitsByStructureAndLevel(
    String structureId,
    String levelCode,
  ) => '$hrOrgStructures/$structureId/org-units';
  static String hrOrgStructuresOrgUnitsExport(String structureId) =>
      '$hrOrgStructures/$structureId/org-units/export';
  static String hrOrgStructuresParentUnits(
    String structureId,
    String levelCode,
  ) => '$hrOrgStructures/$structureId/org-units/parents';
  static String hrOrgStructuresCreateUnit(String structureId) =>
      '$hrOrgStructures/$structureId/org-units';
  static String hrOrgStructuresUpdateUnit(
    String structureId,
    String orgUnitId,
  ) => '$hrOrgStructures/$structureId/org-units/$orgUnitId';
  static String hrOrgStructuresDeleteUnit(
    String structureId,
    String orgUnitId,
  ) => '$hrOrgStructures/$structureId/org-units/$orgUnitId';
  static String hrOrgStructuresDelete(String structureId) =>
      '$hrOrgStructures/$structureId';
  static const String hrOrgStructuresActiveUnits =
      '$hrOrgStructures/active/units';
  static const String orgUnitsTreeActive = '$api/org-units/tree/active';
  static const String enterprises = '$api/enterprises';
  static const String companies = '$api/companies';
  static const String divisions = '$api/divisions';
  static const String businessUnits = '$api/business-units';
  static const String departments = '$api/departments';
  static const String enterpriseStats = '$api/enterprise-stats';
  static const String activeStructureStats = '$api/active-structure-stats';

  // Workforce Structure endpoints
  static const String jobFamilies = '$api/job-families';
  static const String jobLevels = '$api/job-levels';
  static const String grades = '$api/grades';
  static const String positions = '$api/positions';
  static const String positionsExport = '$positions/export';
  static const String positionsByOrgUnit = '$positions/by-org-unit';
  static const String reportingRelationships =
      '$positions/reporting-relationships';
  static const String reportingRelationshipsExport =
      '$reportingRelationships/export';
  static const String workforceStats = '$api/workforce-stats';
  static const String employees = '$api/employees';
  static const String employeesExport = '$employees/export';
  static String employeeFullDetails(String employeeGuid) =>
      '$employees/$employeeGuid/full-details';
  static const String createEmployee = '$api/create-employee';
  static String updateEmployee(String employeeGuid) =>
      '$api/update-employee/$employeeGuid';

  // Employee (empl) lookups - demographics, contract type, etc.
  static const String emplLookupTypes = '$api/empl/lookup-types';
  static const String emplLookupValues = '$api/empl/lookup-values';

  // Enterprise (ent) lookups - grade structure, etc. (GRADE_CATEGORY, GRADE_NUMBER)
  static const String entLookupTypes = '$api/ent/lookup-types';
  static const String entLookupValues = '$api/ent/lookup-values';
  static const String entLookupValuesBulk = '$api/ent/lookup-values/bulk';

  // Organization Structure Levels (alias for convenience)
  static const String orgStructureLevels = hrOrgStructuresActiveLevels;

  // Time Management (TM) endpoints
  static const String tmShifts = '$api/tm/shifts';
  static String tmShiftById(int shiftId) => '$tmShifts/$shiftId';
  static const String tmWorkPatterns = '$api/tm/work-patterns';
  static const String tmWorkSchedules = '$api/tm/work-schedules';
  static String tmWorkScheduleById(int scheduleId) =>
      '$tmWorkSchedules/$scheduleId';
  static const String tmScheduleAssignments = '$api/tm/schedule-assignments';
  static String tmScheduleAssignmentById(int scheduleAssignmentId) =>
      '$tmScheduleAssignments/$scheduleAssignmentId';
  static const String tmTimesheets = '$api/tm/timesheets';
  static const String tmTimesheetsExport = '$tmTimesheets/export';
  static const String tmTimesheetsStats = '$tmTimesheets/stats';
  static String tmTimesheetByGuid(String guid) => '$tmTimesheets/$guid';
  static String tmTimesheetApprove(String guid) =>
      '$tmTimesheets/$guid/approve';
  static String tmTimesheetReject(String guid) => '$tmTimesheets/$guid/reject';
  static const String tmPublicHolidays = '$api/holidays';
  static String tmPublicHolidayById(int holidayId) =>
      '$tmPublicHolidays/$holidayId';
  static const String tmStats = '$api/tm/stats';
  static const String tmProjects = '$api/tm/projects';
  static const String tmOvertimeConfiguration = "$api/tm/overtime/configs";
  static String tmOvertimeConfigurationById(String companyId) =>
      '$api/tm/overtime/configuration/$companyId';
  static const String tmOvertimeRateMultiplier = '$api/tm/overtime/rate-types';
  static const String tmOvertimeRequests = '$api/tm/overtime/requests';
  static const String tmOvertimeRequestsExport = '$tmOvertimeRequests/export';
  static String tmOvertimeRequestById(String guid) =>
      '$tmOvertimeRequests/$guid';
  static String tmOvertimeRequestApprove(String guid) =>
      '$tmOvertimeRequests/$guid/approve';
  static String tmOvertimeRequestReject(String guid) =>
      '$tmOvertimeRequests/$guid/reject';
  static String tmOvertimeRequestCancel(String guid) =>
      '$tmOvertimeRequests/$guid/cancel';
  static const String tmTimeZones = '$api/time-zones';
  static const String tmAttendanceLogs = '$api/tm/attendance/logs';
  static const String tmAttendanceLogsExport = '$tmAttendanceLogs/export';
  static const String tmAttendanceLogsByDate =
      '$api/tm/attendance/logs/by-date';
  static const String tmAttendanceManual = '$api/tm/attendance/manual';
  static const String tmAttendanceSummary = '$api/tm/attendance-summary';
  static const String tmAttendanceSummaryExport = '$tmAttendanceSummary/export';

  // Leave Management (ABS) endpoints
  static const String absLeaveRequests = '$api/abs/leave-requests';
  static String absEmployeeLeaveRequests(String employeeGuid) =>
      '$api/abs/employees/$employeeGuid/leave-requests';
  static String absEmployeeLeaveRequestStats(String employeeGuid) =>
      '$api/abs/employees/$employeeGuid/leave-requests/stats';
  static String absLeaveRequestById(String guid) => '$absLeaveRequests/$guid';
  static String absLeaveRequestApprove(String guid) =>
      '$absLeaveRequests/$guid/approve';
  static String absLeaveRequestReject(String guid) =>
      '$absLeaveRequests/$guid/reject';
  static String absLeaveRequestDelete(String guid) => '$absLeaveRequests/$guid';
  static String absLeaveRequestUpdate(String guid) => '$absLeaveRequests/$guid';
  static const String absLeaveTypes = '$api/abs/leave-types';
  static const String absLeaveBalanceTransactions =
      '$api/abs/leave-balance-transactions';
  static const String absLeaveBalances = '$api/abs/leave-balances';
  static const String absLeaveBalancesExport = '$absLeaveBalances/export';
  static const String absEmployeeLeaveBalances =
      '$api/abs/employee-leave-balances';
  static const String absLeaveBalancesAdjust = '$absLeaveBalances/adjust';

  static String absLeaveBalanceUpdate(String employeeLeaveBalanceGuid) =>
      '$absLeaveBalances/$employeeLeaveBalanceGuid';
  static const String absLeavePolicies = '$api/abs/leave-policies';
  static String absLeavePolicyUpdate(String policyGuid) =>
      '$absLeavePolicies/$policyGuid';
  static const String absPolicies = '$api/abs/policies';
  static const String absCreatePolicy = '$api/abs/create-policy';
  static String absUpdatePolicy(String policyGuid) =>
      '$api/abs/update-policy/$policyGuid';
  static const String absLookups = '$api/abs/lookups';
  static String absLookupValues(int lookupId) => '$absLookups/$lookupId/values';

  // Compensation (COMP) endpoints
  static const String compComponents = '$api/comp/components';
  static const String compComponentsExport = '$compComponents/export';
  static const String compSalaryStructuresDetailsExport =
      '$api/comp/salary-structures-details/export';
  static const String compPlansDetailsExport = '$api/comp/plans-details/export';
  static const String compensationSalaryChangeHistoryExport =
      '$api/compensation/salary-change-history/export';
  static const String compEmployeeCompensationExport =
      '$api/comp/employee-compensation/export';
  static const String compPlans = '$api/comp/plans';
  static String compPlanDetails(String planGuid) => '$compPlans/$planGuid';
  static const String compPlanUpdate = '$compensationPlans/update';
  static const String compensationPlans = '$api/compensation/plans';
  static const String compensationPlansCreate = '$compensationPlans/create';
  static String eligiblePlansForEmployee(String employeeGuid) =>
      '$compensationPlans/eligible-for-employee?employee_guid=$employeeGuid';
  static const String compEligiblePlansByCriteria =
      '$api/comp/eligible-plans-by-criteria';
  static const String compEligiblePlansByPosition =
      '$api/comp/eligible-plans-by-position';
  static const String createEmployeeCompensation =
      '/api/comp/employee-compensation/create';
  static const String compSalaryStructures = '$api/comp/salary-structures';
  static String compSalaryStructureByGuid(String structureGuid) =>
      '$compSalaryStructures/$structureGuid';
  static String compSalaryStructureDetails(String structureGuid) =>
      '$api/comp/salary-structures-details/$structureGuid';
  static const String compLookupTypes = '$api/comp/lookup-types';
  static const String compLookupValues = '$api/comp/lookup-values';
  static const String compLookupValuesGraphCounts =
      '$api/comp/lookup-values/graph-counts';
  static const String compEmployeeAssignedComponents =
      '$api/comp/employee-assigned-components';
  static const String compBulkEmployeeComponents =
      '$api/comp/bulk-employee-components';
  static const String compEligiblePlans = '$api/comp/eligible-plans';
  static const String compBulkAdjustments =
      '/api/compensation/bulk-adjustments';
  static const String compEmployeeCompensations =
      '$api/comp/employee-compensation';
  static const String compEmployeeCompensationEdit =
      '$api/comp/employee-compensation/edit';
  static const String compEmployeeLatestComponentHistory =
      '$api/comp/employee/latest-component-history';

  // Employee Compensation (COMP - plan details)
  static const String compEmployeeCompensationPlanDetails =
      '$api/comp/employee/employee-compensation-plan-details';

  // Recruitment (REC) endpoints
  static const String recRequisitions = '$api/rec/requisitions';
  static String recRequisitionByGuid(String requisitionGuid) =>
      '$recRequisitions/$requisitionGuid';
  static const String recRequisitionsExport = '$recRequisitions/export';
  static const String recJobOffers = '$api/rec/job-offers';
  static const String recJobOffersExport = '$recJobOffers/export';
  static String recJobOfferApprove(String offerGuid) =>
      '$recJobOffers/$offerGuid/approve';
  static String recJobOfferExtend(String offerGuid) =>
      '$recJobOffers/$offerGuid/extend';
  static String recJobOfferWithdraw(String offerGuid) =>
      '$recJobOffers/$offerGuid/withdraw';
  static String recJobOfferPdf(String offerGuid) =>
      '$recJobOffers/$offerGuid/pdf';
  static const String recJobPostings = '$api/rec/job-postings';
  static String recJobPostingPause(String postingGuid) =>
      '$recJobPostings/$postingGuid/pause';
  static String recJobPostingActivate(String postingGuid) =>
      '$recJobPostings/$postingGuid/activate';
  static String recJobPostingByGuid(String postingGuid) =>
      '$recJobPostings/$postingGuid';
  static const String recLookupTypes = '$api/rec/lookup-types';
  static const String recLookupValues = '$api/rec/lookup-values';
  static const String recCandidates = '$api/rec/candidates';
  static const String recCandidatesExport = '$recCandidates/export';
  static const String _recCandidateResumeSuffix = '/candidates/resume/';

  static String resolveRecResumePath(String resumeLink) {
    final link = resumeLink.trim();
    if (link.isEmpty) return link;
    if (link.startsWith('http://') || link.startsWith('https://')) return link;

    final path = link.startsWith('/') ? link : '/$link';

    if (path.startsWith('$recCandidates/resume/')) return path;

    final suffixIndex = path.indexOf(_recCandidateResumeSuffix);
    if (suffixIndex != -1) {
      final resumeId = path.substring(
        suffixIndex + _recCandidateResumeSuffix.length,
      );
      return '$recCandidates/resume/$resumeId';
    }

    if (path.startsWith('/rec/candidates/resume/')) {
      return '$api$path';
    }

    final segments = path
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList();
    if (segments.length == 1) {
      return '$recCandidates/resume/${segments.first}';
    }

    return resolveApiPath(link);
  }

  static String recCandidateByGuid(String candidateGuid) =>
      '$recCandidates/$candidateGuid';
  static String recCandidateTalentPools(String candidateGuid) =>
      '${recCandidateByGuid(candidateGuid)}/talent-pools';
  static const String recCandidatesBackgroundCheck =
      '$recCandidates/background-check';
  static const String recCandidatesInterviews = '$recCandidates/interviews';
  static String recCandidateInterviewByGuid(String interviewGuid) =>
      '$recCandidatesInterviews/$interviewGuid';
  static String recCandidateInterviewFeedback(String interviewGuid) =>
      '$recCandidatesInterviews/$interviewGuid/feedback';
  static const String recCandidatesAssessments = '$recCandidates/assessments';
  static String recCandidateAssessmentByGuid(String assessmentGuid) =>
      '$recCandidatesAssessments/$assessmentGuid';
  static const String recTalentPools = '$api/rec/talent-pools';
  static const String recApplications = '$api/recruitment/applications';
  static String recApplicationByGuid(String applicationGuid) =>
      '$recApplications/$applicationGuid';
  static String recApplicationChangeStage(String applicationGuid) =>
      '$recApplications/$applicationGuid/change-stage';
  static String recApplicationNotes(String applicationGuid) =>
      '$recApplications/$applicationGuid/notes';
  static String recApplicationReject(String applicationGuid) =>
      '$recApplications/$applicationGuid/reject';
  static String recApplicationResume(String applicationGuid) =>
      '$recApplications/$applicationGuid/resume';

  // Security Auth endpoints
  static const String securityAuthLogin = '$api/security/auth/login';

  // Security Manager endpoints
  static const String securityJobRoles = '$api/security/job-roles';
  static String securityJobRoleByGuid(String jobRoleGuid) =>
      '$securityJobRoles/$jobRoleGuid';
  static const String securityJobRolesExport = '$securityJobRoles/export';
  static const String securityFunctionRoles = '$api/security/function-roles';
  static String securityFunctionRoleByGuid(String functionRoleGuid) =>
      '$securityFunctionRoles/$functionRoleGuid';
  static const String securityFunctionRolesExport =
      '$securityFunctionRoles/export';
  static const String securityDutyRoles = '$api/security/duty-roles';
  static String securityDutyRoleByGuid(String dutyRoleGuid) =>
      '$securityDutyRoles/$dutyRoleGuid';
  static const String securityDutyRolesExport = '$securityDutyRoles/export';
  static const String securityFunctions = '$api/security/functions';
  static const String securityModules = '$api/security/modules';
  static String securityModuleSubmodules(String moduleGuid) =>
      '$securityModules/$moduleGuid/sub-modules';
  static String securitySubmoduleActions(String subModuleGuid) =>
      '$api/security/actions/sub-modules/$subModuleGuid';
  static const String securityDataRoles = '$api/data-roles';
  static String securityDataRoleByGuid(String dataRoleGuid) =>
      '$securityDataRoles/$dataRoleGuid';
  static const String securityDataRolesExport = '$securityDataRoles/export';
  static const String securityLookupTypes = '$api/security/lookup-types';
  static const String securityLookupValues = '$api/security/lookup-values';
  static const String securityUsers = '$api/security/users';
  static String securityUserByGuid(String userGuid) =>
      '$securityUsers/$userGuid';
  static const String securityCreateUser = '$api/security/users/create';
  static const String securityUpdateUser = '$api/security/users/update';

  // GRC endpoints
  static const String grc = '$api/grc';
  static const String grcLookupTypes = '$grc/lookup-types';
  static const String grcLookupValues = '$grc/lookup-values';
  static const String grcControls = '$grc/controls';
  static const String grcAssets = '$grc/assets';
  static const String grcQuestionCategories = '$grc/question-categories';
  static const String grcQuestionSubcategories = '$grc/question-subcategories';
  static const String grcQuestions = '$grc/questions';

  static String grcControlByGuid(String controlGuid) =>
      '$grcControls/$controlGuid';
  static String grcAssetByGuid(String assetGuid) => '$grcAssets/$assetGuid';
  static String grcQuestionByGuid(String questionGuid) =>
      '$grcQuestions/$questionGuid';
  static String grcQuestionCategoryByGuid(String categoryGuid) =>
      '$grcQuestionCategories/$categoryGuid';
  static String grcQuestionSubcategoryByGuid(String subcategoryGuid) =>
      '$grcQuestionSubcategories/$subcategoryGuid';
  static String grcQuestionCategorySubcategories(String categoryGuid) =>
      '${grcQuestionCategoryByGuid(categoryGuid)}/subcategories';
  static String grcQuestionCategoryQuestions(String categoryGuid) =>
      '${grcQuestionCategoryByGuid(categoryGuid)}/questions';
  static String grcQuestionSubcategoryQuestions(String subcategoryGuid) =>
      '${grcQuestionSubcategoryByGuid(subcategoryGuid)}/questions';
  static String grcLookupTypeValuesByCode(String lookupTypeCode) =>
      '$grcLookupTypes/$lookupTypeCode/values';

  // Payroll (PAY) endpoints
  static const String payLookupValues = '$api/pay/lookups/values';
  static const String payElementEntries = '$api/pay/element-entries';
}
