import 'package:grc/features/time_management/data/config/schedule_assignments_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ScheduleAssignmentColumn { assignedTo, assignmentLevel, schedule, startDate, endDate, status, assignedBy, actions }

class ScheduleAssignmentsTableColumnWidths {
  final double? assignedToOverride;
  final double? assignmentLevelOverride;
  final double? scheduleOverride;
  final double? startDateOverride;
  final double? endDateOverride;
  final double? statusOverride;
  final double? assignedByOverride;
  final double? actionsOverride;

  const ScheduleAssignmentsTableColumnWidths({
    this.assignedToOverride,
    this.assignmentLevelOverride,
    this.scheduleOverride,
    this.startDateOverride,
    this.endDateOverride,
    this.statusOverride,
    this.assignedByOverride,
    this.actionsOverride,
  });

  double get assignedTo => assignedToOverride ?? ScheduleAssignmentsTableConfig.assignedToWidth.w;
  double get assignmentLevel => assignmentLevelOverride ?? ScheduleAssignmentsTableConfig.assignmentLevelWidth.w;
  double get schedule => scheduleOverride ?? ScheduleAssignmentsTableConfig.scheduleWidth.w;
  double get startDate => startDateOverride ?? ScheduleAssignmentsTableConfig.startDateWidth.w;
  double get endDate => endDateOverride ?? ScheduleAssignmentsTableConfig.endDateWidth.w;
  double get status => statusOverride ?? ScheduleAssignmentsTableConfig.statusWidth.w;
  double get assignedBy => assignedByOverride ?? ScheduleAssignmentsTableConfig.assignedByWidth.w;
  double get actions => actionsOverride ?? ScheduleAssignmentsTableConfig.actionsWidth.w;

  ScheduleAssignmentsTableColumnWidths copyWith({
    double? assignedToOverride,
    double? assignmentLevelOverride,
    double? scheduleOverride,
    double? startDateOverride,
    double? endDateOverride,
    double? statusOverride,
    double? assignedByOverride,
    double? actionsOverride,
  }) {
    return ScheduleAssignmentsTableColumnWidths(
      assignedToOverride: assignedToOverride ?? this.assignedToOverride,
      assignmentLevelOverride: assignmentLevelOverride ?? this.assignmentLevelOverride,
      scheduleOverride: scheduleOverride ?? this.scheduleOverride,
      startDateOverride: startDateOverride ?? this.startDateOverride,
      endDateOverride: endDateOverride ?? this.endDateOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      assignedByOverride: assignedByOverride ?? this.assignedByOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final scheduleAssignmentsTableWidthsProvider =
    StateNotifierProvider<ScheduleAssignmentsTableWidthsNotifier, ScheduleAssignmentsTableColumnWidths>((ref) {
      return ScheduleAssignmentsTableWidthsNotifier();
    });

class ScheduleAssignmentsTableWidthsNotifier extends StateNotifier<ScheduleAssignmentsTableColumnWidths> {
  ScheduleAssignmentsTableWidthsNotifier() : super(const ScheduleAssignmentsTableColumnWidths());

  void updateWidth(ScheduleAssignmentColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case ScheduleAssignmentColumn.assignedTo:
        state = state.copyWith(assignedToOverride: clampWidth(state.assignedTo));
        break;
      case ScheduleAssignmentColumn.assignmentLevel:
        state = state.copyWith(assignmentLevelOverride: clampWidth(state.assignmentLevel));
        break;
      case ScheduleAssignmentColumn.schedule:
        state = state.copyWith(scheduleOverride: clampWidth(state.schedule));
        break;
      case ScheduleAssignmentColumn.startDate:
        state = state.copyWith(startDateOverride: clampWidth(state.startDate));
        break;
      case ScheduleAssignmentColumn.endDate:
        state = state.copyWith(endDateOverride: clampWidth(state.endDate));
        break;
      case ScheduleAssignmentColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case ScheduleAssignmentColumn.assignedBy:
        state = state.copyWith(assignedByOverride: clampWidth(state.assignedBy));
        break;
      case ScheduleAssignmentColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
