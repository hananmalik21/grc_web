import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/states/person_result_task_detail_messages_state.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_message_row_data.dart';

List<PersonResultTaskDetailMessageRowData> buildMessageRows(AppLocalizations loc) {
  final payrollRelationship = loc.payrollPersonResultsTaskDetailMessagesPayrollRelationshipValue;
  final processTimestamp = loc.payrollPersonResultsTaskDetailMessagesProcessTimestampValue;
  final taskName = loc.payrollPersonResultsTaskDetailMessagesCalculatePayrollTask;

  return [
    PersonResultTaskDetailMessageRowData(
      id: 'leave-salary-write-off',
      messageText: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOff,
      severity: PersonResultTaskDetailMessageSeverity.warning,
      taskName: taskName,
      payrollElement: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffElement,
      payrollRelationship: payrollRelationship,
      processTimestamp: processTimestamp,
      formulaTrace: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffFormulaTrace,
      suggestedResolution: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryWriteOffResolution,
    ),
    PersonResultTaskDetailMessageRowData(
      id: 'leave-salary-basic-skipped',
      messageText: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkipped,
      severity: PersonResultTaskDetailMessageSeverity.information,
      taskName: taskName,
      payrollElement: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedElement,
      payrollRelationship: payrollRelationship,
      processTimestamp: processTimestamp,
      formulaTrace: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedFormulaTrace,
      suggestedResolution: loc.payrollPersonResultsTaskDetailMessageLeaveSalaryBasicSkippedResolution,
    ),
    PersonResultTaskDetailMessageRowData(
      id: 'nrv-recovery-zero',
      messageText: loc.payrollPersonResultsTaskDetailMessageNrvRecoveryZero,
      severity: PersonResultTaskDetailMessageSeverity.warning,
      taskName: taskName,
      payrollElement: loc.payrollPersonResultsTaskDetailMessageNrvRecoveryZeroElement,
      payrollRelationship: payrollRelationship,
      processTimestamp: processTimestamp,
      formulaTrace: loc.payrollPersonResultsTaskDetailMessageNrvRecoveryZeroFormulaTrace,
      suggestedResolution: loc.payrollPersonResultsTaskDetailMessageNrvRecoveryZeroResolution,
    ),
    PersonResultTaskDetailMessageRowData(
      id: 'air-ticket-info',
      messageText: loc.payrollPersonResultsTaskDetailMessageAirTicketInfo,
      severity: PersonResultTaskDetailMessageSeverity.information,
      taskName: taskName,
      payrollElement: loc.payrollPersonResultsTaskDetailMessageAirTicketInfoElement,
      payrollRelationship: payrollRelationship,
      processTimestamp: processTimestamp,
      formulaTrace: loc.payrollPersonResultsTaskDetailMessageAirTicketInfoFormulaTrace,
      suggestedResolution: loc.payrollPersonResultsTaskDetailMessageAirTicketInfoResolution,
    ),
  ];
}

List<PersonResultTaskDetailMessageRowData> filterMessageRows(
  List<PersonResultTaskDetailMessageRowData> rows,
  PersonResultTaskDetailMessagesState state,
) {
  final query = state.searchQuery.trim().toLowerCase();

  return rows.where((row) {
    final matchesSearch = query.isEmpty || row.messageText.toLowerCase().contains(query);
    final matchesSeverity = switch (state.severityFilter) {
      PersonResultTaskDetailMessageSeverityFilter.all => true,
      PersonResultTaskDetailMessageSeverityFilter.error => row.severity == PersonResultTaskDetailMessageSeverity.error,
      PersonResultTaskDetailMessageSeverityFilter.warning =>
        row.severity == PersonResultTaskDetailMessageSeverity.warning,
      PersonResultTaskDetailMessageSeverityFilter.information =>
        row.severity == PersonResultTaskDetailMessageSeverity.information,
    };

    return matchesSearch && matchesSeverity;
  }).toList();
}

int countMessagesBySeverity(
  List<PersonResultTaskDetailMessageRowData> rows,
  PersonResultTaskDetailMessageSeverity severity,
) {
  return rows.where((row) => row.severity == severity).length;
}
