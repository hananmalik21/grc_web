import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';

class ScheduleAssignmentMapper {
  static ScheduleAssignmentTableRowData toTableRowData(ScheduleAssignment assignment) {
    return ScheduleAssignmentTableRowData(
      scheduleAssignmentId: assignment.scheduleAssignmentId,
      assignedToName: assignment.assignedToName,
      assignedToCode: assignment.assignedToCode,
      assignmentLevel: assignment.assignmentLevel,
      scheduleName: assignment.workSchedule?.scheduleNameEn ?? 'N/A',
      startDate: assignment.formattedStartDate,
      endDate: assignment.formattedEndDate,
      isActive: assignment.isActive,
      assignedByName: assignment.assignedByName,
    );
  }

  static List<ScheduleAssignmentTableRowData> toTableRowDataList(List<ScheduleAssignment> assignments) {
    return assignments.map(toTableRowData).toList();
  }
}
