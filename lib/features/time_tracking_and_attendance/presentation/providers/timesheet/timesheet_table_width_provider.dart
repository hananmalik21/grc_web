import 'package:grc/features/time_tracking_and_attendance/data/config/timesheet_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TimesheetColumn { employee, department, weekPeriod, regularHours, overtimeHours, totalHours, status, actions }

class TimesheetTableColumnWidths {
  final double? employeeOverride;
  final double? departmentOverride;
  final double? weekPeriodOverride;
  final double? regularHoursOverride;
  final double? overtimeHoursOverride;
  final double? totalHoursOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const TimesheetTableColumnWidths({
    this.employeeOverride,
    this.departmentOverride,
    this.weekPeriodOverride,
    this.regularHoursOverride,
    this.overtimeHoursOverride,
    this.totalHoursOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get employee => employeeOverride ?? TimesheetTableConfig.employeeWidth.w;
  double get department => departmentOverride ?? TimesheetTableConfig.departmentWidth.w;
  double get weekPeriod => weekPeriodOverride ?? TimesheetTableConfig.weekPeriodWidth.w;
  double get regularHours => regularHoursOverride ?? TimesheetTableConfig.regularHoursWidth.w;
  double get overtimeHours => overtimeHoursOverride ?? TimesheetTableConfig.overtimeHoursWidth.w;
  double get totalHours => totalHoursOverride ?? TimesheetTableConfig.totalHoursWidth.w;
  double get status => statusOverride ?? TimesheetTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? TimesheetTableConfig.actionsWidth.w;

  TimesheetTableColumnWidths copyWith({
    double? employeeOverride,
    double? departmentOverride,
    double? weekPeriodOverride,
    double? regularHoursOverride,
    double? overtimeHoursOverride,
    double? totalHoursOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return TimesheetTableColumnWidths(
      employeeOverride: employeeOverride ?? this.employeeOverride,
      departmentOverride: departmentOverride ?? this.departmentOverride,
      weekPeriodOverride: weekPeriodOverride ?? this.weekPeriodOverride,
      regularHoursOverride: regularHoursOverride ?? this.regularHoursOverride,
      overtimeHoursOverride: overtimeHoursOverride ?? this.overtimeHoursOverride,
      totalHoursOverride: totalHoursOverride ?? this.totalHoursOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final timesheetTableWidthsProvider = StateNotifierProvider<TimesheetTableWidthsNotifier, TimesheetTableColumnWidths>((
  ref,
) {
  return TimesheetTableWidthsNotifier();
});

class TimesheetTableWidthsNotifier extends StateNotifier<TimesheetTableColumnWidths> {
  TimesheetTableWidthsNotifier() : super(const TimesheetTableColumnWidths());

  void updateWidth(TimesheetColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case TimesheetColumn.employee:
        state = state.copyWith(employeeOverride: clampWidth(state.employee));
        break;
      case TimesheetColumn.department:
        state = state.copyWith(departmentOverride: clampWidth(state.department));
        break;
      case TimesheetColumn.weekPeriod:
        state = state.copyWith(weekPeriodOverride: clampWidth(state.weekPeriod));
        break;
      case TimesheetColumn.regularHours:
        state = state.copyWith(regularHoursOverride: clampWidth(state.regularHours));
        break;
      case TimesheetColumn.overtimeHours:
        state = state.copyWith(overtimeHoursOverride: clampWidth(state.overtimeHours));
        break;
      case TimesheetColumn.totalHours:
        state = state.copyWith(totalHoursOverride: clampWidth(state.totalHours));
        break;
      case TimesheetColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case TimesheetColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
