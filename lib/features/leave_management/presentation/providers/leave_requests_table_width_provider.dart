import 'package:grc/features/leave_management/data/config/leave_requests_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum LeaveRequestsColumn {
  leaveNumber,
  employeeNumber,
  employee,
  department,
  position,
  leaveType,
  startDate,
  endDate,
  days,
  reason,
  status,
  actions,
}

class LeaveRequestsTableColumnWidths {
  final double? leaveNumberOverride;
  final double? employeeNumberOverride;
  final double? employeeOverride;
  final double? departmentOverride;
  final double? positionOverride;
  final double? leaveTypeOverride;
  final double? startDateOverride;
  final double? endDateOverride;
  final double? daysOverride;
  final double? reasonOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const LeaveRequestsTableColumnWidths({
    this.leaveNumberOverride,
    this.employeeNumberOverride,
    this.employeeOverride,
    this.departmentOverride,
    this.positionOverride,
    this.leaveTypeOverride,
    this.startDateOverride,
    this.endDateOverride,
    this.daysOverride,
    this.reasonOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get leaveNumber => leaveNumberOverride ?? LeaveRequestsTableConfig.leaveNumberWidth.w;
  double get employeeNumber => employeeNumberOverride ?? LeaveRequestsTableConfig.employeeNumberWidth.w;
  double get employee => employeeOverride ?? LeaveRequestsTableConfig.employeeWidth.w;
  double get department => departmentOverride ?? LeaveRequestsTableConfig.departmentWidth.w;
  double get position => positionOverride ?? LeaveRequestsTableConfig.positionWidth.w;
  double get leaveType => leaveTypeOverride ?? LeaveRequestsTableConfig.leaveTypeWidth.w;
  double get startDate => startDateOverride ?? LeaveRequestsTableConfig.startDateWidth.w;
  double get endDate => endDateOverride ?? LeaveRequestsTableConfig.endDateWidth.w;
  double get days => daysOverride ?? LeaveRequestsTableConfig.daysWidth.w;
  double get reason => reasonOverride ?? LeaveRequestsTableConfig.reasonWidth.w;
  double get status => statusOverride ?? LeaveRequestsTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? LeaveRequestsTableConfig.actionsWidth.w;

  LeaveRequestsTableColumnWidths copyWith({
    double? leaveNumberOverride,
    double? employeeNumberOverride,
    double? employeeOverride,
    double? departmentOverride,
    double? positionOverride,
    double? leaveTypeOverride,
    double? startDateOverride,
    double? endDateOverride,
    double? daysOverride,
    double? reasonOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return LeaveRequestsTableColumnWidths(
      leaveNumberOverride: leaveNumberOverride ?? this.leaveNumberOverride,
      employeeNumberOverride: employeeNumberOverride ?? this.employeeNumberOverride,
      employeeOverride: employeeOverride ?? this.employeeOverride,
      departmentOverride: departmentOverride ?? this.departmentOverride,
      positionOverride: positionOverride ?? this.positionOverride,
      leaveTypeOverride: leaveTypeOverride ?? this.leaveTypeOverride,
      startDateOverride: startDateOverride ?? this.startDateOverride,
      endDateOverride: endDateOverride ?? this.endDateOverride,
      daysOverride: daysOverride ?? this.daysOverride,
      reasonOverride: reasonOverride ?? this.reasonOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final leaveRequestsTableWidthsProvider =
    StateNotifierProvider<LeaveRequestsTableWidthsNotifier, LeaveRequestsTableColumnWidths>((ref) {
      return LeaveRequestsTableWidthsNotifier();
    });

class LeaveRequestsTableWidthsNotifier extends StateNotifier<LeaveRequestsTableColumnWidths> {
  LeaveRequestsTableWidthsNotifier() : super(const LeaveRequestsTableColumnWidths());

  void updateWidth(LeaveRequestsColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case LeaveRequestsColumn.leaveNumber:
        state = state.copyWith(leaveNumberOverride: clampWidth(state.leaveNumber));
        break;
      case LeaveRequestsColumn.employeeNumber:
        state = state.copyWith(employeeNumberOverride: clampWidth(state.employeeNumber));
        break;
      case LeaveRequestsColumn.employee:
        state = state.copyWith(employeeOverride: clampWidth(state.employee));
        break;
      case LeaveRequestsColumn.department:
        state = state.copyWith(departmentOverride: clampWidth(state.department));
        break;
      case LeaveRequestsColumn.position:
        state = state.copyWith(positionOverride: clampWidth(state.position));
        break;
      case LeaveRequestsColumn.leaveType:
        state = state.copyWith(leaveTypeOverride: clampWidth(state.leaveType));
        break;
      case LeaveRequestsColumn.startDate:
        state = state.copyWith(startDateOverride: clampWidth(state.startDate));
        break;
      case LeaveRequestsColumn.endDate:
        state = state.copyWith(endDateOverride: clampWidth(state.endDate));
        break;
      case LeaveRequestsColumn.days:
        state = state.copyWith(daysOverride: clampWidth(state.days));
        break;
      case LeaveRequestsColumn.reason:
        state = state.copyWith(reasonOverride: clampWidth(state.reason));
        break;
      case LeaveRequestsColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case LeaveRequestsColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
