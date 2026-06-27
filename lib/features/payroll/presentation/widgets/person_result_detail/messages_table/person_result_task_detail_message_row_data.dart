import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';

class PersonResultTaskDetailMessageRowData {
  const PersonResultTaskDetailMessageRowData({
    required this.id,
    required this.messageText,
    required this.severity,
    required this.taskName,
    required this.payrollElement,
    required this.payrollRelationship,
    required this.processTimestamp,
    required this.formulaTrace,
    required this.suggestedResolution,
  });

  final String id;
  final String messageText;
  final PersonResultTaskDetailMessageSeverity severity;
  final String taskName;
  final String payrollElement;
  final String payrollRelationship;
  final String processTimestamp;
  final String formulaTrace;
  final String suggestedResolution;
}
