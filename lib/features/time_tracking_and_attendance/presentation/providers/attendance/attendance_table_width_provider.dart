import 'package:grc/features/time_tracking_and_attendance/data/config/attendance_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AttendanceColumn { employee, department, date, checkIn, checkOut, status, actions }

class AttendanceTableColumnWidths {
  final double? employeeOverride;
  final double? departmentOverride;
  final double? dateOverride;
  final double? checkInOverride;
  final double? checkOutOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const AttendanceTableColumnWidths({
    this.employeeOverride,
    this.departmentOverride,
    this.dateOverride,
    this.checkInOverride,
    this.checkOutOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get employee => employeeOverride ?? AttendanceTableConfig.employeeWidth.w;
  double get department => departmentOverride ?? AttendanceTableConfig.departmentWidth.w;
  double get date => dateOverride ?? AttendanceTableConfig.dateWidth.w;
  double get checkIn => checkInOverride ?? AttendanceTableConfig.checkInWidth.w;
  double get checkOut => checkOutOverride ?? AttendanceTableConfig.checkOutWidth.w;
  double get status => statusOverride ?? AttendanceTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? AttendanceTableConfig.actionsWidth.w;

  AttendanceTableColumnWidths copyWith({
    double? employeeOverride,
    double? departmentOverride,
    double? dateOverride,
    double? checkInOverride,
    double? checkOutOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return AttendanceTableColumnWidths(
      employeeOverride: employeeOverride ?? this.employeeOverride,
      departmentOverride: departmentOverride ?? this.departmentOverride,
      dateOverride: dateOverride ?? this.dateOverride,
      checkInOverride: checkInOverride ?? this.checkInOverride,
      checkOutOverride: checkOutOverride ?? this.checkOutOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final attendanceTableWidthsProvider = StateNotifierProvider<AttendanceTableWidthsNotifier, AttendanceTableColumnWidths>(
  (ref) {
    return AttendanceTableWidthsNotifier();
  },
);

class AttendanceTableWidthsNotifier extends StateNotifier<AttendanceTableColumnWidths> {
  AttendanceTableWidthsNotifier() : super(const AttendanceTableColumnWidths());

  void updateWidth(AttendanceColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case AttendanceColumn.employee:
        state = state.copyWith(employeeOverride: clampWidth(state.employee));
        break;
      case AttendanceColumn.department:
        state = state.copyWith(departmentOverride: clampWidth(state.department));
        break;
      case AttendanceColumn.date:
        state = state.copyWith(dateOverride: clampWidth(state.date));
        break;
      case AttendanceColumn.checkIn:
        state = state.copyWith(checkInOverride: clampWidth(state.checkIn));
        break;
      case AttendanceColumn.checkOut:
        state = state.copyWith(checkOutOverride: clampWidth(state.checkOut));
        break;
      case AttendanceColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case AttendanceColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
