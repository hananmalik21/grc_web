import 'package:grc/core/config/spreadsheet_export_config.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/api_endpoints.dart';

class SpreadsheetExportConfigs {
  SpreadsheetExportConfigs._();

  static SpreadsheetExportConfig leaveBalances(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.absLeaveBalancesExport,
      queryParametersBuilder: (enterpriseId) => {'tenant_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'leave_balances_export_$enterpriseId.xlsx',
      successMessage: localizations.leaveBalancesExportSuccess,
      failureMessage: localizations.leaveBalancesExportFailed,
    );
  }

  static SpreadsheetExportConfig employees(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.employeesExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'employees_export_$enterpriseId.xlsx',
      successMessage: localizations.employeesExportSuccess,
      failureMessage: localizations.employeesExportFailed,
    );
  }

  static SpreadsheetExportConfig orgUnits(
    AppLocalizations localizations, {
    required String structureId,
    required String levelCode,
  }) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.hrOrgStructuresOrgUnitsExport(structureId),
      queryParametersBuilder: (enterpriseId) => {'level': levelCode, 'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'org_units_${levelCode.toLowerCase()}_export_$enterpriseId.xlsx',
      successMessage: localizations.orgUnitsExportSuccess,
      failureMessage: localizations.orgUnitsExportFailed,
    );
  }

  static SpreadsheetExportConfig positions(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.positionsExport,
      queryParametersBuilder: (enterpriseId) => {'tenant_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'positions_export_$enterpriseId.xlsx',
      successMessage: localizations.positionsExportSuccess,
      failureMessage: localizations.positionsExportFailed,
    );
  }

  static SpreadsheetExportConfig reportingStructure(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.reportingRelationshipsExport,
      queryParametersBuilder: (enterpriseId) => {'tenant_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'reporting_structure_export_$enterpriseId.xlsx',
      successMessage: localizations.reportingStructureExportSuccess,
      failureMessage: localizations.reportingStructureExportFailed,
    );
  }

  static SpreadsheetExportConfig attendanceLogs(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.tmAttendanceLogsExport,
      queryParametersBuilder: (enterpriseId) => {'enterpriseId': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'attendance_logs_export_$enterpriseId.xlsx',
      successMessage: localizations.attendanceLogsExportSuccess,
      failureMessage: localizations.attendanceLogsExportFailed,
    );
  }

  static SpreadsheetExportConfig attendanceSummary(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.tmAttendanceSummaryExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'attendance_summary_export_$enterpriseId.xlsx',
      successMessage: localizations.attendanceSummaryExportSuccess,
      failureMessage: localizations.attendanceSummaryExportFailed,
    );
  }

  static SpreadsheetExportConfig timesheets(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.tmTimesheetsExport,
      queryParametersBuilder: (enterpriseId) => {'enterpriseId': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'timesheets_export_$enterpriseId.xlsx',
      successMessage: localizations.timesheetsExportSuccess,
      failureMessage: localizations.timesheetsExportFailed,
    );
  }

  static SpreadsheetExportConfig overtimeRequests(AppLocalizations localizations, {String? status}) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.tmOvertimeRequestsExport,
      queryParametersBuilder: (enterpriseId) {
        final params = <String, String>{'tenant_id': enterpriseId.toString()};
        if (status != null && status.isNotEmpty) {
          params['status'] = status;
        }
        return params;
      },
      fileNameBuilder: (enterpriseId) => 'overtime_requests_export_$enterpriseId.xlsx',
      successMessage: localizations.overtimeRequestsExportSuccess,
      failureMessage: localizations.overtimeRequestsExportFailed,
    );
  }

  static SpreadsheetExportConfig compComponents(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.compComponentsExport,
      queryParametersBuilder: (enterpriseId) => {'tenant_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'comp_components_export_$enterpriseId.xlsx',
      successMessage: localizations.compComponentsExportSuccess,
      failureMessage: localizations.compComponentsExportFailed,
    );
  }

  static SpreadsheetExportConfig compSalaryStructuresDetails(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.compSalaryStructuresDetailsExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'salary_structures_export_$enterpriseId.xlsx',
      successMessage: localizations.compSalaryStructuresExportSuccess,
      failureMessage: localizations.compSalaryStructuresExportFailed,
    );
  }

  static SpreadsheetExportConfig compPlansDetails(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.compPlansDetailsExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'compensation_plans_export_$enterpriseId.xlsx',
      successMessage: localizations.compPlansExportSuccess,
      failureMessage: localizations.compPlansExportFailed,
    );
  }

  static SpreadsheetExportConfig compensationSalaryChangeHistory(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.compensationSalaryChangeHistoryExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'salary_change_history_export_$enterpriseId.xlsx',
      successMessage: localizations.compSalaryChangeHistoryExportSuccess,
      failureMessage: localizations.compSalaryChangeHistoryExportFailed,
    );
  }

  static SpreadsheetExportConfig compEmployeeCompensation(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.compEmployeeCompensationExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'employee_compensation_export_$enterpriseId.xlsx',
      successMessage: localizations.compEmployeeCompensationExportSuccess,
      failureMessage: localizations.compEmployeeCompensationExportFailed,
    );
  }

  static SpreadsheetExportConfig jobRoles(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.securityJobRolesExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'job_roles_export_$enterpriseId.xlsx',
      successMessage: localizations.jobRolesExportSuccess,
      failureMessage: localizations.jobRolesExportFailed,
    );
  }

  static SpreadsheetExportConfig dataRoles(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.securityDataRolesExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'data_roles_export_$enterpriseId.xlsx',
      successMessage: localizations.dataRolesExportSuccess,
      failureMessage: localizations.dataRolesExportFailed,
    );
  }

  static SpreadsheetExportConfig dutyRoles(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.securityDutyRolesExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'duty_roles_export_$enterpriseId.xlsx',
      successMessage: localizations.dutyRolesExportSuccess,
      failureMessage: localizations.dutyRolesExportFailed,
    );
  }

  static SpreadsheetExportConfig functionRoles(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.securityFunctionRolesExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'function_roles_export_$enterpriseId.xlsx',
      successMessage: localizations.functionRolesExportSuccess,
      failureMessage: localizations.functionRolesExportFailed,
    );
  }

  static SpreadsheetExportConfig requisitions(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.recRequisitionsExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'requisitions_export_$enterpriseId.xlsx',
      successMessage: localizations.requisitionsExportSuccess,
      failureMessage: localizations.requisitionsExportFailed,
    );
  }

  static SpreadsheetExportConfig candidates(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.recCandidatesExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'candidates_export_$enterpriseId.xlsx',
      successMessage: localizations.candidatesExportSuccess,
      failureMessage: localizations.candidatesExportFailed,
    );
  }

  static SpreadsheetExportConfig jobOffers(AppLocalizations localizations) {
    return SpreadsheetExportConfig(
      endpoint: ApiEndpoints.recJobOffersExport,
      queryParametersBuilder: (enterpriseId) => {'enterprise_id': enterpriseId.toString()},
      fileNameBuilder: (enterpriseId) => 'job_offers_export_$enterpriseId.xlsx',
      successMessage: localizations.jobOffersExportSuccess,
      failureMessage: localizations.jobOffersExportFailed,
    );
  }
}
