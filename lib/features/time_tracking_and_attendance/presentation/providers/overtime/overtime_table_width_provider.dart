import 'package:grc/features/time_tracking_and_attendance/data/config/overtime_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum OvertimeColumn { employee, date, type, hours, rate, amount, status, actions }

class OvertimeTableColumnWidths {
  final double? employeeOverride;
  final double? dateOverride;
  final double? typeOverride;
  final double? hoursOverride;
  final double? rateOverride;
  final double? amountOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const OvertimeTableColumnWidths({
    this.employeeOverride,
    this.dateOverride,
    this.typeOverride,
    this.hoursOverride,
    this.rateOverride,
    this.amountOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get employee => employeeOverride ?? OvertimeTableConfig.employeeWidth.w;
  double get date => dateOverride ?? OvertimeTableConfig.dateWidth.w;
  double get type => typeOverride ?? OvertimeTableConfig.typeWidth.w;
  double get hours => hoursOverride ?? OvertimeTableConfig.hoursWidth.w;
  double get rate => rateOverride ?? OvertimeTableConfig.rateWidth.w;
  double get amount => amountOverride ?? OvertimeTableConfig.amountWidth.w;
  double get status => statusOverride ?? OvertimeTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? OvertimeTableConfig.actionsWidth.w;

  OvertimeTableColumnWidths copyWith({
    double? employeeOverride,
    double? dateOverride,
    double? typeOverride,
    double? hoursOverride,
    double? rateOverride,
    double? amountOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return OvertimeTableColumnWidths(
      employeeOverride: employeeOverride ?? this.employeeOverride,
      dateOverride: dateOverride ?? this.dateOverride,
      typeOverride: typeOverride ?? this.typeOverride,
      hoursOverride: hoursOverride ?? this.hoursOverride,
      rateOverride: rateOverride ?? this.rateOverride,
      amountOverride: amountOverride ?? this.amountOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final overtimeTableWidthsProvider = StateNotifierProvider<OvertimeTableWidthsNotifier, OvertimeTableColumnWidths>((
  ref,
) {
  return OvertimeTableWidthsNotifier();
});

class OvertimeTableWidthsNotifier extends StateNotifier<OvertimeTableColumnWidths> {
  OvertimeTableWidthsNotifier() : super(const OvertimeTableColumnWidths());

  void updateWidth(OvertimeColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case OvertimeColumn.employee:
        state = state.copyWith(employeeOverride: clampWidth(state.employee));
        break;
      case OvertimeColumn.date:
        state = state.copyWith(dateOverride: clampWidth(state.date));
        break;
      case OvertimeColumn.type:
        state = state.copyWith(typeOverride: clampWidth(state.type));
        break;
      case OvertimeColumn.hours:
        state = state.copyWith(hoursOverride: clampWidth(state.hours));
        break;
      case OvertimeColumn.rate:
        state = state.copyWith(rateOverride: clampWidth(state.rate));
        break;
      case OvertimeColumn.amount:
        state = state.copyWith(amountOverride: clampWidth(state.amount));
        break;
      case OvertimeColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case OvertimeColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
