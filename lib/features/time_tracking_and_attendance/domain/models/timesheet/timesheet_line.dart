class TimesheetLine {
  final String workDate;
  final int? projectId;
  final int? taskId;
  final String taskText;
  final double regularHours;
  final double overtimeHours;
  final int? lineId;
  final String? projectName;

  const TimesheetLine({
    required this.workDate,
    this.projectId,
    this.taskId,
    this.taskText = '',
    this.regularHours = 0.0,
    this.overtimeHours = 0.0,
    this.lineId,
    this.projectName,
  });
}
