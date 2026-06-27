import 'package:grc/features/time_tracking_and_attendance/data/config/attendance_summary_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AttendanceSummaryColumn { employee, date, checkIn, checkOut, hours, overtime, status, actions }

class AttendanceSummaryTableColumnWidths {
  final double? employeeOverride;
  final double? dateOverride;
  final double? checkInOverride;
  final double? checkOutOverride;
  final double? hoursOverride;
  final double? overtimeOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const AttendanceSummaryTableColumnWidths({
    this.employeeOverride,
    this.dateOverride,
    this.checkInOverride,
    this.checkOutOverride,
    this.hoursOverride,
    this.overtimeOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get employee => employeeOverride ?? AttendanceSummaryTableConfig.employeeWidth.w;
  double get date => dateOverride ?? AttendanceSummaryTableConfig.dateWidth.w;
  double get checkIn => checkInOverride ?? AttendanceSummaryTableConfig.checkInWidth.w;
  double get checkOut => checkOutOverride ?? AttendanceSummaryTableConfig.checkOutWidth.w;
  double get hours => hoursOverride ?? AttendanceSummaryTableConfig.hoursWidth.w;
  double get overtime => overtimeOverride ?? AttendanceSummaryTableConfig.overtimeWidth.w;
  double get status => statusOverride ?? AttendanceSummaryTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? AttendanceSummaryTableConfig.actionsWidth.w;

  AttendanceSummaryTableColumnWidths copyWith({
    double? employeeOverride,
    double? dateOverride,
    double? checkInOverride,
    double? checkOutOverride,
    double? hoursOverride,
    double? overtimeOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return AttendanceSummaryTableColumnWidths(
      employeeOverride: employeeOverride ?? this.employeeOverride,
      dateOverride: dateOverride ?? this.dateOverride,
      checkInOverride: checkInOverride ?? this.checkInOverride,
      checkOutOverride: checkOutOverride ?? this.checkOutOverride,
      hoursOverride: hoursOverride ?? this.hoursOverride,
      overtimeOverride: overtimeOverride ?? this.overtimeOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final attendanceSummaryTableWidthsProvider =
    StateNotifierProvider<AttendanceSummaryTableWidthsNotifier, AttendanceSummaryTableColumnWidths>((ref) {
      return AttendanceSummaryTableWidthsNotifier();
    });

class AttendanceSummaryTableWidthsNotifier extends StateNotifier<AttendanceSummaryTableColumnWidths> {
  AttendanceSummaryTableWidthsNotifier() : super(const AttendanceSummaryTableColumnWidths());

  void updateWidth(AttendanceSummaryColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case AttendanceSummaryColumn.employee:
        state = state.copyWith(employeeOverride: clampWidth(state.employee));
        break;
      case AttendanceSummaryColumn.date:
        state = state.copyWith(dateOverride: clampWidth(state.date));
        break;
      case AttendanceSummaryColumn.checkIn:
        state = state.copyWith(checkInOverride: clampWidth(state.checkIn));
        break;
      case AttendanceSummaryColumn.checkOut:
        state = state.copyWith(checkOutOverride: clampWidth(state.checkOut));
        break;
      case AttendanceSummaryColumn.hours:
        state = state.copyWith(hoursOverride: clampWidth(state.hours));
        break;
      case AttendanceSummaryColumn.overtime:
        state = state.copyWith(overtimeOverride: clampWidth(state.overtime));
        break;
      case AttendanceSummaryColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case AttendanceSummaryColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
