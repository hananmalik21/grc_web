enum FlowMonitorActivityTab { overallActivities, criticalAlerts, completedWithAlerts, relatedFlows }

enum FlowMonitorTaskType { report, process }

enum FlowMonitorTaskStatus { pending, inProgress, completed }

class FlowMonitorTask {
  const FlowMonitorTask({
    required this.number,
    required this.title,
    required this.type,
    this.status = FlowMonitorTaskStatus.pending,
    this.activity,
    this.submittedBy,
    this.submissionDate,
    this.owner,
    this.loggingLevel,
    this.ownerType,
    this.records,
  });

  final int number;
  final String title;
  final FlowMonitorTaskType type;
  final FlowMonitorTaskStatus status;
  final String? activity;
  final String? submittedBy;
  final String? submissionDate;
  final String? owner;
  final String? loggingLevel;
  final String? ownerType;
  final String? records;

  bool get isCompleted => status == FlowMonitorTaskStatus.completed;
}
