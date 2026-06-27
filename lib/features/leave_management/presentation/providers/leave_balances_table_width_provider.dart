import 'package:grc/features/leave_management/data/config/leave_balances_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum LeaveBalancesColumn {
  employeeNumber,
  employee,
  department,
  joinDate,
  annualLeave,
  sickLeave,
  unpaidLeave,
  totalAvailable,
  actions,
}

class LeaveBalancesTableColumnWidths {
  final double? employeeNumberOverride;
  final double? employeeOverride;
  final double? departmentOverride;
  final double? joinDateOverride;
  final double? annualLeaveOverride;
  final double? sickLeaveOverride;
  final double? unpaidLeaveOverride;
  final double? totalAvailableOverride;
  final double? actionsOverride;

  const LeaveBalancesTableColumnWidths({
    this.employeeNumberOverride,
    this.employeeOverride,
    this.departmentOverride,
    this.joinDateOverride,
    this.annualLeaveOverride,
    this.sickLeaveOverride,
    this.unpaidLeaveOverride,
    this.totalAvailableOverride,
    this.actionsOverride,
  });

  double get employeeNumber => employeeNumberOverride ?? LeaveBalancesTableConfig.employeeNumberWidth.w;
  double get employee => employeeOverride ?? LeaveBalancesTableConfig.employeeWidth.w;
  double get department => departmentOverride ?? LeaveBalancesTableConfig.departmentWidth.w;
  double get joinDate => joinDateOverride ?? LeaveBalancesTableConfig.joinDateWidth.w;
  double get annualLeave => annualLeaveOverride ?? LeaveBalancesTableConfig.annualLeaveWidth.w;
  double get sickLeave => sickLeaveOverride ?? LeaveBalancesTableConfig.sickLeaveWidth.w;
  double get unpaidLeave => unpaidLeaveOverride ?? LeaveBalancesTableConfig.unpaidLeaveWidth.w;
  double get totalAvailable => totalAvailableOverride ?? LeaveBalancesTableConfig.totalAvailableWidth.w;
  double get actions => actionsOverride ?? LeaveBalancesTableConfig.actionsWidth.w;

  LeaveBalancesTableColumnWidths copyWith({
    double? employeeNumberOverride,
    double? employeeOverride,
    double? departmentOverride,
    double? joinDateOverride,
    double? annualLeaveOverride,
    double? sickLeaveOverride,
    double? unpaidLeaveOverride,
    double? totalAvailableOverride,
    double? actionsOverride,
  }) {
    return LeaveBalancesTableColumnWidths(
      employeeNumberOverride: employeeNumberOverride ?? this.employeeNumberOverride,
      employeeOverride: employeeOverride ?? this.employeeOverride,
      departmentOverride: departmentOverride ?? this.departmentOverride,
      joinDateOverride: joinDateOverride ?? this.joinDateOverride,
      annualLeaveOverride: annualLeaveOverride ?? this.annualLeaveOverride,
      sickLeaveOverride: sickLeaveOverride ?? this.sickLeaveOverride,
      unpaidLeaveOverride: unpaidLeaveOverride ?? this.unpaidLeaveOverride,
      totalAvailableOverride: totalAvailableOverride ?? this.totalAvailableOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final leaveBalancesTableWidthsProvider =
    StateNotifierProvider<LeaveBalancesTableWidthsNotifier, LeaveBalancesTableColumnWidths>((ref) {
      return LeaveBalancesTableWidthsNotifier();
    });

class LeaveBalancesTableWidthsNotifier extends StateNotifier<LeaveBalancesTableColumnWidths> {
  LeaveBalancesTableWidthsNotifier() : super(const LeaveBalancesTableColumnWidths());

  void updateWidth(LeaveBalancesColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case LeaveBalancesColumn.employeeNumber:
        state = state.copyWith(employeeNumberOverride: clampWidth(state.employeeNumber));
        break;
      case LeaveBalancesColumn.employee:
        state = state.copyWith(employeeOverride: clampWidth(state.employee));
        break;
      case LeaveBalancesColumn.department:
        state = state.copyWith(departmentOverride: clampWidth(state.department));
        break;
      case LeaveBalancesColumn.joinDate:
        state = state.copyWith(joinDateOverride: clampWidth(state.joinDate));
        break;
      case LeaveBalancesColumn.annualLeave:
        state = state.copyWith(annualLeaveOverride: clampWidth(state.annualLeave));
        break;
      case LeaveBalancesColumn.sickLeave:
        state = state.copyWith(sickLeaveOverride: clampWidth(state.sickLeave));
        break;
      case LeaveBalancesColumn.unpaidLeave:
        state = state.copyWith(unpaidLeaveOverride: clampWidth(state.unpaidLeave));
        break;
      case LeaveBalancesColumn.totalAvailable:
        state = state.copyWith(totalAvailableOverride: clampWidth(state.totalAvailable));
        break;
      case LeaveBalancesColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
